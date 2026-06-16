# Design Specification: Parameterized Asynchronous FIFO

## 1. Module Name and Description
* **Module Name**: `async_fifo`
* **Description**: A high-performance, parameterized, dual-clock (asynchronous) FIFO designed for safe multi-bit data transfer between asynchronous clock domains. It utilizes Gray-coded pointers to prevent metastability during clock domain crossing (CDC) and implements a 2-stage synchronizer chain for pointer synchronization.

## 2. Port List

### Write Clock Domain
| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `wclk` | Input | 1 | Write clock domain clock signal |
| `wrst_n` | Input | 1 | Active-low asynchronous reset synchronized to `wclk` |
| `winc` | Input | 1 | Write increment / write enable |
| `wdata` | Input | `DATA_WIDTH` | Data payload to be written into the FIFO |
| `wfull` | Output | 1 | Write full flag (asserted when FIFO is full) |

### Read Clock Domain
| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `rclk` | Input | 1 | Read clock domain clock signal |
| `rrst_n` | Input | 1 | Active-low asynchronous reset synchronized to `rclk` |
| `rinc` | Input | 1 | Read increment / read enable |
| `rdata` | Output | `DATA_WIDTH` | Data payload read from the FIFO |
| `rempty` | Output | 1 | Read empty flag (asserted when FIFO is empty) |

## 3. Functional Description
The Asynchronous FIFO is split into distinct functional blocks to ensure clean synthesis, timing closure, and ease of verification. 

* **Dual-Port Memory (`fifo_mem`)**: An array of size $2^{\text{ADDR\_WIDTH}} \times \text{DATA\_WIDTH}$. Writing is synchronous to `wclk` when `winc` is asserted and `wfull` is low. Reading is asynchronous (combinational) based on the binary read address `raddr` to allow immediate data availability on the read port.
* **Pointer Synchronizers (`sync_ptr`)**: Two-stage D-Flip-Flop synchronizers used to pass the Gray-coded pointers across the clock domains (`wptr` to `rclk` domain, and `rptr` to `wclk` domain).
* **Write Pointer & Full Logic (`wptr_full`)**: Maintains the binary and Gray-coded write pointers. It generates the `wfull` flag by comparing the next write pointer (Gray) with the synchronized read pointer.
* **Read Pointer & Empty Logic (`rptr_empty`)**: Maintains the binary and Gray-coded read pointers. It generates the `rempty` flag by comparing the next read pointer (Gray) with the synchronized write pointer.

### Gray Code Pointer Comparison for Full/Empty
* **Empty Condition**: The FIFO is empty when the read pointer (Gray) equals the synchronized write pointer (Gray).
  $$\text{rempty\_val} = (\text{rptr\_next} == \text{rq2\_wptr})$$
* **Full Condition**: The FIFO is full when the write pointer (Gray) meets the synchronized read pointer (Gray) with the MSB and MSB-1 inverted, and all other bits matching.
  $$\text{wfull\_val} = (\text{wptr\_next} == \{\sim\text{wq2\_rptr}[\text{ADDR\_WIDTH}:\text{ADDR\_WIDTH}-1], \text{wq2\_rptr}[\text{ADDR\_WIDTH}-2:0]\})$$

## 4. Timing Diagram (ASCII)

### Write Operation (wclk domain)
```text
             __    __    __    __    __    __    __    __
wclk      __/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
             _________________
winc      __/                 \_____________________________
          XX  D0   X  D1   X
wdata     XX_______X_______X________________________________
                               _____________________________
wfull     ____________________/
```

### Read Operation (rclk domain)
```text
             __    __    __    __    __    __    __    __
rclk      __/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
                         _________________
rinc      ______________/                 \_________________
          ______________________
rempty                          \___________________________
                                X  D0   X  D1   X
rdata     ----------------------X_______X_______X-----------
```

## 5. File Breakdown
* `sync_ptr.sv`: Generic 2-stage DFF synchronizer.
* `fifo_mem.sv`: Dual-port memory array.
* `wptr_full.sv`: Write pointer generation and full flag logic.
* `rptr_empty.sv`: Read pointer generation and empty flag logic.
* `async_fifo.sv`: Top-level wrapper instantiating all sub-modules.

## 6. Key Design Decisions
1. **Gray Coding**: Pointers are converted to Gray code before crossing clock domains. Since Gray code only changes by 1 bit per transition, it eliminates multi-bit CDC race conditions and prevents false full/empty flag assertions.
2. **Asynchronous Reset**: Asynchronous active-low resets are used to ensure the FIFO can be initialized reliably without requiring active clocks.
3. **Combinational Memory Read**: Reading from the memory array is combinational, allowing the read data to be available immediately when `rinc` is asserted, minimizing latency.