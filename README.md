# Arty A7 FPGA Project

Learning and experimentation platform targeting the Digilent Arty A7 (Artix-7).

| Tool | Purpose |
|---|---|
| Vivado | Synthesis, implementation, bitstream |
| `arty-build` | Python CLI that drives Vivado in batch mode |
| pytest | Unit tests for Python tooling (no Vivado needed) |
| ruff | Lint + format |
| mypy | Static type-checking |
| Sphinx + Furo | API and project documentation |

## Quick start

```bash
make install        # install Python package + pre-commit hooks
make test           # run unit tests
make build          # synthesise blink design for Arty A7-35
make docs           # build Sphinx HTML docs
```

See `docs/guides/quickstart.rst` for the full guide.

## Repository layout

```
fpga/           RTL sources, constraints, TCL scripts
src/arty/       Installable Python package (build orchestration, report parsing)
tests/          pytest unit tests — all runnable without Vivado
docs/           Sphinx documentation
artifacts/      Git-ignored build outputs (bitstreams, reports, logs)
```

## Adding a new design

1. Create `fpga/rtl/<name>/<name>.v` (and optionally `tb_<name>.v`).
2. Run `make build DESIGN=<name>`.

The TCL flow (`fpga/tcl/synth_impl.tcl`) discovers sources by globbing
`fpga/rtl/<design_name>/`.

## License

MIT
