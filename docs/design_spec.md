# Synchronous FIFO Design Specification

## 1. Module Overview
The `fifo_top` module is a highly parameterized, production-ready Synchronous First-In, First-Out (FIFO) memory queue. It is designed for high-performance on-chip buffering in digital systems, utilizing separate read and write pointers with a dual-port memory architecture.

### Key Features:
- Parameterized data width (`DATA_WIDTH`) and depth (`DEPTH`).
- Synchronous single-clock domain operation.
- Standard status flags: `full` and `empty`.
- Programmable/parameterized threshold status flags: `almost_full` and `almost_empty`.
- Real-time tracking of element count via `data_count`.
- Overflow and underflow protection logic.
- Modular design separating memory storage from pointer control logic.

---

## 2. Block Diagram & File Breakdown
The design is split into three distinct SystemVerilog files to maintain a clean separation of concerns:

1. **`fifo_mem.sv`**: Dual-port synchronous write, combinational read memory array.
2. **`fifo_ctrl.sv`**: Pointer generation, wrap-around tracking, status flag logic, and handshaking protection.
3. **`fifo_top.sv`**: Top-level wrapper instantiating and connecting the memory and controller.

```
                  +-------------------------------------------------+
                  |                    fifo_top                     |
                  |                                                 |
   w_en --------->|   +---------------+         +---------------+   |
   w_data ------->|   |               |-------->|               |   |
                  |   |   fifo_ctrl   |         |   fifo_mem    |---> r_data
   r_en --------->|   |               |-------->|               |   |
                  |   +---------------+         +---------------+   |
                  |          |                                      |
                  |          v                                      |
                  |   Status Flags (full, empty, count, etc.)       |
                  +-------------------------------------------------+
```

---

## 3. Port List

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Master Clock |
| `rst_n` | Input | 1 | Asynchronous Active-Low Reset |
| `w_en` | Input | 1 | Write Enable |
| `w_data` | Input | `DATA_WIDTH` | Write Data Input |
| `r_en` | Input | 1 | Read Enable |
| `r_data` | Output | `DATA_WIDTH` | Read Data Output |
| `full` | Output | 1 | FIFO Full Flag (High when no space left) |
| `empty` | Output | 1 | FIFO Empty Flag (High when no data left) |
| `almost_full` | Output | 1 | FIFO Almost Full Flag (High when count >= `ALMOST_FULL_VAL`) |
| `almost_empty` | Output | 1 | FIFO Almost Empty Flag (High when count <= `ALMOST_EMPTY_VAL`) |
| `data_count` | Output | `$clog2(DEPTH)+1` | Current number of elements in the FIFO |

---

## 4. Functional Description

### Pointer Mathematics & Wrap-Around
To distinguish between "Full" and "Empty" states when the read and write pointers are equal, the pointers are designed with an extra MSB bit (`ADDR_WIDTH + 1` bits wide):
- **Empty Condition**: The write pointer and read pointer are completely identical:
  $$\text{empty} = (w\_ptr == r\_ptr)$$
- **Full Condition**: The LSBs of the pointers match, but the MSBs (wrap-around bits) differ:
  $$\text{full} = (w\_ptr[\text{MSB}] \neq r\_ptr[\text{MSB}]) \land (w\_ptr[\text{LSBs}] == r\_ptr[\text{LSBs}])$$

### Protection Logic
- **Overflow Prevention**: If `w_en` is asserted while `full` is active, the internal write enable to the memory (`mem_w_en`) is suppressed, and the write pointer does not increment.
- **Underflow Prevention**: If `r_en` is asserted while `empty` is active, the read pointer does not increment, preventing data corruption.

---

## 5. Timing Diagram (ASCII)

```
Clock        :   _   _   _   _   _   _   _   _   _   _   _   _   _
               _/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \
rst_n        : __/=================================================
w_en         : ______/===============\___________/=================
w_data       : ------<  D0   ><  D1  >-----------<  D2   >---------
r_en         : __________________________/===============\_________
r_data       : --------------------------<  D0   ><  D1  >---------
empty        : \_________/===================\_____________________
full         : ____________________________________________________
data_count   : 0       | 1   | 2     | 2 | 1     | 0     | 1       
```

---

## 6. Key Design Decisions
1. **Power-of-2 Depth Constraint**: The design enforces that `DEPTH` must be a power of 2. This allows the pointer wrap-around logic to use standard two's complement subtraction for `data_count` calculation without complex modulo arithmetic.
2. **Combinational Read Output**: The memory read port is combinational. This ensures that as soon as a read pointer updates, the data is immediately available on `r_data` in the same cycle, minimizing latency.
3. **Asynchronous Reset**: An asynchronous active-low reset is used to align with industry-standard cell libraries and ensure reliable initialization even in the absence of a stable clock.