# Parameterized Asynchronous FIFO Project

## 1. Project Description
This project implements a robust, parameterized, dual-clock (asynchronous) FIFO in SystemVerilog. It is designed to safely transfer data between two independent clock domains. The design utilizes Gray-coded pointers to prevent metastability issues at the clock domain boundary and contains a complete SystemVerilog Assertion (SVA) suite for protocol verification.

## 2. Directory Structure
```text
├── sync_ptr.sv          # 2-stage DFF synchronizer
├── fifo_mem.sv          # Dual-port memory array
├── wptr_full.sv         # Write pointer and full flag logic
├── rptr_empty.sv        # Read pointer and empty flag logic
├── async_fifo.sv        # Top-level FIFO wrapper
├── async_fifo_tb.sv     # SystemVerilog testbench
├── async_fifo_sva.sv    # SystemVerilog Assertions (bound to DUT)
└── README.md            # Project documentation
```

## 3. How to Run Simulation
You can compile and run the simulation using **Icarus Verilog** (or any standard SystemVerilog simulator like Questa, VCS, or ModelSim).

### Compilation and Execution with Icarus Verilog:
```bash
# Create a simulation directory
mkdir -p sim

# Compile all source files and the testbench
iverilog -g2012 -o sim/async_fifo_sim \
    sync_ptr.sv \
    fifo_mem.sv \
    wptr_full.sv \
    rptr_empty.sv \
    async_fifo.sv \
    async_fifo_tb.sv

# Run the simulation
vvp sim/async_fifo_sim
```

## 4. Expected Output
When running the simulation, you should see the following output in your terminal:

```text
[TB] @                  50: System Reset Released

[TB] --- Test Case 1: Reset Verification ---
SUCCESS: Reset state verified.

[TB] --- Test Case 2: Single Write and Read ---
[TB_WRITE] @                 111: Successfully wrote a5
[TB_READ] @                 166: Successfully read a5
SUCCESS: Single Write/Read verified.

[TB] --- Test Case 3: FIFO Full Condition ---
[TB_WRITE] @                 221: Successfully wrote 0a
[TB_WRITE] @                 231: Successfully wrote 0b
...
[TB_WRITE] @                 371: Successfully wrote 19
SUCCESS: FIFO Full verified.

[TB] --- Test Case 4: FIFO Empty Condition ---
[TB_READ] @                 436: Successfully read 0a
[TB_READ] @                 451: Successfully read 0b
...
[TB_READ] @                 661: Successfully read 19
SUCCESS: FIFO Empty verified.

[TB] --- Test Case 5: Simultaneous Write and Read ---
...
SUCCESS: Simultaneous Write and Read verified.

[TB] All tests completed successfully!
```

## 5. Author and Date
* **Author**: Principal VLSI Design Verification Engineer
* **Date**: October 2023