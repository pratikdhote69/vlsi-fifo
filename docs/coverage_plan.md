# Functional Coverage Plan

## 1. Coverage Goals
- **Functional Coverage Target**: 100%
- **Assertion Coverage Target**: 100%

## 2. Functional Coverage Points

| Coverpoint Name | Description | Bins / Target Scenarios |
|-----------------|-------------|-------------------------|
| `cp_w_en` | Write Enable activity | `0` (No Write), `1` (Write) |
| `cp_r_en` | Read Enable activity | `0` (No Read), `1` (Read) |
| `cross_rw` | Simultaneous Read/Write | All combinations of `w_en` and `r_en` |
| `cp_full` | Full flag transitions | `0` to `1`, `1` to `0` |
| `cp_empty` | Empty flag transitions | `0` to `1`, `1` to `0` |
| `cp_data_count` | FIFO occupancy levels | `empty` (0), `almost_empty` (1 to 4), `mid` (5 to 11), `almost_full` (12 to 15), `full` (16) |

## 3. SystemVerilog Covergroup Definition

```systemverilog
covergroup fifo_cg @(posedge clk);
    option.per_instance = 1;
    option.goal = 100;

    // Cover write and read enable signals
    cp_w_en: coverpoint w_en {
        bins write_active = {1};
        bins write_idle   = {0};
    }
    cp_r_en: coverpoint r_en {
        bins read_active  = {1};
        bins read_idle    = {0};
    }

    // Cross coverage of simultaneous read and write
    cross_rw: cross cp_w_en, cp_r_en;

    // Cover status flags
    cp_full:  coverpoint full;
    cp_empty: coverpoint empty;
    cp_almost_full:  coverpoint almost_full;
    cp_almost_empty: coverpoint almost_empty;

    // Cover data count transitions
    cp_data_count: coverpoint data_count {
        bins empty_bin        = {0};
        bins almost_empty_bin = {[1:ALMOST_EMPTY_VAL]};
        bins mid_bin          = {[ALMOST_EMPTY_VAL+1:ALMOST_FULL_VAL-1]};
        bins almost_full_bin  = {[ALMOST_FULL_VAL:DEPTH-1]};
        bins full_bin         = {DEPTH};
    }
endgroup
```

## 4. Corner Cases Covered
1. Writing to a completely full FIFO (Overflow protection verification).
2. Reading from a completely empty FIFO (Underflow protection verification).
3. Simultaneous read and write at boundary conditions (e.g., when FIFO is empty or full).
4. Reset assertion mid-transaction.