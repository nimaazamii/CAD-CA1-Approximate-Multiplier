# CAD HW1 — Approximate Multiplier

A Verilog coursework design of an approximate multiplication datapath controlled by a finite-state machine (FSM).

## Repository layout

- `src/hdl/` — top-level multiplier, datapath, controller, registers, counters and memory modules.
- `sim/tb/test_top.v` — top-level simulation testbench.
- `sim/file/data_input.txt` — input memory initialization data.
- `sim/file/data_output_golden.txt` — reference output data supplied with the coursework.
- `sim/sim_top.tcl` — ModelSim/Questa simulation script.

## Simulation

Open ModelSim/Questa in the `sim/` directory and run:

```tcl
do sim_top.tcl
```

The memory initialization path in the HDL is relative to the `sim/` working directory.

## Validation status

The source and supplied testbench are included, but this repository preparation did not establish a fresh, independent simulation pass. The current testbench does not automatically compare every output against the golden file. Treat the supplied golden data as reference input until an automated checker is added.

## Notes

This is a coursework implementation, not a production multiplier IP. 
