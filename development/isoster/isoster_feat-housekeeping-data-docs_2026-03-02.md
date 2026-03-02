---
date: 2026-03-02
tags:
  - development
  - development/isoster
---

# isoster — feat/housekeeping-data-docs — 2026-03-02

## Progress

### Phase A–E Housekeeping (commit `12f2a53`)
- Moved shared FITS data from `examples/data/` → `data/` at project root; updated all path references across tests, benchmarks, examples, and docs
- Rewrote `tests/README.md` with an 18-row overview table, per-category narratives, run commands, coverage gaps, and maintenance notes
- Created `benchmarks/FRAMEWORK.md` with naming conventions, required artifact rules, CLI requirements, and AutoProf adapter notes
- Created `examples/REVIEW.md` as a snapshot inventory of 18 scripts across 4 clusters (Huang2013 workflow, LegacySurvey harmonics, loose NGC3610 explorations, loose utilities)
- Renamed `outputs/benchmarks_performance/` → `benchmark_performance/`, `benchmarks_profiling/` → `benchmark_profiling/`; deleted empty dirs (`benchmark_results/`, `tests_real_data/`), temp dirs (`tmp/`, `tmp_eso185_g054_validation/`), and 3 loose root files
- Created `outputs/INVENTORY.md` (force-added despite global `.gitignore` via `!outputs/INVENTORY.md` exception)
- 225 tests pass after the move

### Exhaustive Sweep Generalization (commit `f351bfd`)
- `git rm` 4 obsolete benchmark scripts: `convergence_diagnostic.py`, `huang2013_convergence_benchmark.py`, `ngc1209_convergence_benchmark.py`, `bench_isofit_overhead.py`
- `git mv benchmarks/ic3370_exhausted/ benchmarks/exhausted/` — removed all IC3370-specific hardwiring
- `config_registry.py`: replaced `BASELINE_OVERRIDES` (had IC3370 geometry + fitting params) with `PARAMETER_BASELINE` (fitting params only); geometry now injected at runtime
- `run_benchmark.py`: added `--image`, `--band-index`, `--galaxy-label`, geometry CLI args (`--x0/y0/eps/pa-deg/sma0/maxsma`), `auto_detect_geometry()` from image shape, 3D FITS cube support, `--quick` mode
- Created `benchmarks/exhausted/README.md` with CLI reference, geometry auto-detection table, output structure

### outputs/ Manual Cleanup + INVENTORY update (commit `e785354`)
- User manually deleted all `examples_*`, `isofit_mode_comparison/`, `legacysurvey_*`, `huang2013_*`, `ngc*` folders — down from 33 to 5 active folders
- Updated `outputs/INVENTORY.md` to reflect actual disk state

### IsosterConfig Migration + AUTOPROF docs (commit `affd157`)
- Migrated all raw `dict` configs → `IsosterConfig(...)` in:
  - `bench_vs_photutils.py` (`run_isoster_fit`)
  - `bench_vs_autoprof.py` (3 locations: prelim geometry estimation, JIT warmup, main benchmark)
  - `profile_isophote.py` (`run_profile`)
- Verified all fields (`maxgerr`, `use_eccentric_anomaly`, `fix_center/eps/pa`, `compute_errors`, `compute_deviations`, `full_photometry`, `nclip`, `sclip`, `linear_growth`) exist in `IsosterConfig`
- `FRAMEWORK.md §6`: expanded from 4 lines to full section with env setup, sanity-check command, conda recipe, and machine-specificity warning for `AUTOPROF_PYTHON`

### baselines/ Cleanup (commit `e78fb99`)
- Deleted 3 stale/superseded JSON files: `efficiency_baseline.json` (raw results, Jan 15), `efficiency_thresholds_2026-02-14.json`, `phase4_profile_thresholds_2026-02-11.json`
- Renamed 4 JSON files removing date/phase labels:
  - `efficiency_thresholds_full_refresh_phase10_qa.json` → `efficiency_thresholds.json`
  - `efficiency_thresholds_quick_2026-02-14.json` → `efficiency_thresholds_quick.json`
  - `phase4_profile_thresholds_full_refresh_phase10_qa.json` → `phase4_profile_thresholds.json`
  - `benchmark_gate_defaults.json` → `run_benchmark_gate_defaults.json`
- Moved 2 utility scripts from `baselines/` → `utils/`: `mockgal_adapter.py`, `scaffold_models_config_batch_templates.py`
- Updated hardcoded `DEFAULT_*_PATH` constants in `run_benchmark_gate.py`, `lock_efficiency_thresholds.py`, `lock_phase4_thresholds.py`
- `benchmarks/README.md`: added new threshold config reference table, updated census table and all reproducible commands

## Current State

- **Branch**: `feat/housekeeping-data-docs` — 5 commits ahead of last merge point, not yet merged into main
- **225 tests pass**
- **benchmarks/**: fully audited — all 7 active scripts are API-compatible with v2026.03.02; all use `IsosterConfig`; no broken imports
- **outputs/**: 5 active folders only (`benchmark_ic3370_exhausted/`, `benchmark_performance/`, `benchmark_profiling/`, `tests_integration/`, `tests_validation/`)
- **benchmarks/baselines/**: 4 threshold JSONs (named cleanly), 4 Python scripts; 2 utility scripts moved to `utils/`

### Key Issues
- `run_benchmark_gate.py` imports from `examples.huang2013.run_huang2013_real_mock_demo` — this is a tight coupling between the CI gate and an example workflow that could break if examples are refactored
- `build_isoster_model()` in `bench_vs_autoprof.py` and `run_benchmark_gate.py` is marked deprecated for v0.3; will need updating before that release
- `mockgal_adapter.py` still contains machine-specific hardcoded paths (`DEFAULT_MOCKGAL_PATH`, `DEFAULT_LIBPROFIT_BUILD_PATH`) pointing to local directories — these should become environment variables

### Next Steps
- Merge `feat/housekeeping-data-docs` into main (pending approval)
- AutoProf FFT deep-dive: contrast AutoProf's FFT-based isophote fitting with isoster at single-isophote level (source: `reference/autoprof/src/autoprof/pipeline_steps/Isophote_Fit.py` + `Isophote_Extract.py`)

## Lessons Learned

- **`outputs/` gitignore exception**: `git add -f` is needed for any file under a globally-ignored directory; add `!outputs/INVENTORY.md` to `.gitignore` to make it permanent
- **Geometry separation pattern**: Cleanest approach for galaxy-agnostic sweeps is `PARAMETER_BASELINE` (fitting params only in registry) + geometry injected at runtime via `build_geometry(args, image)` → `baseline = {**PARAMETER_BASELINE, **geometry}`. This keeps the registry reusable across galaxies without any IC3370-specific residue
- **Raw results ≠ config**: JSON files in `baselines/` should only be threshold configs (committed, stable). Raw benchmark outputs (timing measurements, baseline metrics) belong in `outputs/` and should not be committed to the repo. `efficiency_baseline.json` had crept in as a committed results file
- **Phase labels in filenames**: Internal dev phase labels (`phase4`, `phase10_qa`) in config filenames become confusing as the project matures. Use functional names (`efficiency_thresholds.json`) and rely on git log for history

---
*Agent: Claude Code (claude-sonnet-4-6) · Session: [paste session ID here]*
