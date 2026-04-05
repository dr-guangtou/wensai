---
date: 2026-03-11
tags:
  - development
  - development/isoster
---

# isoster — fix/eso243-49-regression — 2026-03-11

## Background

ESO243-49 (edge-on S0 galaxy, eps=0.714) produced 0 isophotes on `main` (`a90d42d`) — a regression introduced by the Phase 27 stabilization merge. The first isophote failed immediately with `stop_code=-1` (gradient error two-strike exit). This session diagnosed the root cause, fixed it, and built a multi-method baseline benchmark framework.

## Progress

### Part 1: ESO243-49 Regression Fix

- Diagnosed the root cause as a **lazy gradient cache + two-strike interaction**:
  - At `sma0=10`, iteration 0: gradient computed with relative error 0.71, exceeding `maxgerr=0.5`. First strike recorded (`lexceed=True`).
  - Iteration 1: lazy gradient **reused the cached value** (same 0.71 error). Second strike fired immediately on stale data — the geometry never got a chance to improve.
  - Pre-lazy-gradient code recomputed the gradient every iteration, giving geometry multiple real chances.
- Applied a one-line fix to `isoster/fitting.py:987` — added `or lexceed` (and `or cached_gradient_error is None`) to the lazy gradient reuse condition. When a gradient strike is active, the next iteration recomputes the gradient with updated geometry.
- Verified: ESO243-49 now produces **50 isophotes** (all `stop_code=0`). IC3370_mock2 unchanged at 59 isophotes. No new test failures.
- The initial plan diagnosed the issue as `gradient_error = None`, which was incorrect — the actual error was a high relative gradient error exceeding `maxgerr`. Lesson: always inspect actual runtime values before coding a fix.

### Part 2: Multi-Method Baseline Benchmark

- Created `benchmarks/benchmark_baseline/` with two files:
  - **`baseline_shared.py`** (~950 lines) — galaxy registry, data loading, moment-based geometry estimation, background estimation, per-method fitting wrappers, model reconstruction, profile I/O, and multi-method comparison QA figure generation.
  - **`run_baseline.py`** (~480 lines) — CLI orchestrator with `--help`, `--quick`, `--galaxy`, `--output`, `--no-photutils`, `--no-autoprof` flags.

- **Three methods supported**: isoster, photutils, AutoProf.
  - Availability checks at startup with clear warnings when a method is missing.
  - Each method's core fitting is timed separately (geometry setup, config creation, and background estimation excluded from timing).

- **Timed core fitting**:
  - isoster: `fit_image()` only
  - photutils: `ellipse.fit_image()` only (`EllipseGeometry`/`Ellipse` construction excluded)
  - AutoProf: subprocess `Process_Image()` with pre-set center/background/PA (bypasses auto-detection)

- **2D model reconstruction** uses each method's native builder:
  - isoster: `build_isoster_model()`
  - photutils: `build_ellipse_model()` via duck-typed isolist adapter
  - AutoProf: native `EllipseModel` pipeline step (`_genmodel.fits`)

- **QA figures** (`qa_comparison.png`) follow `docs/qa-figures.md`:
  - Left column: original image with multi-colored isophote overlays + per-method fractional residual images `(model-data)/data %` with coolwarm colormap
  - Right column: 5 vertically-stacked 1D panels sharing `SMA^0.25` x-axis — surface brightness, relative SB difference (vs isoster), ellipticity, PA (normalized), centroid offset
  - Scatter markers per method with distinct colors/shapes (isoster blue filled circles, photutils red hollow squares, AutoProf green filled triangles)

- **Artifact persistence** for reproducibility without re-fitting:
  - Per-method: `profile.fits`, `profile.ecsv`, `model.fits`
  - Per-galaxy: `fit_configs.json` (all method configs as reusable JSON input), `results.json`, `REPORT.md`
  - Aggregate: `results.json`, `REPORT.md` with per-method summary tables

- **Fixes during development**:
  - 3D FITS cube handling: AutoProf receives a temporary 2D extraction (it cannot read cube slices)
  - photutils defaults: changed from `integrmode='median'` + `nclip=3` (caused false failures on edge-on galaxies) to `integrmode='bilinear'` + `nclip=0`

### Benchmark Results (all 3 galaxies)

| Galaxy | isoster | photutils | AutoProf |
|--------|---------|-----------|----------|
| eso243-49 | 50 iso, 0.14s | 50 iso, 0.79s | 56 iso, 7.11s |
| IC3370_mock2 | 59 iso, 0.08s | 59 iso, 4.05s | 62 iso, 3.43s |
| ngc3610 | 50 iso, 0.06s | 0 iso (failed) | 53 iso, 10.83s |

- ngc3610 photutils failure: the moment-estimated geometry (eps=0.054, nearly round) combined with default `maxgerr=0.5` is too strict. With `maxgerr=2.0` it produces 50 isophotes. This is a genuine photutils sensitivity issue, not a framework bug.

### Part 3: Merge

- Committed on `fix/eso243-49-regression` branch (`6f0c503`).
- Merged into `main` with `--no-ff` (`2c6a62d`).

## Current State

### Key Issues
- ngc3610 fails with photutils under default settings (geometry sensitivity). Not blocking — the benchmark correctly captures this as a "0 isophotes" result.
- AutoProf centroid offset is not available (AutoProf `.prof` format lacks per-isophote `x0`/`y0`).
- Parked: `feat/gradient-free-fallback` branch has uncommitted Phase 28b+28c work. Brent fallback still needs fixes (bad geometry at LSB, 24x worse residuals).

### Next Steps
- Consider adding `maxgerr` as a configurable parameter in `fit_configs.json` for photutils to handle ngc3610-like cases.
- Consider adding more galaxies to the registry (e.g., M51 spiral).
- Resume gradient-free fallback work when ready.

## Lessons Learned
- **Lazy caching + multi-strike logic**: any caching mechanism that feeds into a strike/penalty counter must invalidate on strike activation. Otherwise the counter accumulates from stale data without giving the system a chance to recover.
- **Always debug with actual values**: the plan diagnosed `gradient_error = None` but the real issue was `gradient_relative_error > maxgerr`. Inspecting runtime values before coding the fix would have saved time.
- **photutils sensitivity to integrmode**: `integrmode='median'` causes photutils to fail on edge-on galaxies even with `nclip=0`. The default `'bilinear'` is more robust for general use.
- **3D FITS cubes**: AutoProf cannot handle cube slices — always extract a 2D image to a temporary file before passing to subprocess adapters.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
