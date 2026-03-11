---
date: 2026-03-05
tags:
  - development
  - dev/isoster
---
# isoster — main — 2026-03-05

## Progress

- Implemented Phase 28c batch testing infrastructure on `feat/gradient-free-fallback`:
  - Created `batch_shared.py` — shared constants, Huang2013 data loading, FITS-header geometry inference, background estimation, fitting wrappers, serialization helpers
  - Created `build_qa_figures.py` — per-case QA figure builder (scatter+errorbars via `plot_profile_by_stop_code`) and cross-redshift comparison figure in physical kpc units
  - Created `run_batch_huang2013.py` — batch CLI script with `--reload`, `--skip-autoprof`, `--skip-figures` modes; processes 10 galaxies x 2 redshift variants
  - Updated `run_gradient_free_comparison.py` — replaced `plt.plot()` lines with QA-compliant scatter+errorbars for isoster methods
  - Updated `README.md` with batch usage docs and known behaviors
- Ran smoke tests: NGC1700 and NGC5328 at clean_z005 and wide_z050 pass, cross-z figures generate correctly, reload mode works, all 6 unit tests pass
- **Discovered two critical issues** during the batch run (see below), paused the feature branch, returned to `main`
- Wrote detailed issue report at `docs/gradient-free-fallback-issue-report.md`

## Current State

### Branch Status

Returned to `main` (clean). All Phase 28c work remains uncommitted on `feat/gradient-free-fallback`.

### Critical Issues Discovered

#### Issue 1: ESO243-49 Regression on Main (Priority: HIGH)

ESO243-49 (256x256 real galaxy, 3D cube) produces **0 isophotes on the `main` branch** with moment-based geometry estimation (eps=0.714, pa=-27.0 deg, sma0=10.0). The very first isophote fails with stop_code=-1 (gradient error, two-strike).

This is a **regression that has already been merged into main** — it predates the gradient-free fallback feature branch. Likely introduced by Phase 27 stabilization changes (centroid drift safeguards, SNR damping, step clipping — commits `a90d42d`, `65412aa`).

The gradient-free fallback ON mode rescues ESO243-49 (50 isophotes, all stop_code=0), which masks the underlying problem. But the core fitting should not fail on a real galaxy at the first isophote.

**Next step:** `git bisect` between a known-good state and `main` to identify which commit broke ESO243-49. Check if the issue is specific to high-ellipticity galaxies (eps > 0.7) or broader.

#### Issue 2: Brent Fallback Produces Bad Geometry (Priority: MEDIUM)

Quantitative comparison on NGC1700 (clean_z005):

| Metric              | Main / Fallback OFF    | Fallback ON           |
|---------------------|------------------------|-----------------------|
| Isophotes           | 65                     | 65                    |
| Stop codes          | {0: 61, -1: 4}        | {0: 65}               |
| Runtime             | 0.094 s                | 0.342 s (3.6x slower) |
| Residual std        | 0.042903               | 0.053698              |
| Max res (99th pct)  | 0.008151               | **0.197767** (24x)    |

**Root cause:** The Brent optimizer "recovers" 4 outer isophotes (sma > 397 px) that the gradient path correctly marks as stop_code=-1, but with physically wrong geometry:
- Ellipticity drops from 0.30 to 0.18 (40% decrease)
- Center drifts 4+ pixels
- PA shifts 5 degrees

The gradient-based path correctly freezes geometry from the last good isophote. Brent finds an RMS minimum that is numerically lower but physically meaningless (overfitting noise).

**Specific code problems:**
1. SNR threshold 1.5 triggers fallback too broadly (fires even when gradient works fine)
2. `lexceed = False` reset (line 1158 in fitting.py) prevents two-strike early exit
3. Gradient is still computed before fallback decision (wasted work)
4. Brent search bounds are too wide — allows geometry to wander far from current state

**Fallback OFF is byte-identical to main** — no regression in core gradient-based fitting.

### Next Steps

1. **Investigate ESO243-49 regression on main** — this is the immediate priority
   - `git bisect` to find the breaking commit
   - Test with lower `sma0`, different `maxgerr`, reduced eps
   - Check if Phase 27's SNR damping or step clipping is too aggressive for high-eps galaxies
2. **Fix Brent fallback** (after main is fixed)
   - Tighten search bounds (±0.05 eps, ±5° PA, ±2px center)
   - Add secondary condition for fallback activation
   - Don't reset `lexceed`
   - Skip gradient when fallback is certain
   - Freeze geometry when Brent result is worse than previous isophote
3. **Resume Phase 28c batch testing** after both fixes verified

## Lessons Learned

- **Always compare against main branch quantitatively before declaring a feature works.** The Brent fallback appeared to work (all stop_code=0, same isophote count) but the residuals told a completely different story (24x worse). Visual QA figures caught this immediately.
- **Feature branches can mask regressions.** The gradient-free fallback ON mode hid the ESO243-49 failure because it rescued the fit. Without testing fallback OFF and comparing to main, we wouldn't have noticed the core fitting regression.
- **Stop codes are informative, not defects.** The 4 stop_code=-1 isophotes on NGC1700 represent correct behavior — the gradient is genuinely unreliable at those radii, and freezing geometry is the right thing to do. Converting them to stop_code=0 with bad geometry is worse than keeping them as -1.
- **Batch testing across diverse galaxies is essential.** A single test case (IC3370 mock) passed fine. The problems only showed up on real galaxies with different morphologies and SNR profiles.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
