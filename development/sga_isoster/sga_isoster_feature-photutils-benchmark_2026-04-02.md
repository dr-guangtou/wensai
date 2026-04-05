---
date: 2026-04-02
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — feature/photutils-benchmark — 2026-04-02

## Progress

### Plan Review and Critical Bug Fixes
- Reviewed `docs/plan/step4a_photutils_isophote_benchmark.md` written by a prior agent; found and fixed three critical issues:
  - **sma0 too large**: `MAJORAXIS/2` (~25–40 px) as starting SMA caused 46% failure rate (44/96 galaxies returned 0 isophotes). Root cause: the intensity gradient is too weak at that radius for the fitter to bootstrap. Fixed with adaptive retry ladder `[5, 3, 10, MA/2, MA/4, 30, 1]` — small values work for compact galaxies, MAJORAXIS-based values needed for large extended galaxies (e.g., ESO149-013 with MAJORAXIS=147 only fits at sma0≥30).
  - **PA convention mismatch**: Plan passed SGA PA (astronomical, CCW from +y) directly to photutils (which expects math convention, CCW from +x). Verified on ESO149-013: SGA PA=101.9° vs photutils fitted PA=11.9°, difference = exactly 90°. Fixed with `pa_rad = np.deg2rad(pa_astro - 90) % pi`.
  - **`find_center()` unreliable**: Can converge to mask edges on masked images. Removed; SGA center (from Tractor fitting) is reliable. Added `fixed_center` config to test effect of locking center.
- Updated plan document with Critical Design Decisions section, 6 configs (added `fixed_center`), revised implementation order.

### Phase 1: Fitting Pipeline (`scripts/fit_photutils.py`)
- Implemented `scripts/photutils_fitter.py` (helper: config loading, per-galaxy fitting, inventory/report) and `scripts/fit_photutils.py` (orchestrator: CLI, tqdm loop, skip/overwrite).
- Key implementation details:
  - `isolist.to_table()` for base columns + manual extraction of harmonics (a3/b3/a4/b4), rms, tflux, etc. (to_table only returns 18 of ~35 columns).
  - Sanitized object-dtype columns (`grad_error`, `grad_rerror` have None at sma=0).
  - Galaxy-specific sma0 ladder includes MAJORAXIS-based values alongside fixed values.
- Validated on 5 galaxies (2 previously-OK + 3 previously-failed): 5/5 success.
- Full run: **96/96 success** (100%), up from 54% in prior attempt. 19 galaxies needed sma0 retry. Median 61 isophotes, 6.4s fit time, 17min total.

### Phase 2: Analysis Pipeline (`scripts/analyze_photutils.py`)
- Computes per-galaxy metrics: fit extent ratio, stop-code fractions, nflag stats, center drift, PA/eps range, median b4, residual zone stats (inner/annulus/outer: rms, median, mad, frac_above_3sigma).
- 10 quality flags at 3 severity levels (critical/warning/info).
- Updates Phase 1 inventory.fits with metric + flag columns.

### Six Benchmark Configurations
- Ran all 6 configs on 96 demo galaxies:
  - `baseline_median`: 96/96 — closest to SGA defaults (median + 3σ clip)
  - `low_fflag`: 96/96 — most tolerant of masked pixels (fflag=0.3)
  - `linear_step`: 96/96 — 1-pixel stepping (slower, many more isophotes)
  - `default_bilinear`: 95/96 — no sigma clipping
  - `fixed_center`: 95/96 — center locked to SGA position
  - `aggressive_clip`: 84/96 — 2σ/5-iteration clipping too strict for 12 galaxies

### QA Figures (isoster/Huang2013 Campaign Style)
- Rewrote `scripts/photutils_plots.py` to match the `isoster` plotting convention:
  - Left column: Data (viridis + orangered isophote overlays + red mask), Model (same arcsinh stretch), Residual (coolwarm symmetric colorbar).
  - Right column: μ (mag/arcsec²), δCen (pix), b/a, PA (deg), A/B harmonics — all on SMA^0.25 x-axis.
  - Stop-code-separated scatter (monochrome, non-zero codes = open markers).
  - SGA reference profiles overlaid (red open squares) on SB, b/a, PA panels.
