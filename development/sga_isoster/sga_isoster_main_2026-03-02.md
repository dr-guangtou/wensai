---
date: 2026-03-02
tags:
  - development
  - dev/sga_isoster
---
# sga_isoster — main — 2026-03-02

## Progress

- Completed the entire Step 1 of the SGA-Isoster pipeline: catalog exploration, sample selection, stratified sub-sampling, and demo grz mosaics
- Merged `feature/catalog-selection` into `main` (18 files, 2,516 insertions)

### Step 1a: Catalog selection
- Built a modular selection pipeline (`select_sample.py` + 5 helper modules) that applies 5 sequential quality cuts to the SGA-2020 catalog
- Cut from 383,620 → 285,224 galaxies (74.3% survival): clean ellipse fits, isolated galaxies, face-on (b/a >= 0.3), z < 0.2, and percentile outlier rejection on MAG_R, D25_LEDA, COLOR_GR, COLOR_RZ
- Generated diagnostic plots and a markdown selection report

### Step 1b: Stratified sub-sampling
- Drew demo (96) and production (1,998) sub-samples using MAG_R histogram-weighted sampling across 6 morphology groups (E, S0, Sa-Sb, Sbc-Sd, Sdm-Irr, Unknown)
- Equal allocation per group (16 demo, 333 production) ensures all morphologies are well represented
- Validated with KS tests: per-group distributions match parent well; overall shift expected due to equal morph allocation vs Unknown-dominated parent

### Step 1c: Demo grz mosaics
- Created `scripts/demo_mosaic.sh` — a bash script that downloads SGA-2020 grz color thumbnails from the NERSC portal and builds 4×4 labeled montages per morphology group
- Debugged URL construction: discovered RA directories must be **3-digit zero-padded** (`044` not `44`), which caused 27/96 404 errors initially
- Confirmed the correct image filename is `-largegalaxy-image-grz.jpg` (real data), not `-largegalaxy-model-grz.jpg` (Tractor model visualization)
- Final result: 96/96 images downloaded, 6 montages produced

### Documentation
- Wrote `docs/plan/step1_catalog_selection.md` covering all three sub-steps, file inventory, and lessons
- Updated `CLAUDE.md` with corrected SGA data URL patterns
- Updated `docs/todo.md` and `docs/LESSONS.md` throughout

## Current State

### Key Issues
- None — Step 1 is complete and merged to `main`

### Next Steps
- **Step 2**: Image download pipeline — batch download FITS images (g, r, z bands + invvar, PSF, maskbits) from the NERSC portal for the production sample
- **Step 3**: Data validation and QA — verify downloaded images, check FITS headers, flag issues

## Lessons Learned
- SGA-2020 NERSC portal uses 3-digit zero-padded RA directories (`044` not `44`); `int(RA)` truncation only works for RA >= 100 by coincidence
- `-image-grz.jpg` is the real image; `-model-grz.jpg` is the Tractor model — both exist on the portal but serve different purposes
- SGA grz thumbnails vary in size (255–465 px) depending on galaxy angular extent; must resize to uniform tiles before building montages
- FITS string columns become byte strings on read-back; need `np.char.decode()` to compare with Python strings
- macOS bash 3.2 lacks `mapfile`; ImageMagick 7 on macOS (Homebrew) has no built-in `Helvetica` font — use full system font paths
- Equal morphology allocation shifts overall property distributions from the parent (dominated by Unknown=55%); per-group KS is the correct validation metric

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
