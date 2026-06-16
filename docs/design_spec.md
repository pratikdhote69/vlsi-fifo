# Synchronous FIFO Design Specification

## 1. Module Name and Description
- **Top-Level Module**: `sync_fifo`
- **Sub-Module**: `fifo_mem`
- **Description**: A high-performance, parameterized Synchronous FIFO (First-In, First-Out) buffer designed for modern VLSI applications. It features First-Word Fall-Through (FWFT) combinational read behavior, parameterized depth and data width, status flags (`full`, `empty`), and programmable-like threshold flags (`almost_full`, `almost_empty`).

## 2. Port List

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `clk` | Input | 1 | Master Clock |
| `rst_n` | Input | 1 | Asynchronous Active-Low Reset |
| `w_en` | Input | 1 | Write Enable |
| `w_data` | Input | `DATA_WIDTH` | Write Data Input |
| `r_en` | Input | 1 | Read Enable |
| `r_data` | Output | `DATA_WIDTH` | Read Data Output (FWFT) |
| `full` | Output | 1 | FIFO Full Flag |
| `empty` | Output | 1 | FIFO Empty Flag |
| `almost_full` | Output | 1 | FIFO Almost Full Flag (Threshold-based) |
| `almost_empty`| Output | 1 | FIFO Almost Empty Flag (Threshold-based) |
| `data_count` | Output | `$clog2(DEPTH) + 1` | Current number of elements in the FIFO |

## 3. Functional Description
The design consists of a dual-port memory array (`fifo_mem`) and a FIFO controller (`sync_fifo`). 
- **Pointer Logic**: The write and read pointers use an extra bit (`ADDR_WIDTH + 1`) to easily distinguish between "Full" and "Empty" states without requiring a separate counter register.
- **Status Flags**:
  - `empty` is asserted when the write pointer matches the read pointer exactly.
  - `full` is asserted when the MSBs of the pointers differ but the remaining bits are equal.
  - `data_count` is calculated using modulo subtraction of the pointers: `w_ptr_bin - r_ptr_bin`.
  - `almost_full` is asserted when `data_count >= ALMOST_FULL_VAL`.
  - `almost_empty` is asserted when `data_count <= ALMOST_EMPTY_VAL`.
- **First-Word Fall-Through (FWFT)**: The read data `r_data` is combinationally driven by the memory location pointed to by `r_ptr`. This ensures that the oldest data is immediately available on the output bus without waiting for a read enable pulse, reducing latency in pipeline stages.

## 4. Timing Diagram (ASCII)
```
Clock       :   __    __    __    __    __    __    __    __    __
w_en        :   ______/¯¯¯¯¯\___________/¯¯¯¯¯\_________________
w_data      :   ------< D0  >-----------< D1  >-----------------
r_en        :   __________________/¯¯¯¯¯\___________/¯¯¯¯¯\_____
r_data      :   ------------------< D0  >-----------< D1  >-----
empty       :   ¯¯¯¯¯¯¯¯¯¯¯¯\_________________/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
full        :   ________________________________________________
data_count  :   0     | 1   | 1   | 0   | 1   | 1   | 0   | 0   
```

## 5. File Breakdown
- `fifo_mem.sv`: Parameterized dual-port synchronous write, asynchronous/combinational read memory array.
- `sync_fifo.sv`: Top-level FIFO controller and wrapper.
- `sync_fifo_sva.sv`: SystemVerilog Assertions (SVA) bound to the design for formal/dynamic protocol verification.
- `sync_fifo_tb.sv`: Comprehensive self-checking testbench.

## 6. Key Design Decisions
1. **Asynchronous Active-Low Reset**: Standard in modern ASIC/FPGA flows to ensure reliable initialization.
2. **Pointer-Based Status Generation**: Using `ADDR_WIDTH + 1` pointers avoids the timing path bottleneck of a counter-based status generation in high-frequency designs.
3. **Separation of Memory and Control**: Keeps the memory block clean and easily mappable to technology-specific SRAM/BRAM macros during synthesis.