# AI VLSI Factory — Generation Report

**Module:** `fifo`  
**Request:** Create a FIFO Design  
**Generated:** 2026-06-16 12:28:28  

---

## File Validation

| File | Status | Detail |
|---|---|---|
| `README.md` | ✅ PASS | OK |
| `docs\coverage_plan.md` | ✅ PASS | OK |
| `docs\design_spec.md` | ✅ PASS | OK |
| `docs\generation_report.md` | ✅ PASS | OK |
| `rtl\async_fifo.sv` | ✅ PASS | OK |
| `rtl\fifo_mem.sv` | ✅ PASS | OK |
| `rtl\rptr_empty.sv` | ✅ PASS | OK |
| `rtl\sync_ptr.sv` | ✅ PASS | OK |
| `rtl\wptr_full.sv` | ✅ PASS | OK |
| `sva\_sva.sv` | ✅ PASS | OK |

## Simulation Results

**Status:** ✅ PASSED  
**Auto-fix attempts:** 0  

## Generated Files

- `_raw_response_debug.txt` (25498 bytes)
- `docs\coverage_plan.md` (2780 bytes)
- `docs\design_spec.md` (4925 bytes)
- `docs\generation_report.md` (954 bytes)
- `README.md` (2743 bytes)
- `rtl\async_fifo.sv` (2247 bytes)
- `rtl\fifo_mem.sv` (836 bytes)
- `rtl\rptr_empty.sv` (1480 bytes)
- `rtl\sync_ptr.sv` (665 bytes)
- `rtl\wptr_full.sv` (1530 bytes)
- `sim\sim.vvp` (17565 bytes)
- `sva\_sva.sv` (3018 bytes)

## How to Run

```bash
# Compile
iverilog -g2012 -o sim/sim.vvp rtl/fifo.sv tb/fifo_tb.sv

# Simulate
vvp sim/sim.vvp
```
