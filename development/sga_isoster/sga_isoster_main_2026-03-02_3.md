---
date: 2026-03-02
tags:
  - development
  - dev/sga_isoster
---
# sga_isoster — Step 3: FITS Validation & Object Mask Building — 2026-03-02

## Overview

Implemented the full Step 3 pipeline: data validation (Stage A) and object mask building (Stage B) for the 96-galaxy demo sample. This is the critical data-quality gate between raw downloads (Step 2) and isoster surface brightness fitting (Step 4). The work was done on `feature/step3-validation` and merged to `main`.

## Stage A: FITS Validation

### What was built

Three scripts following the project's one-script-per-stage convention:

- **`validate_fits_io.py`** (~250 lines) — per-file check functions for all 12 FITS products (image×3, invvar×3, psf×3, maskbits, ellipse, tractor), plus `validate_galaxy()` and `validate_all_galaxies()` orchestration functions
- **`validate_fits_report.py`** (~200 lines) — writes `validation_inventory.fits` (one row per galaxy with structural metrics), a Markdown summary report, and 3 QA diagnostic plots
- **`validate_fits.py`** (~90 lines) — CLI entrypoint with `--input`, `--data-dir`, `--output-dir` arguments

### Validation checks performed

| Product | Checks |
|---------|--------|
| image-{g,r,z}.fits.fz | 2+ HDUs, 2-D float32, shape > 64 px |
| invvar-{g,r,z}.fits.fz | shape matches image, no NaN, zero-pixel fraction |
| psf-{g,r,z}.fits.fz | square 2-D array, min size 10 px |
| maskbits.fits.fz | MASKBITS HDU present, shape matches image, bad-bit fraction computed |
| {SGA_ID}-ellipse.fits | BinTable with 1 row, X0/Y0/EPS/PA/MAJORAXIS all finite |
| tractor.fits | BinTable with ra/dec/type/shape_r/bx/by columns present |

Cross-checks: image/invvar/maskbits shapes must all match within each galaxy.

### Results

- **96/96 galaxies validated**: 88 ok, 8 warnings, 0 errors
- All 8 warnings are high maskbit bad-pixel fraction (>30%), corresponding to galaxies at survey boundaries where much of the image footprint falls outside the DR9 coverage
- PSF sizes vary across the sample: 55×55 (g,r bands for ~28% of galaxies), 63×63 (z band), and 65×65. Initial implementation hardcoded (65,65) which caused 27 false errors — relaxed to accept any square PSF ≥10 px
- Maskbit bad-pixel fraction: median 0.2%, but a long tail up to 100% for boundary galaxies
- Invvar zero fraction: median 0.0%, max 6.8% — no issues

### Outputs

- `output/validation_inventory.fits` — 12-column table (GROUP_NAME, SGA_ID, IMAGE_NY/NX, N_FILES_PRESENT/MISSING, SHAPES_OK, MASKBIT_BAD_FRAC, INVVAR_ZERO_FRAC, ELLIPSE_OK, TRACTOR_N_SOURCES, STATUS)
- `output/validation_report.md` — human-readable summary with per-product coverage table
- `output/qa/validate/image_dimensions.png` — NX vs NY scatter (all images are square, range 231–811 px)
- `output/qa/validate/maskbit_coverage.png` — histogram showing most galaxies have <5% bad pixels
- `output/qa/validate/invvar_zero_frac.png` — histogram confirming negligible dead pixels

## Stage B: Object Mask Building

### What was built

- **`mask_builder.py`** (~300 lines) — core mask logic: read ellipse geometry, read maskbits, build DR9 bad-pixel mask, identify target galaxy in Tractor catalog, build contaminant source masks (elliptical for extended, circular for PSF), compute zone statistics, write mask FITS file
- **`mask_plots.py`** (~150 lines) — per-galaxy 3-panel QA (r-band image / mask / red overlay) + summary scatter plot
- **`build_masks.py`** (~110 lines) — CLI entrypoint with `--input`, `--data-dir`, `--output-dir`, `--skip-plots`

