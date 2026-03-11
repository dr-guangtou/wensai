---
date: 2026-03-05
tags:
  - development
  - dev/frankenz
---
# frankenz — main — 2026-03-05 (Session 3)

## Progress

### S23b Photo-z Training Rehearsal Pipeline — Complete

Built and validated a complete end-to-end photo-z training rehearsal pipeline for HSC S23b undeblended convolved photometry. This is the culmination of the S23b catalog preparation work from previous sessions.

#### Deliverables

- **`s23b/run_photoz_s23b.py`** (1,551 lines) — standalone CLI script implementing the full K-fold cross-validation photo-z pipeline:
  - **Data preparation**: loads the 453,652-object FITS catalog, extracts undeblended convolved photometry (5-band grizy in nJy), applies sequential quality cuts (97.7% survival: 443,292 objects pass), corrects for galactic extinction, estimates skynoise from data, splits by `sample_crossval` column into 8 folds, and saves train/test HDF5 per fold
  - **Pipeline execution**: runs frankenz KMCkNN `run_pipeline()` per fold with configurable `--chunk-size` (default 500), computes PDF summary statistics via `pdfs_summarize()`, saves per-fold `.npz` results
  - **Result aggregation**: concatenates per-fold test results back into original object order so every object has a photo-z from when it was in the test set
  - **Metrics computation**: 6 metric functions covering point estimates (bias, sNMAD, f_out, f_cat, RMS for 4 estimators), PDF quality (PIT, CRPS, KS test, 68%/95% coverage), binned metrics (vs z_spec and vs i-mag), and per-source metrics (DESI vs COSMOSWeb)
  - **Visualization**: 12 publication-quality QA figures (10 standard from `run_photoz.py` pattern + 2 S23b-specific: N(z) by source and scatter by source with per-source annotations)
  - **Report generation**: markdown report with config, data summary, quality cut attrition table, skynoise values, overall/per-source/binned metrics tables, known limitations, and lessons learned section
  - **CLI flags**: `--test-fold N` (single fold), `--skip-prep` (reuse HDF5), `--skip-run` (reuse results), `--force` (re-prepare), `--chunk-size N`

- **`s23b/frankenz_s23b_config.yaml`** — S23b-specific config with nJy luptitude zeropoints (`3.6308e12` nJy = AB ZP 31.4) and placeholder skynoise (overridden by data-driven estimation at runtime)

- **`.gitignore`** updated to exclude `s23b/output/`

#### Data-Driven Skynoise Estimation

A key innovation: instead of using hardcoded skynoise values from S20 cmodel photometry, the script estimates skynoise per band by computing the median flux_err for faint objects (i > 25 mag). This provides physically meaningful luptitude softening parameters in the correct flux units (nJy) for S23b undeblended aperture photometry.

Measured skynoise values (nJy): g=0.564, r=0.744, i=0.810, z=1.326, y=2.961

#### Fold 2 Validation Run

Executed a complete dry run on fold 2 (~55,400 test objects) to validate the full data flow:

- **Pipeline performance**: 57.2 seconds, ~970 obj/s with chunk_size=500
- **DESI subsample** (17,568 objects): sNMAD=0.038, f_out=12.1% — excellent performance on bright, low-z objects
- **COSMOSWeb subsample** (37,776 objects): sNMAD=0.243, f_out=52.0% — poor performance on faint, high-z objects
- **Overall**: sNMAD=0.122, f_out=39.3%, bias=-0.002
- **PDF calibration**: severely under-dispersed (coverage_68=0.22, coverage_95=0.37) with `kde_bandwidth_fraction=0.01`

#### Quality Cut Attrition

| Cut | Remaining | Survival |
|-----|-----------|----------|
| Initial | 453,652 | 100.0% |
| Finite flux (all bands) | 450,499 | 99.3% |
| Positive flux (all bands) | 443,769 | 97.8% |
| i-band SNR >= 3.0 | 443,734 | 97.8% |
| Redshift in [0, 7] | 443,734 | 97.8% |
| Object type filter | 443,292 | 97.7% |

