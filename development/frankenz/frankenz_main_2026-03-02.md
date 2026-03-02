---
date: 2026-03-02
tags:
  - development
  - development/frankenz
---

# frankenz — main — 2026-03-02

## Progress

- Built the first **production end-to-end photo-z script** (`example/run_photoz.py`, ~580 lines) that exercises the entire frankenz v0.4.0 API on real HSC S20 training sample data (10,000 train + 10,000 test objects, 5 grizy bands).
- Created **`example/frankenz_config.yaml`** — a v0.4.0 `FrankenzConfig`-compatible YAML translated from the old frankenz4DESI YACS format (`example.yaml`). Verified it loads cleanly via `FrankenzConfig.from_yaml()`.
- Script sections: HDF5 data loading with header stripping, `run_pipeline()` inference, `pdfs_summarize()` post-processing, 5 point-estimate metrics x 4 estimators, PIT/CRPS/KS/coverage PDF quality metrics, binned metrics (z and i-mag), 10 publication-quality QA figures, human-readable metrics report, NPZ results export, and argparse CLI.

### First Run: 48% NaN PDFs

- The first pipeline run completed in ~6 seconds but produced **4,792 out of 9,998 NaN PDFs** (48%), yielding catastrophic metrics (78% outlier fraction, sigma_NMAD=0.52 for the "best" estimator).
- Root cause: the `zerr` (spectroscopic redshift error) column in the HSC HDF5 files contains **sentinel values** (-9.0, 0.0, 99.0) that the KDE step uses as Gaussian kernel bandwidths. Zero bandwidth produces zero-width kernels; the KDE output sums to zero; then `pdf /= pdf.sum()` in `knn.py:882` divides by zero, producing NaN.
- The old frankenz4DESI code had a `ZSMOOTH: 0.01` config parameter (not used directly in the KDE call), but the practical effect was the same — the zerr values weren't properly cleaned.

### Fix: zerr Clamping

- Added `ZERR_FLOOR = 0.01` and `ZERR_CEIL = 1.0` constants. After loading, `np.clip(redshift_errs, 0.01, 1.0)` replaces 3,128 sentinel values per file.
- Second run: **zero NaN PDFs**, pipeline completes in 5.7s (1,758 obj/s).

### Final Metrics

| Estimator | Bias    | sigma_NMAD | f_outlier | f_catastrophic |
|-----------|---------|------------|-----------|----------------|
| mode      |  0.0003 | 0.069      | 0.215     | 0.080          |
| best      |  0.025  | 0.134      | 0.396     | 0.080          |
| median    |  0.024  | 0.139      | 0.408     | 0.108          |
| mean      |  0.031  | 0.159      | 0.440     | 0.155          |

- **Mode** is the best-performing point estimator (sigma_NMAD=0.069, 21.5% outliers).
- PDF coverage: 36.3% at nominal 68%, 56.9% at nominal 95% — PDFs are under-dispersed (too narrow), consistent with using a fixed 0.01 bandwidth floor instead of true spectroscopic uncertainties.
- PIT histogram shows classic U-shape (under-dispersion); QQ plot deviates from diagonal accordingly.
- N(z) comparison: stacked PDFs match the true z_spec distribution shape well, with slight excess at high-z from color-redshift degeneracies.
- Binned analysis: z~0.2-0.3 bins have highest outlier rates (59-62%) — classic low-z/high-z color degeneracy in 5-band photometry.

## Artifacts Produced

```
example/
├── frankenz_config.yaml         # v0.4.0 config (new)
├── run_photoz.py                # Production photo-z script (new, ~580 lines)
└── output/
    ├── metrics.txt              # Human-readable evaluation report
    ├── results.npz              # PDFs + point estimates + PIT + CRPS (57 MB)
    └── figures/
        ├── fig_01_scatter_4panel.png
        ├── fig_02_residual_histogram.png
        ├── fig_03_residual_vs_zspec.png
        ├── fig_04_residual_vs_mag.png
        ├── fig_05_pit_qq.png
        ├── fig_06_nz_comparison.png
        ├── fig_07_example_pdfs.png
        ├── fig_08_metrics_vs_zbin.png
        ├── fig_09_metrics_vs_magbin.png
        └── fig_10_credible_coverage.png
```

## Current State

### Key Issues

- **NumPy 2.0 `trapz` removal**: The library code (`simulate.py`, `plotting.py`, `knn.py`) uses `np.trapz` which was removed in NumPy 2.0. This causes 5 test errors and 8 test failures in the existing suite. The script itself uses `np.trapezoid` correctly. This is a pre-existing library issue, not introduced by this session.
- **PDF under-dispersion**: The zerr clamping to 0.01 produces over-confident PDFs. A proper fix would either use the original training-set zerr values (where valid) with only sentinel replacement, or implement adaptive bandwidth selection. This is a tuning issue, not a code bug.
- **40% outlier rate**: Reasonable for 5-band photo-z at HSC depth with color-redshift degeneracies, but could be improved with a data-driven prior (planned for future phases).

### Next Steps

- Commit the new script and config to a feature branch
- Phase 03 (HSC Pipeline): integrate with actual HSC survey pipeline
- Consider fixing the `np.trapz` → `np.trapezoid` migration across the library
- Investigate data-driven KNN prior to reduce outlier fraction

## Lessons Learned

- **Sentinel values in astronomical catalogs are insidious.** The `zerr` column contained -9, 0, and 99 as placeholders — these silently propagated through the KDE step and produced NaN PDFs with no obvious error message. The only clue was a `RuntimeWarning: invalid value encountered in divide` from deep inside `knn.py`. Always inspect metadata columns for sentinel values before feeding them to statistical algorithms.
- **KDE bandwidth = zerr.** In frankenz's `gauss_kde`, the `y_std` parameter (model label errors = spectroscopic redshift errors) directly controls the Gaussian kernel width. Zero bandwidth → zero-width kernel → zero PDF → NaN after normalization. This is architecturally correct (narrower kernels for more precisely known redshifts) but requires clean input data.
- **The mode estimator dominates for photo-z.** With sigma_NMAD=0.069 vs 0.134 for "best" — the mode's L0-loss optimality makes it far more robust to the multi-modal PDFs that arise from color-redshift degeneracies. The "best" (Lorentzian loss) estimator is more robust than mean/median but still influenced by secondary peaks.
- **`np.trapz` → `np.trapezoid` in NumPy 2.0.** This removal with no deprecation period caught me on the first try. Need to migrate the entire library eventually.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
