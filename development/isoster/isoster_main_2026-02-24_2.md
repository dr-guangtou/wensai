---
date: 2026-02-24
tags:
  - development
  - development/isoster
---

# isoster — Higher-Order Harmonics: ISOFIT & Model Reconstruction — 2026-02-24

This entry covers four sessions of intensive work on the `feat/true-isofit-harmonics` branch (now merged to main), spanning roughly 24 hours. The focus was implementing true ISOFIT simultaneous harmonic fitting (Ciambur 2015) and fixing two bugs in the model reconstruction pipeline related to higher-order harmonics.

## Background: The Post-Hoc Problem

Before this work, isoster's `simultaneous_harmonics=True` mode was misleadingly named. Higher-order harmonics (a3, b3, a4, b4, ...) were fitted **post-hoc** — only after geometry convergence, in a separate least-squares solve. This meant:

1. The RMS used for convergence testing still contained higher-order harmonic signal, potentially inflating the convergence criterion and causing premature stop or late convergence.
2. Cross-correlations between geometry harmonics (orders 1-2) and higher-order harmonics were not accounted for during iteration.
3. The approach did not match the true ISOFIT algorithm described in Ciambur (2015), which fits all harmonics simultaneously within each iteration of the geometry loop.

## What Was Built: True ISOFIT Implementation (Phases 1-5)

### Phase 1-2: Core Implementation (`6ef2e15`)

Three new helper functions in `fitting.py`:

- **`build_isofit_design_matrix(angles, orders)`** — Constructs extended design matrix `[1, sin(θ), cos(θ), sin(2θ), cos(2θ), sin(n₁θ), cos(n₁θ), ...]` for simultaneous fitting of geometry + higher-order harmonics.
- **`fit_all_harmonics(angles, intens, orders)`** — Simultaneous least-squares fit returning coefficients and inverse of the normal matrix (for error estimation).
- **`evaluate_harmonic_model(angles, coeffs, orders)`** — Full ISOFIT model evaluation for RMS computation.

The `fit_isophote()` iteration loop was modified for a **dual-path** approach:

- **Per-iteration decision**: After sigma clipping, `use_isofit_this_iter` is set based on whether `n_points >= 1 + 2*(2 + len(orders))` (the minimum for the extended design matrix). This allows graceful fallback at small SMA or heavy masking without pre-committing.
- **ISOFIT RMS**: When ISOFIT is active, the model residual used for convergence excludes higher-order signal, giving a cleaner convergence criterion.
- **5x5 covariance sub-matrix**: Geometry parameter errors are estimated from the upper-left 5x5 block of the full covariance, preserving the correct conditional variances.
- **Harmonics stored at best-geometry update**: Rather than only at final convergence, harmonic coefficients are stored whenever the geometry improves. This means the best harmonics always come from the best geometry.
- **Post-convergence guards**: All three exit paths (convergence, geometry-stability, max-iteration) check whether ISOFIT harmonics were already stored before falling back to post-hoc fitting.

Key design decisions:

- **No numba for ISOFIT path**: Variable-width design matrices negate JIT compilation benefits. Numpy `lstsq` is fast enough.
- **Geometry updates unchanged**: `A1, B1, A2, B2 = coeffs[1:5]` — identical indexing in both paths, no changes to the geometry update logic.
- **Coefficient layout**: `[I₀, A₁, B₁, A₂, B₂, A_{n1}, B_{n1}, ...]` — k-th order at indices `5+2k` (sin) and `5+2k+1` (cos).

### Phase 2 Tests (`2ecd963`)

Five behavior tests for `fit_isophote()`:
- Default path is bit-for-bit unchanged when `simultaneous_harmonics=False`
- ISOFIT converges on data with injected a4 boxiness
- Fallback to 5-param with insufficient sample points (emits RuntimeWarning)
- Fallback under heavy masking
- Inner 5-param + outer ISOFIT profile continuity (mixed mode)

### Phase 3: Integration Tests (`fd20fa3`)

Four integration tests validating end-to-end behavior:

| Test | Key Result |
|------|-----------|
| Boxy Sersic a4 recovery | Median \|a4,b4\| = 0.043 vs injected 0.04 |
| ISOFIT vs post-hoc comparison | b4 correlation = 1.000, identical median magnitudes |
| M51 real-data regression | No convergence degradation (55.6% vs 66.7%) |
| EA + ISOFIT high-ellipticity mock | 100% convergence, 0.3% intensity accuracy |

### Phase 4: Documentation (`03efb66`)

Updated `config.py`, `CLAUDE.md`, `spec.md`, `user-guide.md`, and added implementation journal.

### Phase 5: Benchmark (`d0785cb`)

ISOFIT overhead measured at **~25-35%** wall-clock time vs default 5-param path on a 500x500 Sersic n=2 mock (0.065s vs 0.049s baseline). Acceptable given the improved accuracy.

