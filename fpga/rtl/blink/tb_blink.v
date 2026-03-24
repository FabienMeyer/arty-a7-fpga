// tb_blink.v — simple self-checking testbench for blink.v
`timescale 1ns/1ps

module tb_blink;

    // Use a much faster blink rate in simulation (period = 10 clk cycles)
    localparam CLK_HZ  = 100;   // 100 "Hz" for sim speed
    localparam BLINK_HZ = 5;    // flips every 10 cycles

    reg  clk  = 0;
    reg  rst_n = 0;
    wire led0;

    blink #(.CLK_HZ(CLK_HZ), .BLINK_HZ(BLINK_HZ)) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .led0  (led0)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    integer toggle_count = 0;
    reg prev_led = 0;

    initial begin
        $dumpfile("tb_blink.vcd");
        $dumpvars(0, tb_blink);

        // Hold reset for 20 ns
        #20 rst_n = 1;

        // Run long enough to see 4 toggles
        repeat (200) begin
            @(posedge clk);
            if (led0 !== prev_led) begin
                toggle_count = toggle_count + 1;
                prev_led = led0;
            end
        end

        if (toggle_count >= 4)
            $display("PASS: observed %0d LED toggles", toggle_count);
        else
            $display("FAIL: only %0d toggles (expected >= 4)", toggle_count);

        $finish;
    end

endmodule
