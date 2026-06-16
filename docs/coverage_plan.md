# Functional Coverage Plan - Synchronous FIFO

## 1. Coverage Goals
The target functional coverage for this design is **100%**. This ensures that all operational states, flag transitions, and concurrent operations are fully exercised during simulation.

## 2. Functional Coverage Points

| Coverage Point | Description | Expected Bins / Transitions |
| :--- | :--- | :--- |
| `cp_wr_en` | Write Enable activity | `0` (No write), `1` (Write) |
| `cp_rd_en` | Read Enable activity | `0` (No read), `1` (Read) |
| `cross_wr_rd` | Simultaneous Read/Write operations | `(0,0)`, `(0,1)`, `(1,0)`, `(1,1)` |
| `cp_word_count` | FIFO occupancy levels | `empty (0)`, `almost_empty (1-2)`, `mid_range (3-13)`, `almost_full (14-15)`, `full (16)` |
| `cp_full` | Full flag state | `0`, `1` |
| `cp_empty` | Empty flag state | `0`, `1` |
| `cp_almost_full` | Almost Full flag state | `0`, `1` |
| `cp_almost_empty`| Almost Empty flag state | `0`, `1` |

## 3. Corner Cases to Cover
1. **FIFO Overflow Attempt**: Asserting `wr_en` when `full` is active.
2. **FIFO Underflow Attempt**: Asserting `rd_en` when `empty` is active.
3. **Simultaneous Read and Write**:
   - When FIFO is empty (write should succeed, read should be ignored or FWFT-checked).
   - When FIFO is full (read should succeed, write should be ignored).
   - When FIFO is partially full (both read and write succeed, word count remains stable).
4. **Boundary Transitions**:
   - Word count transitioning from `ALMOST_FULL_VAL - 1` to `ALMOST_FULL_VAL`.
   - Word count transitioning from `ALMOST_EMPTY_VAL + 1` to `ALMOST_EMPTY_VAL`.