## Key Findings: Model Reconstruction Issues

After completing the ISOFIT implementation, an audit of `build_isoster_model()` in `model.py` revealed two bugs that affected all higher-order harmonic reconstruction, not just ISOFIT:

### Issue 1: Silent Dropping of Higher-Order Harmonics

**Problem**: `build_isoster_model()` defaulted `harmonic_orders=[3, 4]`. If fitting used `harmonic_orders=[3, 4, 5, 6, 7]`, calling without explicit orders would silently drop orders 5, 6, 7 from the 2D model reconstruction. The example code in `shared.py` had already worked around this with a manual key-scanning loop.

**Fix**: Changed default to `harmonic_orders=None`. When `None`, the function now scans **all** isophote dicts for keys matching the regex pattern `a{n}` (n >= 3), collecting every harmonic order present in the data. Returns a sorted list, or empty list if no harmonics are found (equivalent to `use_harmonics=False`). Scanning all isophotes (not just the first) handles the case where inner isophotes fell back to 5-param and lack higher-order keys.

### Issue 2: EA Mode Angle Space Mismatch

**Problem**: When `use_eccentric_anomaly=True`, harmonics are fitted in ψ-space (eccentric anomaly: `ψ = arctan2(y/(1-ε), x)`). But `build_isoster_model()` used `θ = arctan2(y_rot, x_rot)` — position angle (φ-space) — for harmonic evaluation. This is incorrect because applying ψ-space coefficients in φ-space produces wrong harmonic deviations. The error grows with ellipticity and matters most for ε > 0.5.

**Root cause**: This was a **pre-existing bug** — present since the original model reconstruction code was written, affecting both ISOFIT and post-hoc paths equally. It simply wasn't noticed because most test galaxies had moderate ellipticity.

**Fix** (two-part):
1. `fit_isophote()` now stores `use_eccentric_anomaly: bool` in every isophote result dict (at both best-geometry update paths in the iteration loop).
2. `build_isoster_model()` gained a new `use_eccentric_anomaly` parameter (default `None`). When `None`, auto-detects from the isophote dicts. When `True`, computes `ψ = arctan2(y_rot/(1-eps), x_rot)` for harmonic evaluation. When `False`, uses standard `φ = arctan2(y_rot, x_rot)`.

### Testing the Fixes

Five new unit tests in `tests/unit/test_model.py`:
- Auto-detect matches explicit harmonic orders
- Auto-detect does not silently drop higher orders (a5 signal preserved)
- Graceful fallback with no harmonics present
- EA vs phi models produce different results at eps=0.6 (confirming the angle space matters)
- Explicit parameter overrides isophote flag

All 180/180 tests pass after these fixes.

## Current State

- **Branch**: `main` at `7643184` (feature branch merged and deleted)
- **Tests**: 180/180 pass (was 166 at start of this work)
- **New files**: `benchmarks/bench_isofit_overhead.py`, `tests/integration/test_isofit_integration.py`
- **Modified**: `isoster/fitting.py` (+193 lines), `isoster/model.py` (+52 lines), `tests/unit/test_fitting.py` (+318 lines), `tests/unit/test_model.py` (+145 lines)

### Key Issues

- None blocking. The ISOFIT implementation is complete and the model reconstruction bugs are fixed.
- The ISOFIT vs post-hoc comparison shows near-identical coefficients (b4 correlation = 1.0), suggesting the post-hoc approach was adequate for most cases. The main benefit of true ISOFIT is the cleaner RMS and proper handling of cross-correlations, which may matter more for galaxies with strong higher-order features.

### Next Steps

- Run the LegacySurvey example campaign again with auto-detecting model reconstruction to verify QA figures use the correct angle space
- Consider whether the ISOFIT overhead (~25-35%) warrants making it the default for `compute_deviations=True` cases
- The `build_ellipse_model` (deprecated alias) should be removed in v0.3

## Lessons Learned

- **Auto-detection beats hardcoded defaults**: The `harmonic_orders=[3, 4]` default was a foot-gun. Scanning the actual data is more robust and eliminates a class of silent errors.
- **Angle space consistency is critical**: When harmonics are fitted in one angle space (ψ) but evaluated in another (φ), the error is subtle — it doesn't produce obviously wrong results, just slightly wrong ones that grow with ellipticity. This kind of bug survives visual inspection and only becomes apparent in quantitative tests at high ε.
- **Store metadata in results dicts**: Adding `use_eccentric_anomaly` to the isophote dict enables downstream code to auto-detect the correct behavior without requiring the user to remember and pass the flag. This pattern (fitting stores metadata, reconstruction auto-detects) should be applied to other modes too.
- **TDD works well for bug fixes**: Writing 5 failing tests before implementing the fixes ensured the fixes were minimal and correct. The EA angle space test (comparing EA vs phi models at eps=0.6) was particularly valuable — it confirms the bug exists and the fix works in a single assertion.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
