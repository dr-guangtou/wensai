---
date: 2026-03-09
tags:
  - development
  - development/frankenz
---

# frankenz — main — 2026-03-09

## Progress
- Completed **Phase E** of the S23b parameter sweep: full 8-fold cross-validation (443,292 objects) with the optimal configuration identified from Phases A-D
- Optimal config: `snr_cap=[50,50,50,50,50]` (aggressive), `bw_frac=0.10`, `bw_floor=0.05`
- Regenerated all 11 QA figures, metrics reports (txt/json/markdown), and combined results from the Phase E output
- Updated `frankenz_s23b_config.yaml` with optimal KDE bandwidth (was 0.01/0.01, now 0.10/0.05)
- Committed and merged `feature/s23b-parameter-sweep` into `main` (3 commits, 7 files, +1,909 lines)

## Current State

### Final Sweep Results (Phase E, 8-fold CV)

| Metric | Baseline | Optimized | Change |
|--------|----------|-----------|--------|
| sNMAD (z_best) | 0.095 | 0.081 | -15% |
| f_out | 0.36 | 0.325 | -10% |
| coverage_68 | 0.24 | 0.709 | +195% |
| coverage_95 | 0.40 | 0.888 | +122% |

Per-source: DESI sNMAD=0.027 (excellent), COSMOSWeb sNMAD=0.250 (training-sample-limited).

### Key Issues
- **COSMOSWeb performance** remains poor (sNMAD=0.250, f_out=0.44) due to sparse training coverage at faint magnitudes and high redshift; parameter tuning alone cannot fix this
- **DESI DR1 spec-z errors** are all sentinels (zerr=-1.0); real errors needed for proper KDE bandwidth per object
- **Training sample gaps**: missing SDSS/BOSS/GAMA spectroscopy for bright/low-z regime
- **z_mean is unreliable** with broad KDE bandwidth (sNMAD=0.130 vs z_best=0.081); must use z_best or z_median for point estimates

### Next Steps
- Run production photo-z with optimal config on full S23b catalog (not just training sample CV)
- Investigate adding external spectroscopic catalogs (SDSS, BOSS, GAMA) to improve bright-end coverage
- Fetch complete DESI DR1 catalog with actual redshift errors
- Clean up large intermediate files (~3.5 GB in `sweep/final/intermediates/`)

## Lessons Learned
- **Bandwidth is orthogonal to point estimates**: z_mode and z_best are identical across all bandwidth configs; only PDF width changes. This means the S/N cap optimization (Phase A/C) and bandwidth optimization (Phase D) are truly independent axes.
- **Aggressive S/N cap helps surprisingly much**: capping all bands at S/N=50 (vs the s19a-style 100/100/100/80/50) improved sNMAD by 15%. More error dilation gives better neighbor matching for bright objects where photometric errors are otherwise unrealistically small.
- **Save-intermediate pattern is essential**: storing neighbor indices + log-posteriors from the KNN step allows cheap re-sweeps of KDE bandwidth without re-running the expensive tree queries. Turned a 10-hour bandwidth sweep into 15 minutes.
- **Vectorize early**: the original `compute_crps()` and `compute_pit()` used Python loops over 55k objects each; vectorized versions with broadcasting are 100x faster and prevented OOM kills.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
