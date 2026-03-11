---
date: 2026-03-05
tags:
  - development
  - dev/frankenz
---
# frankenz — S23b QA Infrastructure — 2026-03-05

This entry documents the S23b training sample QA stage of frankenz development: building the plotting library, schema documentation, and publication-quality QA notebook for the HSC S23b deep matched training catalog.

## Progress

### 1. Reference Code Analysis
- Read the existing `s19a_plot.py` (7 functions, 455 lines) and its companion notebook `s19a_study_training.ipynb` to establish the target figure style
- Identified the core pattern: `plt.hist2d()` with `LogNorm()` over a scatter underlay, fine bins (120×100), `cmin=2`, per-source side-by-side panels (WIDE vs DUD), scale factor `a = 1/(1+z)` primary axis with secondary redshift axis, `log10(δz/(1+z))` for redshift error representation

### 2. Catalog Schema Documentation (`s23b/docs/catalog_schema.md`)
- Extracted and categorized all 343 columns from `hsc_s23b_deep_matched_train_SFR_v3.fits` (453,652 objects)
- Column breakdown: 10 astrometry, 10 extinction, 160 flux (8 types × 5 bands × flux+fluxerr), 20 error-only flux, 90 shape measurements, 30 quality flags, 10 magnitude offsets, 7 spectroscopic redshift, 6 metadata
- Documented 7 known data issues that affect downstream processing:
  1. All 165 `_isnull` columns uniformly True (unusable)
  2. All 15 flag columns uniformly True (unusable)
  3. DESI_DR1 redshift errors always −1.0 (sentinel, 143k objects)
  4. COSMOSWeb zerr: 23% invalid (≥1.0 or =0)
  5. `logmstar`/`sfr` stored as JSON-string arrays
  6. GAaP optimal g-band only 84.6% positive (66k NaN)
  7. `objectIndex` always 2.0 (artifact)
- Included complete `FLUX_TYPE_REGISTRY` mapping for all 8 photometry types

### 3. Plotting Module (`s23b/s23b_plot.py`, 333 lines)
- 8 reusable functions modeled on `s19a_plot.py`:
  - `plot_scale_dz` — scale factor vs log10(δz/(1+z)) with `secondary_xaxis` for redshift
  - `plot_mag_dz` — magnitude vs log10(δz/(1+z))
  - `plot_mag_z` — magnitude vs redshift
  - `plot_color_z` — color vs redshift (pre-computed color input)
  - `plot_color_color` — color-color diagrams
  - `plot_z_hist_by_source` — redshift histograms split by spec-z source
  - `plot_z_compare` — z₁ vs z₂ comparison (for dual-source validation)
  - `plot_completeness_heatmap` — annotated heatmap
- Shared core `_hist2d_with_scatter()`: scatter background → hist2d + LogNorm → optional highlight overlay → optional colorbar
- `SOURCE_STYLE` dictionary for consistent DESI (viridis/steelblue) vs COSMOSWeb (inferno/orangered) styling
- User tweaked label position in `plot_scale_dz` after initial implementation (0.70 → 0.10 for better visibility)

### 4. QA Notebook Rewrite (`s23b/qa_training_sample.ipynb`, ~40 cells)
- Complete rewrite from prior 38-cell version. Organized into 11 sections:
  - §0 Configuration: expanded registry to all 8 flux types, selected 3 for detail (cmodel, gaap_optimal, convolved)
  - §1 Imports: now uses `s23b_plot` module
  - §2 Data Loading: extracts source masks (DESI, COSMOSWeb, Dual) for reuse
  - §3 Redshift QA (6 figures): z distribution (linear+log), scale factor vs log10(δz/(1+z)), spec-z source overlap, object types, cross-validation folds, spatial RA/Dec
  - §4 Completeness (1 figure): all 8 flux types heatmap
  - §5 Per-Flux-Type QA (15 figures): mag-z + color-z 3×2 panels per source, zerr relations 2×2 panels, SNR distributions, magnitude distributions with source-split, redshift in mag bins
  - §6 Cross-Flux Comparison (3 figures): i-mag + color scatter, flux ratio per band, magnitude-dependent residual
  - §7 Quality Cuts: sequential cuts with attrition waterfall (3 figures), pre/post-cut z distribution, post-cut mag-z confirmation
  - §8–9 Extinction Correction + Export: unchanged from prior version
  - §10 Summary
- **Key improvements over prior version**: `hexbin` → `hist2d` + `LogNorm` everywhere, colorbars, scale factor axes, per-source side-by-side panels, log-scale z distribution, flux ratio analysis, magnitude-dependent residuals

### 5. Planning & Documentation
- Created `s23b/docs/qa_notebook_plan.md` (248 lines) — detailed implementation plan with figure inventory, function specs, section structure
- Created `docs/journal/2026-03-05_handover.md` with next-session instructions for training data cleaning script

### 6. Git Operations
- Committed on `feature/s23b-qa-improvements`: `617831e` (11 files, 2,417 lines added)
- Merged to `main` with `--no-ff`: `3ffcbbd`
- Binary outputs (`s23b/output/`) intentionally not committed

## Current State

### File Inventory (New in This Stage)
| File | Lines | Purpose |
|------|-------|---------|
| `s23b/docs/catalog_schema.md` | 200 | Full 343-column schema reference |
| `s23b/docs/qa_notebook_plan.md` | 248 | Implementation plan |
| `s23b/s23b_plot.py` | 333 | Reusable plotting module (8 functions) |
| `s23b/qa_training_sample.ipynb` | 1,229 | QA notebook (~40 cells, ~30 figures) |
| `docs/journal/2026-03-05_handover.md` | 85 | Session handover |

### Key Issues
- Notebook not yet executed — figures exist only as code, not rendered output
- `main` is 2 commits ahead of `origin/main` (not pushed)
- `s23b/output/` contains stale HDF5 and PNG files from prior session's older notebook version — will be overwritten on next run
- One minor post-merge edit: label position in `plot_scale_dz` changed from `0.70` to `0.10` (uncommitted, 1-line diff)

### Next Steps
- User will run the notebook and adjust figures manually
- Next development stage: **training data cleaning script** for S23b catalog
  - Starting points: `catalog_schema.md` for column reference, notebook's `apply_quality_cuts()` for baseline logic
  - Key challenges: DESI zerr sentinel handling, COSMOSWeb zerr filtering, GAaP g-band NaN treatment, JSON-string field parsing, star removal

## Lessons Learned
- **scatter + hist2d > hexbin for publication**: hist2d gives precise bin edge control, proper colorbars via the returned image object, and the scatter underlay reveals low-density outliers that fall below `cmin`. hexbin lacks bin edge control and makes colorbars harder.
- **secondary_xaxis for dual scales**: matplotlib's `ax.secondary_xaxis('top', functions=(forward, inverse))` cleanly maps scale factor ↔ redshift without manual tick management.
- **Schema-first approach pays off**: documenting all 343 columns before coding the notebook prevented multiple bugs — particularly the discovery that all flag/isnull columns are True and that GAaP g-band has 15% NaN.
- **Parallel Agent tool calls still unreliable**: confirmed across 3+ sessions in this project. Always use sequential calls.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
