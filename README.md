# Synchronous FIFO Design Project

This project implements a highly robust, parameterizable Synchronous FIFO with First-Word Fall-Through (FWFT) behavior, complete with SystemVerilog Assertions (SVA) and a self-checking testbench.

## Directory Structure
```
├── fifo_mem.sv       # Memory storage array submodule
├── fifo_ctrl.sv      # Pointer and flag generation submodule
├── fifo_top.sv       # Top-level wrapper
├── fifo_tb.sv        # Self-checking testbench
├── fifo_sva.sv       # SystemVerilog Assertions (SVA) file
└── README.md         # Project documentation
```

## How to Run Simulation

### Using Icarus Verilog (Open Source)
To compile and run the simulation using Icarus Verilog, execute the following commands in your terminal:

```bash
# Create simulation directory
mkdir -p sim

# Compile all source files and testbench
iverilog -g2012 -o sim/fifo_sim fifo_mem.sv fifo_ctrl.sv fifo_top.sv fifo_tb.sv

# Run simulation
vvp sim/fifo_sim
```

### Viewing Waveforms
To view the generated VCD waveform file using GTKWave:
```bash
gtkwave sim/waves.vcd
```

## Expected Output
When the simulation runs successfully, you should see the following console output:
```
[TB] Reset released at                    51000
[TB] Starting Test Case 1: Reset Verification
[TB] Test Case 1 Passed: Reset state is correct.
[TB] Starting Test Case 2: Single Write and Read
[TB] Wrote 8'hA5. word_count=1, empty=0
[TB] Read completed. word_count=0, empty=1
[TB] Test Case 2 Passed.
[TB] Starting Test Case 3: Fill to Full & Overflow Protection
[TB] FIFO filled. word_count=16, full=1, almost_full=1
[TB] Test Case 3 Passed.
[TB] Starting Test Case 4: Empty to Zero & Underflow Protection
[TB] FIFO emptied. word_count=0, empty=1, almost_empty=1
[TB] Test Case 4 Passed.
[TB] Starting Test Case 5: Simultaneous Write and Read
[TB] Simultaneous RW done. word_count=2 (should be 2)
[TB] Test Case 5 Passed.
[TB] All test cases completed successfully!
```

---
**Author**: Principal VLSI Design Verification Engineer  
**Date**: October 2023