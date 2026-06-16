# Functional Coverage Plan: Asynchronous FIFO

## 1. Coverage Points and Crosses

| Covergroup Name | Coverage Point / Cross | Description | Target % |
| :--- | :--- | :--- | :--- |
| `cg_fifo_signals` | `cp_winc` | Coverage of write increment signal transitions | 100% |
| | `cp_rinc` | Coverage of read increment signal transitions | 100% |
| | `cp_wfull` | Coverage of FIFO full flag states | 100% |
| | `cp_rempty` | Coverage of FIFO empty flag states | 100% |
| | `cross_write` | Cross of `winc` and `wfull` to ensure write attempts on full | 100% |
| | `cross_read` | Cross of `rinc` and `rempty` to ensure read attempts on empty | 100% |
| `cg_fifo_data` | `cp_wdata` | Corner case data values (all 0s, all 1s, walking 1s) | 100% |

## 2. SystemVerilog Covergroup Definition

```systemverilog
covergroup fifo_coverage_cg @(posedge wclk);
    option.per_instance = 1;
    option.goal = 100;

    // Write increment coverage
    cp_winc: coverpoint winc {
        bins idle = {1'b0};
        bins active = {1'b1};
    }

    // Full flag coverage
    cp_wfull: coverpoint wfull {
        bins not_full = {1'b0};
        bins full = {1'b1};
    }

    // Cross coverage for write domain
    cross_write: cross cp_winc, cp_wfull {
        bins write_when_full = binsof(cp_winc.active) && binsof(cp_wfull.full);
        bins write_when_not_full = binsof(cp_winc.active) && binsof(cp_wfull.not_full);
    }

    // Data payload corner cases
    cp_wdata: coverpoint wdata {
        bins all_zeros = {'0};
        bins all_ones  = {'1};
        bins walking_ones[] = {8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80};
        bins others    = default;
    }
endgroup

covergroup fifo_read_coverage_cg @(posedge rclk);
    option.per_instance = 1;
    option.goal = 100;

    // Read increment coverage
    cp_rinc: coverpoint rinc {
        bins idle = {1'b0};
        bins active = {1'b1};
    }

    // Empty flag coverage
    cp_rempty: coverpoint rempty {
        bins not_empty = {1'b0};
        bins empty = {1'b1};
    }

    // Cross coverage for read domain
    cross_read: cross cp_rinc, cp_rempty {
        bins read_when_empty = binsof(cp_rinc.active) && binsof(cp_rempty.empty);
        bins read_when_not_empty = binsof(cp_rinc.active) && binsof(cp_rempty.not_empty);
    }
endgroup
```

## 3. Corner Cases to Cover
1. **FIFO Full Write Attempt**: Attempting to write when `wfull` is asserted.
2. **FIFO Empty Read Attempt**: Attempting to read when `rempty` is asserted.
3. **Simultaneous Write and Read**: Writing and reading at the same time when the FIFO is partially full.
4. **Back-to-Back Full and Empty**: Filling the FIFO completely, then immediately emptying it completely.