---
date: 2026-03-05
tags:
  - development
  - dev/frankenz
---
# frankenz — feature/s23b-qa-improvements -> main — 2026-03-05

## Progress

### Reference Code Analysis
- Read `../hsc_photoz/notebook/s19a_plot.py` (455 lines, 7 plotting functions) and its usage notebook `s19a_study_training.ipynb` to understand the target publication-quality plot style
- Key patterns identified: `hist2d` + `LogNorm` + scatter underlay, scale factor `a = 1/(1+z)` as primary x-axis with secondary redshift axis, `log10(dz/(1+z))` for redshift error representation, fine bins (120x100), per-source side-by-side panels (WIDE vs DUD)

### Catalog Schema Documentation
- Created `s23b/docs/catalog_schema.md`: complete documentation of all 343 columns in `hsc_s23b_deep_matched_train_SFR_v3.fits`
- Categorized into 9 groups: astrometry (10), extinction (10), flux (160 across 8 types x 5 bands), error-only flux (20), shape measurements (90), quality flags (30), magnitude offsets (10), spectroscopic redshift (7), metadata (6)
- Documented 7 known data issues: all `_isnull` columns uniformly True, all flag columns True, DESI zerr = -1.0 sentinel, COSMOSWeb 23% invalid zerr, JSON-string logmstar/sfr, GAaP g-band 15% NaN, objectIndex always 2.0
- Included frankenz column mapping (`FLUX_TYPE_REGISTRY` for all 8 photometry types)

### Plotting Module
- Created `s23b/s23b_plot.py` (333 lines, 8 reusable functions) following `s19a_plot.py` patterns:
  - `plot_scale_dz`: scale factor vs log10(dz/(1+z)) with `secondary_xaxis` for redshift
  - `plot_mag_dz`: magnitude vs log10(dz/(1+z))
  - `plot_mag_z`: magnitude vs redshift
  - `plot_color_z`: color vs redshift (takes pre-computed color array)
  - `plot_color_color`: color-color diagrams
  - `plot_z_hist_by_source`: redshift histograms split by spec-z source
  - `plot_z_compare`: z1 vs z2 comparison (for dual-source validation)
  - `plot_completeness_heatmap`: annotated heatmap of per-band completeness
- Shared `_hist2d_with_scatter` core: scatter background + hist2d + LogNorm + optional colorbar + optional highlight overlay
- `SOURCE_STYLE` dict for consistent DESI/COSMOSWeb/Dual color schemes

### QA Notebook Rewrite
- Rewrote `s23b/qa_training_sample.ipynb` from 38 cells to ~40 cells with ~30 publication-quality figures
- **New figures** (not in previous version):
  - Scale factor vs log10(dz/(1+z)) — COSMOSWeb only (DESI has sentinel zerr)
  - Spatial RA/Dec distribution (by source + density)
  - Spec-z source overlap analysis (dual-object z distribution + zerr precision)
  - Per-flux-type 2x2 zerr relations panels (scale-dz, mag-dz, color-dz, color-color)
  - Per-flux-type 3x2 mag/color-z panels (DESI vs COSMOSWeb side-by-side)
  - Flux ratio analysis per band (log10 ratio histograms)
  - Magnitude-dependent residual (2D histogram of dmag vs mag)
  - Post-cut mag-z confirmation
- **Improved figures**:
  - `hexbin` -> `hist2d` + `LogNorm` + scatter underlay everywhere
  - Source-split overlays on magnitude and redshift-in-magbin histograms
  - Completeness heatmap expanded from 2 to all 8 flux types
  - Log-scale redshift distribution for tail visibility
- **Registry expanded**: from 5 types to all 8 (`cmodel`, `cmodel_exp`, `cmodel_dev`, `psf`, `gaap_optimal`, `gaap_psf`, `convolved`, `undeblended`)
- **Selected types**: `cmodel`, `gaap_optimal`, `convolved` (3 types for detailed analysis, up from 2)
- Export pipeline unchanged: quality cuts, extinction correction, HDF5 output, round-trip validation

### Branch Management
- All work done on `feature/s23b-qa-improvements` branch
- Committed as `617831e` (11 files, 2,417 lines)
- Merged to `main` with `--no-ff` as `3ffcbbd`

## Current State

### Key Issues
- Notebook has not been executed yet — user will run and adjust figures manually
- Binary outputs (`s23b/output/`) not committed (HDF5, PNGs from previous session's older notebook version)
- Previous session's old figures are in `s23b/output/figures/old/` — may need cleanup after re-running
- Not pushed to remote yet

### Next Steps
- User runs notebook, adjusts figure parameters as needed (bin sizes, axis limits, colormaps)
- Consider adding `s23b/output/` to `.gitignore`
- Potentially read reference notebook `../hsc_photoz/notebook/s19a_study_training.ipynb` for the "weird region" outlier investigation (cells 5-8) and replicate for S23b
- Future: run frankenz pipeline on the exported HDF5 files

## Lessons Learned
- Parallel Agent tool calls consistently hang in this project — always use sequential calls (confirmed across multiple sessions)
- The S23b catalog has 165 `_isnull` columns and 15 flag columns that are all uniformly True — completely unusable for quality filtering. Quality must be assessed from data values directly.
- DESI_DR1 redshift errors are universally -1.0 (sentinel) — any zerr-based analysis must exclude DESI or handle this explicitly
- GAaP optimal photometry has significant g-band incompleteness (84.6% vs 99%+ for other types) — must be handled in color computations
- The `s19a_plot.py` pattern of scatter + hist2d + LogNorm is superior to hexbin for publication figures: better control over bin edges, proper colorbars, and the scatter underlay shows outliers that fall below `cmin`

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
