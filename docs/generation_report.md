# AI VLSI Factory — Generation Report

**Module:** `fifo`  
**Request:** Create a FIFO Design  
**Generated:** 2026-06-16 13:21:57  

---

## File Validation

| File | Status | Detail |
|---|---|---|
| `README.md` | ✅ PASS | OK |
| `docs\coverage_plan.md` | ✅ PASS | OK |
| `docs\design_spec.md` | ✅ PASS | OK |
| `docs\generation_report.md` | ✅ PASS | OK |
| `rtl\async_fifo.sv` | ✅ PASS | OK |
| `rtl\fifo_ctrl.sv` | ✅ PASS | OK |
| `rtl\fifo_mem.sv` | ✅ PASS | OK |
| `rtl\fifo_top.sv` | ✅ PASS | OK |
| `rtl\rptr_empty.sv` | ✅ PASS | OK |
| `rtl\sync_ptr.sv` | ✅ PASS | OK |
| `rtl\wptr_full.sv` | ✅ PASS | OK |
| `sva\_sva.sv` | ✅ PASS | OK |

## Simulation Results

**Status:** ✅ PASSED  
**Auto-fix attempts:** 1  

## Generated Files

- `.git\config` (348 bytes)
- `.git\description` (73 bytes)
- `.git\HEAD` (23 bytes)
- `.git\hooks\applypatch-msg.sample` (478 bytes)
- `.git\hooks\commit-msg.sample` (896 bytes)
- `.git\hooks\fsmonitor-watchman.sample` (4726 bytes)
- `.git\hooks\post-update.sample` (189 bytes)
- `.git\hooks\pre-applypatch.sample` (424 bytes)
- `.git\hooks\pre-commit.sample` (1649 bytes)
- `.git\hooks\pre-merge-commit.sample` (416 bytes)
- `.git\hooks\pre-push.sample` (1374 bytes)
- `.git\hooks\pre-rebase.sample` (4898 bytes)
- `.git\hooks\pre-receive.sample` (544 bytes)
- `.git\hooks\prepare-commit-msg.sample` (1492 bytes)
- `.git\hooks\push-to-checkout.sample` (2783 bytes)
- `.git\hooks\sendemail-validate.sample` (2308 bytes)
- `.git\hooks\update.sample` (3650 bytes)
- `.git\index` (1104 bytes)
- `.git\info\exclude` (240 bytes)
- `.git\logs\HEAD` (165 bytes)
- `.git\logs\refs\heads\master` (196 bytes)
- `.git\logs\refs\remotes\origin\main` (152 bytes)
- `.git\objects\21\e40b3be138d264e1ab592300524eb621b4cb59` (1000 bytes)
- `.git\objects\37\d084f8dbdc6d7608750c9b0848dda197bc6881` (319 bytes)
- `.git\objects\4e\b5b2f977042b56887119898aca26f4277dbd8c` (258 bytes)
- `.git\objects\50\c901498e08e890e5a286bea5f69af44bba13fa` (347 bytes)
- `.git\objects\5c\1746fcd931866bcfae5b53696bd65275451fa3` (187 bytes)
- `.git\objects\66\86617fdec30d2a6b644d920b2d4833d45abafb` (549 bytes)
- `.git\objects\6a\d8fd9b6c9bc2323f4a38b2cc33ac586199b0ee` (482 bytes)
- `.git\objects\72\647a17be4ac090a4e558133c2a9bdeb1860911` (51 bytes)
- `.git\objects\7c\ae50f6984a428e542febb9c363433189fa524b` (52 bytes)
- `.git\objects\8e\af2ede59869658294f714cf73524e1d9c1e4e0` (555 bytes)
- `.git\objects\ac\963ae050b3b1ea02e0081987464199abe93cd2` (6772 bytes)
- `.git\objects\b8\ba46376b505be0e362bf2d145d13df313dac2e` (51 bytes)
- `.git\objects\bd\fdd0c4b73fb78c12445925b84f983ac348b619` (898 bytes)
- `.git\objects\c0\bdfe817a960c075fb34ad8707ae937e1766e6f` (1143 bytes)
- `.git\objects\c2\a829c538121a4cac33a73958474bd768dc3df5` (649 bytes)
- `.git\objects\c4\b7232722fdd8e43fc8a4cb12aee1ccad5097e2` (596 bytes)
- `.git\objects\da\5cb7d185885f1675862ce6902736717b977b50` (139 bytes)
- `.git\objects\df\7eb24f7a33d777b4abce807c803bde7f87a18e` (1840 bytes)
- `.git\objects\f0\8d4d5585cf16f43f3f872fe04e0e50c5cdbbe7` (119 bytes)
- `.git\objects\f5\0fe6a532d3479ff1806d5933ceb4fa8d8e1a28` (248 bytes)
- `.git\refs\heads\master` (41 bytes)
- `.git\refs\remotes\origin\main` (41 bytes)
- `.gitignore` (134 bytes)
- `_raw_response_debug.txt` (25498 bytes)
- `docs\coverage_plan.md` (1614 bytes)
- `docs\design_spec.md` (4387 bytes)
- `docs\generation_report.md` (1283 bytes)
- `README.md` (2131 bytes)
- `rtl\async_fifo.sv` (2398 bytes)
- `rtl\fifo_ctrl.sv` (1816 bytes)
- `rtl\fifo_mem.sv` (779 bytes)
- `rtl\fifo_top.sv` (2306 bytes)
- `rtl\rptr_empty.sv` (1480 bytes)
- `rtl\sync_ptr.sv` (665 bytes)
- `rtl\wptr_full.sv` (1530 bytes)
- `sim\sim.vvp` (26556 bytes)
- `sva\_sva.sv` (4000 bytes)

## How to Run

```bash
# Compile
iverilog -g2012 -o sim/sim.vvp rtl/fifo.sv tb/fifo_tb.sv

# Simulate
vvp sim/sim.vvp
```