- Created `scripts/generate_qa.py` standalone batch script with `--galaxy`, `--overwrite`, `--skip-summary`.
- Iterative refinements:
  - Fixed SGA INTENS unit: confirmed nanomaggies/arcsec² (validated: SB at RADIUS_SB24 = 24.04 mag/arcsec²). photutils gives nanomaggies/pixel → divide by pixel_scale² = 0.0686.
  - Switched y-axis from log10(I) to μ (mag/arcsec²) with inverted axis.
  - SGA R_SMA confirmed in pixels (not arcsec).
  - 3-sigma clipping for harmonics, center offset, PA y-axis ranges (outliers no longer dominate).
  - Error bars excluded from y-axis range computation in all panels.
  - Y-axis accommodates SGA reference profiles with 15% margins.
  - Galaxy info box (z, r-mag, morphology, D25) in SB panel bottom-left.
  - Removed redundant legends from ellipticity and PA panels.
- Generated 562 QA plots + 18 summary figures across all 6 configs.

## Current State

### Commits (this session)
- `125a1fc` — Phase 1 + Phase 2 scripts, baseline_median 96/96
- `34bba75` — All 6 configs complete
- `3a286dc` — QA figures: isoster/Huang2013 style
- `12d9571` — QA: mag/arcsec², sigma-clip, galaxy info

### Key Files
- `scripts/fit_photutils.py` + `scripts/photutils_fitter.py` — Phase 1 fitting
- `scripts/analyze_photutils.py` — Phase 2 metrics + flags
- `scripts/photutils_plots.py` — QA figure generation (isoster style)
- `scripts/generate_qa.py` — Batch QA generation CLI
- `config/photutils_benchmark.yaml` — 6 configs + adaptive sma0 ladder
- `docs/plan/step4a_photutils_isophote_benchmark.md` — Reviewed + fixed plan

### Output Layout
```
output/photutils/{config_name}/
  config.yaml, inventory.fits, report.md
  profiles/{GALAXY}_photutils.fits
  models/{GALAXY}_model.fits
  qa/{GALAXY}_qa.png
  summary/summary_{profiles,residuals,metrics}.png
```

### Key Issues
- Quality flag thresholds are very sensitive: 96/96 flagged for PA instability (>45°), 94/96 for eps instability (>0.3). These thresholds need tuning based on visual QA review.
- `aggressive_clip` (2σ) too strict for 12 galaxies — expected behavior, not a bug.
- `pyproject.toml` and `uv.lock` have uncommitted changes (photutils dependency added).

### Next Steps
- Tune quality flag thresholds based on visual QA review across configs.
- Cross-config comparison analysis (Step 4f): how do different configs affect SB profiles, residuals, convergence?
- Steps 4d/4e: AutoProf and isoster benchmarks (follow same two-phase pattern).
- Production sample (1,998 galaxies) scaling.

## Lessons Learned
- **photutils sma0 is galaxy-size-dependent**: Small galaxies need small sma0 (bright core gradient), large galaxies need large sma0 (flat core at small radii). A single fixed value fails for ~half the sample. The adaptive retry ladder with MAJORAXIS-based values is essential.
- **SGA INTENS is in nanomaggies/arcsec²**, not per-pixel. Verified by cross-checking against RADIUS_SB24 (24.04 mag/arcsec² at that radius). photutils gives raw per-pixel intensity from the image.
- **SGA R_SMA is in pixels** (confirmed: matches MAJORAXIS which is documented as pixels; RADIUS_SB24 in arcsec / pixel_scale = R_SMA at that index).
- **`isolist.to_table()` is incomplete**: Only 18 of ~35 isophote attributes. Harmonics (a3/b3/a4/b4), rms, tflux, npix, sarea need manual extraction from individual Isophote objects.
- **Some `to_table()` columns have None values** (grad_error at sma=0) that produce object-dtype columns. Must sanitize before writing to FITS.
- **QA figure y-axis ranges**: Error bars should never influence axis range — only data values. Sigma clipping (3σ) essential for harmonics where one outlier can compress the entire panel. Comparison profiles (SGA) must be included in range computation with comfortable margins.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
