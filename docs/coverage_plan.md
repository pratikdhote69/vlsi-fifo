# Functional Coverage Plan - Synchronous FIFO

## 1. Coverage Strategy
The verification strategy uses SystemVerilog functional coverage to ensure that all operational states, boundary conditions, and concurrent transaction scenarios are fully exercised. The target coverage goal is **100%**.

---

## 2. Functional Coverage Points

| Coverpoint Name | Target Scenario | Description / Bins |
| :--- | :--- | :--- |
| `cp_w_en` | Write Enable Activity | Verifies both active and inactive states of write operations. |
| `cp_r_en` | Read Enable Activity | Verifies both active and inactive states of read operations. |
| `cx_rw` | Concurrent Operations | Cross coverage of `w_en` and `r_en` to verify simultaneous read/write. |
| `cp_data_count` | FIFO Occupancy States | Bins for `empty` (0), `almost_empty` (1-2), `mid_range`, `almost_full` (6-7), and `full` (8). |
| `cp_full` | Full Flag | Verifies that the FIFO reaches maximum capacity. |
| `cp_empty` | Empty Flag | Verifies that the FIFO reaches minimum capacity. |
| `cp_almost_full` | Almost Full Flag | Verifies that the FIFO reaches the high threshold. |
| `cp_almost_empty`| Almost Empty Flag | Verifies that the FIFO reaches the low threshold. |

---

## 3. SystemVerilog Covergroup Implementation

```systemverilog
covergroup fifo_cg @(posedge clk);
    option.per_instance = 1;
    option.goal = 100;

    // Cover write and read enables
    cp_w_en: coverpoint w_en {
        bins idle = {0};
        bins active = {1};
    }
    cp_r_en: coverpoint r_en {
        bins idle = {0};
        bins active = {1};
    }

    // Cross coverage of write and read
    cx_rw: cross cp_w_en, cp_r_en;

    // Cover data count values
    cp_data_count: coverpoint data_count {
        bins empty = {0};
        bins almost_empty = { [1 : ALMOST_EMPTY_VAL] };
        bins mid_range = { [ALMOST_EMPTY_VAL+1 : ALMOST_FULL_VAL-1] };
        bins almost_full = { [ALMOST_FULL_VAL : DEPTH-1] };
        bins full = {DEPTH};
    }

    // Cover status flags
    cp_full: coverpoint full {
        bins inactive = {0};
        bins active = {1};
    }
    cp_empty: coverpoint empty {
        bins inactive = {0};
        bins active = {1};
    }
    cp_almost_full: coverpoint almost_full {
        bins inactive = {0};
        bins active = {1};
    }
    cp_almost_empty: coverpoint almost_empty {
        bins inactive = {0};
        bins active = {1};
    }
endgroup
```