### Masking strategy

**DR9 maskbits**: `bad_pixel = (maskbits & ~(1 << 12)) != 0` — masks all flagged pixels except bit 12 (GALAXY), which marks the target galaxy interior. This preserves the target galaxy footprint while flagging bright stars (bit 1), saturated pixels (bits 2–4), all-masked regions (bits 5–7), WISE contamination (bits 8–9), and other artifacts.

**Tractor source masking**:
1. Read Tractor catalog (bx, by pixel coordinates, type, shape_r, shape_e1, shape_e2)
2. Identify target galaxy: nearest Tractor source to ellipse center (X0, Y0) within 3×MAJORAXIS pixels — excluded from masking
3. For each contaminant source:
   - PSF type → circular mask, radius = 5 px
   - REX/EXP/DEV/SER → elliptical mask using e1/e2 parameterization at 2.5× half-light radius

**Combined mask** = maskbit_bad OR contaminant_masks → written as uint8 (0=good, 1=bad)

### Zone statistics

Mask fraction computed in three elliptical zones (using target galaxy's X0, Y0, EPS, PA, MAJORAXIS):
- **Inner**: r_ell < 0.5 × MAJORAXIS
- **Annulus**: 0.5–2.0 × MAJORAXIS
- **Full image**: all pixels

### Results

- **96/96 masks built** with 0 errors
- Contaminants per galaxy: median 42, max 673 (ESO085-005, a crowded field)
- Mask fraction by zone (medians): inner 6.0%, annulus 7.1%, full 7.0%
- 52/96 galaxies have inner mask >5% — includes 7 survey-edge cases with ~100% masking
- QA panels confirm masks correctly cover foreground stars and neighbor galaxies while preserving target galaxy light

### Outputs

- `output/masks/{GROUP_NAME}/{GROUP_NAME}-mask.fits` — 96 boolean mask files
- `output/mask_inventory.fits` — 9-column table with zone mask fractions
- `output/mask_report.md` — summary with flagged high-masking galaxies
- `output/qa/masks/*.png` — 96 per-galaxy 3-panel QA plots + summary scatter

## Current State

### Key Issues

- **Masking strategy needs improvement** — the current approach has known limitations:
  - Median inner-zone mask fraction of 6% is higher than ideal; some of this is maskbit contamination within the galaxy footprint itself
  - The fixed 2.5× scale factor for extended source masks and 5 px for PSF sources is simplistic — should be tuned based on source brightness
  - No distinction between bright foreground stars (need large masks) and faint background sources (smaller masks sufficient)
  - Survey-edge galaxies (8/96) have near-100% masking — these may need special handling or exclusion
  - The mask does not account for diffraction spikes from bright stars
  - Target galaxy identification relies solely on proximity to ellipse center — could fail for complex groups
  - The Tractor e1/e2 → ellipse conversion may not perfectly match the true contamination footprint

### Next Steps

- Revisit and refine the masking strategy before proceeding to isoster (Step 4)
- Consider brightness-dependent mask radii (e.g., scale with flux)
- Evaluate whether survey-edge galaxies should be flagged for exclusion
- Step 4: Connect to `../isoster` for 1-D surface brightness profile extraction
- Production sample (1,998 galaxies) still needs downloading (~2.4 GB)

## Lessons Learned

- **PSF sizes are not fixed**: SGA-2020 PSF files vary between 55×55 and 65×65. The SGA documentation implies 65×65 but this is not universal. Always validate against actual data rather than assumed constants.
- **DR9 bit 12 (GALAXY)**: Critical to exclude this bit from the bad-pixel mask — it marks the target galaxy interior. Without this exception, the target itself gets masked.
- **Survey boundaries**: ~8% of demo galaxies have extreme maskbit coverage (>80%) due to falling at survey edges. This is a data selection issue, not a pipeline bug.
- **Tractor byte strings**: Like all FITS string columns, the `type` column reads back as byte strings. Must decode before comparison.
- **Validation-first development**: Running validation before mask building caught the PSF size issue early and established confidence in the data before building derived products.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
