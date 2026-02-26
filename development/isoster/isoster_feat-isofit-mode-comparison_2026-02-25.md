---
date: 2026-02-25
tags:
  - development
  - development/isoster
---

# isoster — feat/isofit-mode-comparison — 2026-02-25

## Progress

- Added `isofit_mode` config parameter to `IsosterConfig` with two variants: `'in_loop'` (current isoster behavior) and `'original'` (Ciambur 2015 post-hoc simultaneous harmonics)
- Implemented the "original" ISOFIT mode in `fit_isophote()`: uses 5-param inside the iteration loop for geometry, then fits all higher-order harmonics simultaneously post-hoc after convergence — matching the original IRAF ISOFIT algorithm
- Saved best-iteration data (`best_angles`, `best_intens`, `best_gradient`) at geometry snapshots so post-hoc fitting uses the correct data, not last-iteration data
- Updated all three post-hoc exit points (harmonic convergence, geometry convergence, max-iter fallback) consistently
- Added 3 new unit tests (182 total, all passing):
  - Confirmed "original" mode geometry/RMS/niter/stop_code are bitwise identical to the default 5-param path
  - Verified post-hoc harmonics are nonzero (a4 detected on boxy mock)
  - Confirmed in-loop and original modes produce valid but different results
- Wrote `examples/compare_isofit_modes.py` comparison script running ESO243-49 and NGC3610 with three configs (baseline, ISOFIT in-loop, ISOFIT original)
- Generated QA figures with 2D residual maps and 6-panel 1D profiles (SB, delta I, a4, b4, b/a, PA)

## Key Findings

- The original ISOFIT (Ciambur 2015) and the default ellipse algorithm have **identical iteration loops** — the only difference is post-hoc harmonic treatment (simultaneous in ψ-space vs sequential in φ-space)
- All three modes produce nearly identical 2D residual patterns on real LegacySurvey galaxies
- ESO243-49: in-loop mode loses 2/60 convergences (58/60 vs 60/60) because the lower ISOFIT RMS makes the convergence criterion relatively harder to satisfy
- NGC3610: in-loop gives marginally better mid-region residuals (6.72% vs 6.87% baseline, 6.79% original)
- The structured residual patterns are **not caused by the ISOFIT algorithm variant** — they persist across all modes and likely come from real morphological features, masking artifacts, or model reconstruction interpolation

## Current State

### Key Issues
- ESO243-49 fractional residual statistics are unreliable (100% median) due to near-zero pixels in outskirts; metric needs better signal-floor filtering for edge-on galaxies
- The comparison confirms isoster's in-loop ISOFIT is more aggressive than Ciambur 2015 but the practical difference on these two galaxies is small

### Next Steps
- Decide whether to commit and merge `feat/isofit-mode-comparison` or iterate further
- Consider testing with higher harmonic orders ([3,4,5,6,7]) to see if more orders reduce structured residuals
- Consider comparing against photutils.isophote as external ground truth
- Investigate whether the structured residuals come from model reconstruction (interpolation) rather than extraction

## Lessons Learned
- Reading the original IRAF source (`reference/isofit/isophote/src/elfit.x`) was essential — it revealed that Ciambur 2015's ISOFIT has a commented-out block that would have placed EA-based harmonics inside the loop, proving this was considered but explicitly left out
- The `bufy` in-place subtraction pattern in `el_harmonics.x` / `el_harmonics2.x` explains why sequential post-hoc fitting ignores cross-correlations — each subsequent fit operates on residuals with previous orders already removed
- Unit testing that "original" mode produces bitwise identical geometry to the default path was a strong implementation correctness check

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
