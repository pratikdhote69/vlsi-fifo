# Synchronous FIFO Design Project

This project implements a highly parameterized, production-ready Synchronous FIFO in SystemVerilog. The design is split into modular components to ensure clean synthesis and ease of verification.

## Directory Structure
```
├── fifo_mem.sv       # Dual-port synchronous write, combinational read memory
├── fifo_ctrl.sv      # Pointer generation and status flag logic
├── fifo_top.sv       # Top-level wrapper module
├── fifo_tb.sv        # Self-checking testbench with functional coverage
├── fifo_sva.sv       # SystemVerilog Assertions (SVA) file
└── sim/              # Simulation output directory (created during run)
```

## How to Run Simulation

### Prerequisites
- [Icarus Verilog (iverilog)](http://iverilog.icarus.com/) (v10.0 or newer recommended)
- GTKWave (for waveform viewing)

### Compilation & Execution Commands
Run the following commands in your terminal to compile and run the simulation:

```bash
# Create simulation directory
mkdir -p sim

# Compile all source files and testbench
iverilog -g2012 -o sim/fifo_sim \
    fifo_mem.sv \
    fifo_ctrl.sv \
    fifo_top.sv \
    fifo_sva.sv \
    fifo_tb.sv

# Run the simulation
vvp sim/fifo_sim
```

### Viewing Waveforms
To view the generated waveforms in GTKWave:
```bash
gtkwave sim/waves.vcd &
```

## Expected Output
Upon successful execution, the terminal will display:
```
[TB] --- Test Case 1: Reset Sequence ---
[TB] PASS: Reset state verified.
[TB] --- Test Case 2: Single Write and Read ---
[TB] PASS: Single write successful.
[TB] PASS: Single read successful.
[TB] --- Test Case 3: Fill to Full and Overflow Prevention ---
[TB] PASS: FIFO successfully filled to full.
[TB] PASS: Overflow prevention verified.
[TB] --- Test Case 4: Empty to Empty and Underflow Prevention ---
[TB] PASS: FIFO successfully emptied.
[TB] PASS: Underflow prevention verified.
[TB] --- Test Case 5: Simultaneous Write and Read ---
[TB] FIFO half-full. Starting simultaneous read and write...
[TB] Simultaneous operations complete. Verifying FIFO stability...
[TB] PASS: Simultaneous operations verified.
[TB] All test cases completed successfully!
```

---
**Author:** Principal VLSI Design Verification Engineer  
**Date:** October 2023