Main attrition comes from non-finite flux (3,153 objects, likely GAaP g-band NaN issue noted in schema) and non-positive flux (6,730 objects).

### Git History

- Committed on `feature/s23b-photoz-rehearsal` branch (`75fc12c`)
- Merged to `main` with `--no-ff` (`300a55a`)
- Clean working tree after merge

### Memory Updated

- Updated project memory with fold 2 results, skynoise values, and pipeline status
- Documented 3 known data issues: DESI zerr sentinels, missing bright/low-z training data, under-dispersed PDFs needing wider KDE bandwidth
- Added global rule: always use `uv run python` for script execution

## Current State

### Output Directory Structure (fold 2 only)

```
s23b/output/undeblended/
  prepared/
    fold_{2-9}_train.hdf5     # All 8 folds prepared
    fold_{2-9}_test.hdf5
    metadata.yaml
    auxiliary.npz              # specz_sources, object_type, i_mag, sample_crossval
  results/
    fold_2_results.npz         # Only fold 2 completed
    combined_results.npz
    metrics.txt / metrics.json
  figures/
    fig_{01-12}_*.png          # All 12 figures generated
  report.md
```

### Key Issues

1. **PDF calibration is poor**: `kde_bandwidth_fraction=0.01` produces severely narrow PDFs. Coverage(68%)=0.22 vs nominal 0.68. Previous S20 bandwidth sweep showed frac=0.15-0.20 needed. Must re-sweep for S23b.

2. **COSMOSWeb performance is bad**: sNMAD=0.243, f_out=52%. This is likely because COSMOSWeb dominates the faint/high-z regime where KNN photo-z is inherently harder, and the training sample has limited bright/low-z coverage for calibration.

3. **Only fold 2 completed**: 7 remaining folds need to run (~7 min total estimated). Command: `uv run python s23b/run_photoz_s23b.py --skip-prep`

4. **Training sample incompleteness**: Missing SDSS/BOSS/GAMA spec-z for bright/low-z coverage. The 6x performance gap between DESI (bright) and COSMOSWeb (faint) confirms this is a real limitation.

### Next Steps

- Run all 8 folds for complete cross-validation metrics
- Re-sweep KDE bandwidth parameters for S23b (frac=0.05-0.20, floor=0.03-0.10) — expect similar pattern to S20 sweep
- Investigate COSMOSWeb performance by magnitude bin to identify the transition point
- Update `report.md` lessons learned section with actual findings after full run
- Organize complete training sample with SDSS/BOSS/GAMA for production use

## Lessons Learned

- **Data-driven skynoise works well**: estimating from faint-object flux_err median gives physically meaningful values without needing sky background measurements. The values are ~30-50x larger than S20 cmodel skynoise, consistent with the different photometry type (undeblended convolved aperture vs cmodel).

- **DESI vs COSMOSWeb performance split is dramatic**: 6x difference in sNMAD (0.038 vs 0.243). This is not just a faint-vs-bright effect — it reflects the fundamental challenge of photo-z at z>1 with limited training data diversity. The DESI subsample (lower redshift, brighter) is well-served by KNN; COSMOSWeb (higher redshift, fainter) needs broader training coverage.

- **KDE bandwidth calibration is essential for PDF quality**: point estimates are robust to bandwidth choice (as confirmed in S20 sweep), but PDF calibration (coverage, CRPS) is highly sensitive. The default frac=0.01 is far too narrow for realistic PDFs.

- **Script architecture**: the single-file, self-contained pattern (~1.5k lines) works well for research scripts. CLI flags for `--skip-prep` and `--skip-run` enable efficient iteration without recomputing expensive steps. K-fold aggregation via auxiliary `.npz` arrays avoids reloading the FITS catalog.

- **Always use `uv run python`**: bare `python` or `.venv/bin/python` may not have the correct environment. `uv run` ensures venv activation and dependency sync.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
