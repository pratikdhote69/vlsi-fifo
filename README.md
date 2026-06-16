# Synchronous FIFO Project

This project implements a highly robust, parameterized Synchronous FIFO with First-Word Fall-Through (FWFT) support, complete with SystemVerilog Assertions (SVA) and a self-checking testbench.

## Directory Structure
```
├── fifo_mem.sv        # Parameterized dual-port memory block
├── sync_fifo.sv       # Top-level FIFO controller
├── sync_fifo_sva.sv   # SystemVerilog Assertions (SVA) bound to RTL
├── sync_fifo_tb.sv    # Self-checking testbench
└── README.md          # Project documentation
```

## How to Run Simulation

### Using Icarus Verilog (v11+)
To compile and run the simulation using Icarus Verilog, execute the following commands:

```bash
# Create simulation directory
mkdir -p sim

# Compile all source files
iverilog -g2012 -o sim/fifo_sim fifo_mem.sv sync_fifo.sv sync_fifo_sva.sv sync_fifo_tb.sv

# Run simulation
vvp sim/fifo_sim
```

### Viewing Waveforms
The simulation generates a VCD waveform file at `sim/waves.vcd`. You can open this file using GTKWave:
```bash
gtkwave sim/waves.vcd
```

## Expected Output
Upon successful execution, the testbench will output:
```
[TB] Asserting Reset...
[TB] Reset De-asserted.
[TB] TEST CASE 1: Verifying Reset State...
[TB] TEST CASE 1 PASSED.
[TB] TEST CASE 2: Single Write and Read...
[TB] TEST CASE 2 PASSED.
[TB] TEST CASE 3: Fill to Full and Overflow Prevention...
[TB] TEST CASE 3 PASSED.
[TB] TEST CASE 4: Empty to Empty and Underflow Prevention...
[TB] TEST CASE 4 PASSED.
[TB] TEST CASE 5: Simultaneous Write and Read...
[TB] TEST CASE 5 PASSED.
[TB] All tests completed successfully!
```

## Author and Date
- **Author**: Principal VLSI Design Verification Engineer
- **Date**: October 2023