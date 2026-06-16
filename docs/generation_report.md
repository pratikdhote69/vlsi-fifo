# AI VLSI Factory — Generation Report

**Module:** `fifo`  
**Request:** Create a FIFO Design  
**Generated:** 2026-06-16 15:51:52  

---

## File Validation

| File | Status | Detail |
|---|---|---|
| `README.md` | ✅ PASS | OK |
| `docs\coverage_plan.md` | ✅ PASS | OK |
| `docs\design_spec.md` | ✅ PASS | OK |
| `docs\generation_report.md` | ✅ PASS | OK |
| `rtl\fifo_ctrl.sv` | ✅ PASS | OK |
| `rtl\fifo_mem.sv` | ✅ PASS | OK |
| `rtl\fifo_top.sv` | ✅ PASS | OK |
| `sva\_sva.sv` | ✅ PASS | OK |

## Simulation Results

**Status:** ✅ PASSED  
**Auto-fix attempts:** 0  

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
- `.git\index` (864 bytes)
- `.git\info\exclude` (240 bytes)
- `.git\logs\HEAD` (521 bytes)
- `.git\logs\refs\heads\master` (552 bytes)
- `.git\logs\refs\remotes\origin\main` (152 bytes)
- `.git\objects\04\04c6c7e304278cfee22330c3509e39d6a42448` (1098 bytes)
- `.git\objects\0d\371e9b9829878e17f391fb1698a370cf62b256` (1576 bytes)
- `.git\objects\18\a3d03472e04a7fc129600e27fb53bf11e8395b` (792 bytes)
- `.git\objects\21\e40b3be138d264e1ab592300524eb621b4cb59` (1000 bytes)
- `.git\objects\37\d084f8dbdc6d7608750c9b0848dda197bc6881` (319 bytes)
- `.git\objects\3e\dceffe695a38ac07ce8090bae24e52e134a591` (249 bytes)
- `.git\objects\4e\b5b2f977042b56887119898aca26f4277dbd8c` (258 bytes)
- `.git\objects\4f\1a2c98ef2972f3e09a12fb3694003e8f2df254` (291 bytes)
- `.git\objects\50\c901498e08e890e5a286bea5f69af44bba13fa` (347 bytes)
- `.git\objects\52\37f6896d885754bb1f25db0d52fbdead120198` (139 bytes)
- `.git\objects\5c\1746fcd931866bcfae5b53696bd65275451fa3` (187 bytes)
- `.git\objects\5d\c508b5fa6f7ca52bb7ab5b0d3cbe88b7efbd88` (1929 bytes)
- `.git\objects\66\86617fdec30d2a6b644d920b2d4833d45abafb` (549 bytes)
- `.git\objects\69\3e15296b75e2c691c47df324b632b5773eaa23` (728 bytes)
- `.git\objects\6a\d8fd9b6c9bc2323f4a38b2cc33ac586199b0ee` (482 bytes)
- `.git\objects\6b\994711ec95cec9abeccec760aa26c02f05154f` (1026 bytes)
- `.git\objects\70\98997746bade6e29d93cb4aeda201aa1eec5f8` (294 bytes)
- `.git\objects\72\647a17be4ac090a4e558133c2a9bdeb1860911` (51 bytes)
- `.git\objects\75\496c1f5456eedb5676b98da872490135f6da89` (625 bytes)
- `.git\objects\7c\ae50f6984a428e542febb9c363433189fa524b` (52 bytes)
- `.git\objects\88\331215792f545bd65e60bbc4198ff3cfab491e` (52 bytes)
- `.git\objects\8b\739708c19bbcdbd4fb180413ad7d1bf160f1b8` (826 bytes)
- `.git\objects\8d\78ca09ce451c689a336329047b9babf01518fe` (362 bytes)
- `.git\objects\8e\af2ede59869658294f714cf73524e1d9c1e4e0` (555 bytes)
- `.git\objects\a8\72859fb05925f881a5bde620b24f2395e87619` (139 bytes)
- `.git\objects\a9\3fe6272a8c95249d2cc0fd73d74b6bdf3f420b` (243 bytes)
- `.git\objects\ac\963ae050b3b1ea02e0081987464199abe93cd2` (6772 bytes)
- `.git\objects\b2\8aa23f13aefab1e466168361d38dea044b4173` (987 bytes)
- `.git\objects\b8\ba46376b505be0e362bf2d145d13df313dac2e` (51 bytes)
- `.git\objects\bd\fdd0c4b73fb78c12445925b84f983ac348b619` (898 bytes)
- `.git\objects\c0\bdfe817a960c075fb34ad8707ae937e1766e6f` (1143 bytes)
- `.git\objects\c1\85cdd32b6d1b2d73ea13f50a0acc7480489c92` (427 bytes)
- `.git\objects\c2\a829c538121a4cac33a73958474bd768dc3df5` (649 bytes)
- `.git\objects\c4\b7232722fdd8e43fc8a4cb12aee1ccad5097e2` (596 bytes)
- `.git\objects\c7\c467ee976f04554c2fb33c7269c80415231778` (1906 bytes)
- `.git\objects\cc\ce92fe00653a95b41c584b2af36544b0731443` (1049 bytes)
- `.git\objects\d3\5c9cbcb71efcdac4bc11dbae532bd4859cd851` (893 bytes)
- `.git\objects\d4\9cda8cbdc3e7e1ba697b1730402539951d5250` (249 bytes)
- `.git\objects\da\5cb7d185885f1675862ce6902736717b977b50` (139 bytes)
- `.git\objects\df\693fe2cb20c929a397d8a263f8e58a5c72d8dd` (88 bytes)
- `.git\objects\df\7eb24f7a33d777b4abce807c803bde7f87a18e` (1840 bytes)
- `.git\objects\e7\43c062823588d32dc7524369bf49559e87f37e` (52 bytes)
- `.git\objects\f0\8d4d5585cf16f43f3f872fe04e0e50c5cdbbe7` (119 bytes)
- `.git\objects\f0\926d9a49bd34e717e32ce2c08a03eb025dc1fb` (850 bytes)
- `.git\objects\f3\73602366077c10c68d6c1deb4c1168f2312b35` (1654 bytes)
- `.git\objects\f5\0fe6a532d3479ff1806d5933ceb4fa8d8e1a28` (248 bytes)
- `.git\refs\heads\master` (41 bytes)
- `.git\refs\remotes\origin\main` (41 bytes)
- `.gitignore` (134 bytes)
- `_raw_response_debug.txt` (25498 bytes)
- `docs\coverage_plan.md` (2490 bytes)
- `docs\design_spec.md` (5269 bytes)
- `docs\generation_report.md` (4594 bytes)
- `README.md` (2337 bytes)
- `rtl\fifo_ctrl.sv` (2461 bytes)
- `rtl\fifo_mem.sv` (1191 bytes)
- `rtl\fifo_top.sv` (2306 bytes)
- `sim\sim.vvp` (11320 bytes)
- `sva\_sva.sv` (4205 bytes)

## How to Run

```bash
# Compile
iverilog -g2012 -o sim/sim.vvp rtl/fifo.sv tb/fifo_tb.sv

# Simulate
vvp sim/sim.vvp
```
