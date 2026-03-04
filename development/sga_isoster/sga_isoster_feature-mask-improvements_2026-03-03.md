---
date: 2026-03-03
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — feature/mask-improvements — 2026-03-03

## Progress

- Built `scripts/diagnose_maskbits.py` — per-bit pixel statistics across all 96 demo galaxies for DR9 bits 0-15, broken down by inner/annulus/full zones
- Diagnosed maskbit contributions: WISE bits (8-9) were ~5-7% of mask area, MEDIUM (bit 11) ~6%, while NPRIMARY/BAILOUT/CLUSTER were all zero in our sample
- Updated `build_maskbit_mask()` to only mask mandatory bits (NPRIMARY, SATUR_G/R/Z, CLUSTER); BRIGHT/MEDIUM available via `--mask-bright-stars` flag
- Fixed PA convention bug in `compute_zone_stats()` — SGA ellipse PA is astronomical (CCW from +y), but `_elliptical_radius()` expects math convention (CCW from +x); added `astro_pa_to_math()` helper
- Built `scripts/diagnose_pa.py` — generates 6-panel diagnostic plots testing 4 PA recipes (direct, +90, -90, negated) on selected high-ellipticity galaxies
- Diagnosed Tractor source PA: tested on ESO149-013 (EPS=0.57, PA=101.9) and 2MASXJ09464442+1101122 (EPS=0.59, PA=22.6); user confirmed recipe C (`atan2 - 90`) is correct
- Fixed `_source_elliptical_mask()` — Tractor `0.5*atan2(e2,e1)` also gives astronomical PA, needs the same -90 conversion
- Added central avoidance zone (8px radius) to `build_tractor_masks()` — skips sources overlapping galaxy center (over-deblended sub-structure); 45 sources excluded across 44/96 galaxies
- Added `n_central_excluded` field to `MaskResult`, inventory, and report
- Added `--avoidance-radius` CLI arg to `build_masks.py`

## Current State

### Key Metrics (96 demo galaxies)

| Metric | Before (Step 3b) | After (Step 3c) |
|--------|-----------------|-----------------|
| Inner zone median | 6.5% | 0.0% |
| Inner zone max | ~100% | 13.2% |
| Galaxies with inner > 5% | 52/96 | 8/96 |
| Central sources excluded | 0 | 45 across 44 galaxies |

### Key Issues
- 8 galaxies still have inner mask > 5% — likely legitimate (dense fields, bright nearby stars)
- Avoidance radius (8px) and maskbit selection could be further tuned
- Production sample (1,998 galaxies) not yet downloaded or processed

### Next Steps
- Step 4: isoster integration — connect to `../isoster` for 1-D surface brightness profile extraction
- May revisit masking after seeing isoster results on these 96 galaxies

## Lessons Learned
- **PA convention is critical and non-obvious**: both SGA ellipse PA and Tractor e1/e2 PA are in astronomical convention (CCW from +y/North). The rotation math in `_elliptical_radius()` uses math convention (CCW from +x). Must always subtract 90 degrees. This was initially missed for Tractor sources because the `atan2` output was assumed to be math convention.
- **Diagnose before fixing**: the PA issue was initially "fixed" with a circular-mask workaround. The correct approach was building a diagnostic tool (`diagnose_pa.py`) that tests multiple hypotheses visually, letting the user confirm which is correct. Never take shortcuts on geometry conventions.
- **Maskbit selection matters enormously**: the old approach of masking everything except GALAXY (bit 12) was far too aggressive. WISE IR bits and MEDIUM star halos together contributed ~12% mask area. Most mandatory bits (NPRIMARY, CLUSTER, BAILOUT) were zero in our sample — the real offenders were SATUR and optionally BRIGHT/MEDIUM.
- **Central avoidance is effective**: Tractor over-deblends galaxy sub-structure (HII regions, spiral arms, nucleus knots) into separate cataloged sources. A simple avoidance circle around the ellipse center catches these without losing genuine contaminants.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
