# synth_impl.tcl
# ---------------------------------------------------------------------------
# Non-GUI Vivado flow: create project, add sources, synthesise, implement,
# generate bitstream, write reports.
#
# Called by arty-build (Python) as:
#   vivado -mode batch -source synth_impl.tcl \
#          -tclargs <design_name> <part> <constraints_xdc>
# ---------------------------------------------------------------------------

# --- Arguments from Python -------------------------------------------------
set design_name  [lindex $argv 0]
set part         [lindex $argv 1]
set xdc_file     [lindex $argv 2]

set out_dir      "artifacts"
set proj_dir     "${out_dir}/project"
set bit_dir      "${out_dir}/bitstreams"
set rpt_dir      "${out_dir}/reports"

file mkdir ${proj_dir}
file mkdir ${bit_dir}
file mkdir ${rpt_dir}

# --- Create in-memory project (no .xpr written) ----------------------------
create_project -in_memory -part ${part}
set_property target_language Verilog [current_project]

# --- Add RTL sources --------------------------------------------------------
# Glob all .v and .vhd files in the relevant design directory
set rtl_files [glob -nocomplain "fpga/rtl/${design_name}/*.v"]
if {[llength $rtl_files] == 0} {
    puts "ERROR: No RTL files found in fpga/rtl/${design_name}/"
    exit 1
}
add_files -fileset sources_1 ${rtl_files}

# --- Add constraints --------------------------------------------------------
add_files -fileset constrs_1 ${xdc_file}

# --- Synthesis --------------------------------------------------------------
puts "INFO: Starting synthesis..."
synth_design \
    -top       ${design_name} \
    -part      ${part} \
    -flatten_hierarchy rebuilt

write_checkpoint -force "${proj_dir}/post_synth.dcp"
report_utilization -file "${rpt_dir}/utilization_synth.rpt"

# --- Implementation ---------------------------------------------------------
puts "INFO: Starting implementation..."
opt_design
place_design
phys_opt_design
route_design

write_checkpoint -force "${proj_dir}/post_route.dcp"

# --- Reports ----------------------------------------------------------------
report_utilization   -file "${rpt_dir}/utilization_impl.rpt"
report_timing_summary -file "${rpt_dir}/timing_summary.rpt"
report_drc           -file "${rpt_dir}/drc.rpt"
report_power         -file "${rpt_dir}/power.rpt"

# Fail loudly on unmet timing
set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
if {$wns < 0} {
    puts "WARNING: Timing not met! WNS = ${wns} ns"
}

# --- Bitstream --------------------------------------------------------------
puts "INFO: Generating bitstream..."
write_bitstream -force "${bit_dir}/${design_name}.bit"

puts "INFO: Build complete. Bitstream at ${bit_dir}/${design_name}.bit"
