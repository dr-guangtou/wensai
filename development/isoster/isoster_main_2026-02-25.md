---
date: 2026-02-25
tags:
  - development
  - development/isoster
---

# isoster — main — 2026-02-25

## Progress

### Core Feature: Simultaneous Geometry Updates + ISOFIT Mode Config

- Implemented `geometry_update_mode` config parameter: `'largest'` (default, coordinate descent — one parameter per iteration) or `'simultaneous'` (updates all 4 geometry params each iteration). Simultaneous mode respects `fix_center`, `fix_pa`, `fix_eps` flags and is recommended with `geometry_damping=0.5`.
- Implemented `isofit_mode` config parameter: `'in_loop'` (default, aggressive simultaneous harmonic fitting inside iteration loop) or `'original'` (Ciambur 2015 post-hoc — 5-param geometry fit inside loop, then all higher-order harmonics fitted simultaneously after convergence using best-iteration data).
- Added config validation V4: warns when `geometry_update_mode='simultaneous'` with `geometry_damping > 0.7` (may oscillate).
- Added 6 new unit tests covering both modes: config validation, convergence on circular/elliptical mocks, profile equivalence, iteration count comparison, fixed-geometry respect.

### QA Plotting: Direct Residual Default

- Changed `plot_qa_summary()` to default to direct residual (`data - model`) instead of fractional residual (`(model - data) / data [%]`), matching the existing behavior of `plot_qa_summary_extended()`. Added `relative_residual` parameter for backward compatibility — pass `True` to get the old fractional display.

### IC3370 Exhaustive Configuration Benchmark

- Designed and implemented a self-contained benchmark in `benchmarks/ic3370_exhausted/` that exhaustively tests every meaningful isoster config parameter on IC3370_mock2 (Huang2013 sample — a challenging galaxy with complex geometry).
- **39 configurations total**: P00 (photutils baseline) + S00-S23 (24 single-parameter sweeps) + C01-C12 (12 combination configs).
- Sweep parameters include: `convergence_scaling`, `geometry_damping`, `geometry_update_mode`, `geometry_convergence`, `permissive_geometry`, `use_eccentric_anomaly`, `simultaneous_harmonics`, `isofit_mode`, `harmonic_orders`, `use_central_regularization`, `integrator`, `conver`, `maxit`, `sclip`, `full_photometry`, `fix_center`, `fix_pa`, `fix_eps`.
- Per-zone accuracy metrics (inner < 1 Re, mid 1–4 Re, outer > 4 Re) computed against photutils baseline: median/max |dI/I|, |d_eps|, |d_PA|.
- 2D model residual statistics (fractional median, RMS) with 1% peak threshold to avoid background contamination.
- Numba JIT warmup dry run before timing to eliminate first-call compilation overhead (S00 dropped from 1.71s to 0.10s).
- Two summary comparison figures: `summary_vs_P00.png` and `summary_vs_S00.png`.
- P00 photutils QA figure with model reconstruction included in gallery.
- Config registry in both markdown (`config_registry.md`) and Python (`config_registry.py`) formats.
- CLI supports `--configs S00,S08` subsets, `--skip-photutils`, `--skip-qa-figures`, `--skip-model`.

### Example Data and Scripts

- Copied IC3370_mock2.fits (4.9MB), ESO243-49 (773K), NGC3610 (773K) to `examples/data/`.
- Example scripts: `compare_isofit_modes.py`, `ngc3610_highorder_exploration.py`, `ngc3610_mask_effect.py`, `ngc3610_sma0_effect.py`.

## Key Benchmark Results

Effective radius: 25.0 px. Photutils baseline: 59 isophotes, 33 stop=0, 21 stop=2, 4.46s.

| Config | stop=0 | stop=2 | Time(s) | Notes |
|--------|--------|--------|---------|-------|
| S00 (defaults) | 64/68 | 0 | 0.10 | sector_area + damping=0.7 |
| S04 (no damping) | 43/68 | 20 | 0.26 | Damping is the key stabilizer |
| C01 (pure legacy) | 39/68 | 25 | 0.35 | Reproduces original baseline failures |
| S07 (permissive) | 66/68 | 0 | 0.11 | Best convergence count |
| S23 (fixed geom) | 66/68 | 0 | 0.10 | Fixed geometry from photutils |
| C02 (permissive+geom_conv) | 66/68 | 0 | 0.11 | Also 66/68 |
| S11 (ext harmonics) | 64/68 | 0 | 0.12 | Slightly better model residual |
| C04 (EA+ext harmonics) | 64/68 | 0 | 0.12 | Best model_frac_med (0.0125) |

Key takeaway: the default configuration (sector_area scaling + damping=0.7) achieves 64/68 stop=0 vs photutils's 33/59 — a dramatic improvement from the old baseline's 30/59. Damping alone accounts for most of the improvement (S04 without damping drops to 43/68).

## Git Commits

```
a23e5ce data: add IC3370, ESO243-49, and NGC3610 example FITS images
15f7033 bench: add IC3370 exhaustive configuration benchmark (39 configs)
5316a21 feat: add simultaneous geometry updates, isofit_mode config, and direct residual QA
```

Branch `feat/simultaneous-geometry-updates` merged to `main` (fast-forward) and deleted. 203 tests pass.

## Current State

### Key Issues

- P00 model stats show `nan` because we don't compute model residuals for the photutils reference against itself — this is by design but could be confusing in the report.
- The `__pycache__` files are tracked in git and show up as dirty after every run. Low priority cleanup item.

### Next Steps

- Analyze the full benchmark results in detail — especially the per-zone accuracy tables for inner/mid/outer regions.
- Consider running on additional Huang2013 galaxies to validate that the default config is robust across different morphologies.
- Real-data validation of `geometry_update_mode='simultaneous'` on galaxies with strong geometry gradients.
- Investigate the 4 stop=-1 (gradient error) isophotes that appear in most isoster configs — are these inner-region issues?

## Lessons Learned

- **Numba JIT warmup is critical for benchmarking**: The first `fit_image()` call pays ~0.5-1.5s of JIT compilation overhead. Without a warmup dry run, S00 appeared to be the slowest config (1.71s) when it's actually the fastest (~0.10s). Always warm up JIT before timing.
- **Astropy table columns can have units**: Photutils tables store PA in degrees with an astropy `Unit("deg")` annotation. `float(row["pa"])` raises `TypeError` — need `.value` or `np.radians()` explicitly. Created a `_col_values()` helper to handle this uniformly.
- **Model residual thresholding matters**: Computing `(model - image) / image` over the full image gives meaningless results (median ~1.0) because background pixels dominate. Restricting to pixels where model > 1% of peak gives sensible fractional residuals (~1.3%).
- **`compile_qa_gallery()` must skip its own directory**: When iterating over output subdirectories to copy QA PNGs, the `qa_gallery/` subdirectory itself must be excluded to avoid `SameFileError`.
- **Config validation catches real bugs**: The `minit > maxit` check in `IsosterConfig` caught a warmup config that set `maxit=5` with the default `minit=10`.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
