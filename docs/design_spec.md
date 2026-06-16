# Synchronous FIFO Design Specification

## 1. Module Overview
The `fifo_top` module is a high-performance, parameterizable, synchronous First-In, First-Out (FIFO) memory buffer designed for modern VLSI systems. It utilizes a First-Word Fall-Through (FWFT) architecture to achieve zero-latency reads, making it ideal for high-throughput data paths.

To ensure clean physical synthesis, modularity, and ease of verification, the design is split into three distinct modules:
1. **`fifo_mem`**: The storage array (SRAM/Register file emulator).
2. **`fifo_ctrl`**: The pointer management and status flag generation logic.
3. **`fifo_top`**: The top-level wrapper that integrates the memory and control logic, applying safety gating to prevent data corruption.

---

## 2. Port List

### `fifo_top` (Top-Level Module)

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | System clock (rising-edge active) |
| `rst_n` | Input | 1 | Asynchronous active-low reset |
| `wr_en` | Input | 1 | Write enable |
| `wr_data` | Input | `[DATA_WIDTH-1:0]` | Write data bus |
| `rd_en` | Input | 1 | Read enable |
| `rd_data` | Output | `[DATA_WIDTH-1:0]` | Read data bus (FWFT style) |
| `full` | Output | 1 | FIFO full flag |
| `empty` | Output | 1 | FIFO empty flag |
| `almost_full` | Output | 1 | FIFO almost full flag |
| `almost_empty`| Output | 1 | FIFO almost empty flag |
| `word_count` | Output | `[ADDR_WIDTH:0]` | Current number of valid words in the FIFO |

---

## 3. Functional Description

### 3.1 First-Word Fall-Through (FWFT) Behavior
Unlike standard FIFOs where data is only available on the cycle after `rd_en` is asserted, this FWFT FIFO makes the oldest unread data immediately available on `rd_data` as soon as it is written. 
- When the FIFO is empty and a write occurs, the data "falls through" to the output on the next clock cycle.
- Asserting `rd_en` advances the internal read pointer to the next data word.

### 3.2 Pointer and Flag Logic
The design uses binary pointers of width `ADDR_WIDTH + 1` (where `ADDR_WIDTH = $clog2(DEPTH)`). The extra MSB is used to distinguish between "Full" and "Empty" states when the pointers wrap around:
- **Empty**: `wr_ptr == rd_ptr`
- **Full**: `wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]` AND `wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]`
- **Word Count**: Calculated as `wr_ptr - rd_ptr`. This subtraction naturally handles wrap-around conditions for power-of-2 depths.

### 3.3 Safety Gating
To prevent memory corruption and pointer desynchronization:
- Write operations are internally gated with `!full`.
- Read operations are internally gated with `!empty`.

---

## 4. Timing Diagram (ASCII)

```
Clock         :   __||__||__||__||__||__||__||__||__||__||__||__||__||__
rst_n         :   ____/=================================================
wr_en         :   ______/=================\_____________________________
wr_data       :   ______X  D0  X  D1  X  D2  X_____________________________
rd_en         :   ________________________/=================\___________
rd_data       :   ________________________X  D0  X  D1  X  D2  X___________
empty         :   ======\___________________________________/===========
full          :   ______________________________________________________
word_count    :   000000X   1  X   2  X   3  X   2  X   1  X   0  X000000
```

---

## 5. File Breakdown

| Filename | Module Name | Purpose |
| :--- | :--- | :--- |
| `fifo_mem.sv` | `fifo_mem` | Dual-port memory array with synchronous write and asynchronous read. |
| `fifo_ctrl.sv` | `fifo_ctrl` | Pointer tracking, word counter, and status flag generation. |
| `fifo_top.sv` | `fifo_top` | Top-level integration and safety gating. |

---

## 6. Key Design Decisions
1. **Power-of-2 Depth Constraint**: Enforcing `DEPTH` to be a power of 2 allows the use of standard binary pointer subtraction for `word_count` calculation, eliminating complex gray-code or modulo counters.
2. **Asynchronous Reset**: Active-low asynchronous reset (`rst_n`) is utilized to match industry-standard ASIC/FPGA cell libraries.
3. **Gated Memory Writes**: Gating `wr_en` with `!full` at the top level ensures that even if the external driver violates protocol and asserts `wr_en` while full, the internal memory remains uncorrupted.