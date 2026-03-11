---
date: 2026-03-06
tags:
  - development
  - dev/frankenz
---
# frankenz — main — 2026-03-06

## Progress

### S/N Cap (Error Floor) for Bright Objects
- Added per-band S/N upper limit: `SNR_CAP = [100, 100, 100, 80, 50]` for grizy
- New `apply_snr_cap()` function inflates `flux_err` where `flux/flux_err > cap`
- Applied after extinction correction, before skynoise estimation
- 367k/443k objects (83%) had at least one band capped — confirms widespread HSC error underestimation
- **Fold 2 results improved significantly:**

| Metric | Before cap | After cap |
|--------|-----------|-----------|
| Coverage(68%) | 0.216 | 0.427 |
| Coverage(95%) | 0.368 | 0.661 |
| sigma_NMAD | 0.122 | 0.094 |
| DESI sNMAD | 0.038 | 0.026 |
| DESI f_out | 0.121 | 0.095 |

### QA Metrics Overhaul (s19a-style)
- Ported `biweighted_bias()` from s19a_helper.py (Beers et al. 1990 iterative estimator)
- Added `qa_stats()` computing all 7 standard HSC photo-z metrics:
  - Conventional + biweighted bias
  - Conventional (1.48*MAD) + biweighted scatter
  - Conventional + biweighted outlier fraction
  - Average Lorentzian loss function
- Added `qa_mag_bins()` and `qa_z_bins()` with fixed-width bins (s19a convention: mag step=0.5, z step=0.2), replacing percentile-based bins that produced misleading equal-count histograms
- WIDE depth i-band magnitude cut at 25.5 mag applied to QA figures

### New QA Figure Design
- Replaced old `fig_08_metrics_vs_zbin` and `fig_09_metrics_vs_magbin` (simple 3-panel line plots) with a single combined `plot_qa_metrics()` figure
- 2x2 layout: metrics scatter (top) + delta_z violin (bottom), vs i-mag (left) + vs z_spec (right)
- s19a marker style: solid=biweighted, empty=conventional; circles=bias, squares=sigma, triangles=outlier, crosses=loss
- Per-source figures generated: `fig_08_qa_metrics_all.png`, `_desi.png`, `_cosmosweb.png`
- Wider aspect ratio (18x10) to emphasize horizontal trends
- Violin panels show per-bin delta_z distributions clipped to [-1, 1]

## Current State

- 2 files modified, +407/-28 lines (uncommitted on main)
- Fold 2 validated with S/N cap; remaining folds (3-9) data prepared but not yet run
- PDF calibration still below nominal (coverage_68=0.43 vs 0.68) — KDE bandwidth sweep needed
- Old fig_08/fig_09 functions still defined but no longer called

### Key Issues
- Coverage gap (0.43 vs 0.68 nominal) likely needs combined S/N cap + wider KDE bandwidth
- DESI DR1 spec-z errors remain sentinels (zerr=-1.0); z-proportional KDE bandwidth is the workaround
- COSMOSWeb dominates the sample (68%) and drives overall metrics down (sNMAD=0.21 vs DESI 0.026)

### Next Steps
- KDE bandwidth sweep with S/N cap active to close remaining coverage gap
- Run all folds (3-9) with current settings once bandwidth is tuned
- Consider removing dead `fig_08_metrics_vs_zbin` / `fig_09_metrics_vs_magbin` functions
- Add bright/low-z spectroscopic sources (SDSS, BOSS, GAMA) to training sample

## Lessons Learned
- HSC photometric errors are severely underestimated for bright objects — S/N cap of 50-100 per band is essential, consistent with s19a's `s2n=100` parameter and the `np.hypot(flux_err, flux / s2n)` pattern
- Percentile-based bins for QA figures are misleading: equal counts hide the physically meaningful variation in sample density. Fixed-width bins (s19a convention) are better for diagnostics.
- The s19a `qa_stats` + `plot_qa_mag_z` pattern is a well-tested HSC standard — worth following exactly rather than reinventing
- z_spec (not z_phot) should be the binning variable for redshift-binned QA, since we want to assess performance at known redshifts

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
