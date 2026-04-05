---
date: 2026-03-14
tags:
  - development
  - development/isoster
---

# isoster — feat/variance-map — 2026-03-14

## Summary

Session 5 on the `feat/variance-map` branch. Built the systematic WLS testing script, improved variance map input validation, audited byte-identity against main, and updated all documentation to accurately reflect the feature.

## Progress

### Systematic WLS Testing Script

- Created `examples/example_wls_systematic/run_wls_systematic.py` (~600 lines) — a reusable multi-galaxy, multi-config comparison harness.
- **Galaxy registry**: extensible list of dicts with data paths, initial geometry, AutoProf metadata. Initial entry: 2MASXJ23065343+0031547 (DESI Legacy Survey r-band).
- **Configuration matrix** (6 presets):
  - `default` — free geometry
  - `fix_center` — center locked
  - `fix_center_pa` — center + PA locked
  - `fix_geometry` — center + PA + eps locked
  - `ea_sampling` — eccentric anomaly mode
  - `isofit` — simultaneous harmonics
- Each config runs **isoster OLS, isoster WLS, photutils** (with matching `fix_*` kwargs), and **AutoProf** (free-geometry configs only, via subprocess adapter).
- **Two QA figures per config**: OLS-vs-WLS comparison, and all-methods comparison (when external methods present). Figures use the library's `plot_comparison_qa_figure()`.
- **2D models for all methods**: isoster via `build_isoster_model()`, photutils via `build_ellipse_model()` adapter, AutoProf from native FITS output.
- **Summary CSV** per galaxy + grand summary across all galaxies. Columns: n_isophotes, wall_seconds, convergence_rate, median_intens_err, wls_ols_err_ratio.
- **CLI**: `--galaxy`, `--config`, `--no-autoprof`, `--no-photutils` filters.

### Full Run Results (2MASXJ23065343+0031547)

| Config | isoster OLS | isoster WLS | photutils | WLS/OLS err ratio |
|--------|:-----------:|:-----------:|:---------:|:-----------------:|
| default | 62 iso, 0.17s | 62 iso, 0.07s | 54 iso, 1.21s | 1.523 |
| fix_center | 62, 0.10s | 62, 0.07s | 54, 0.82s | 1.517 |
| fix_center_pa | 62, 0.09s | 62, 0.07s | 54, 0.77s | 1.485 |
| fix_geometry | 62, 0.08s | 62, 0.08s | 0 (failed) | 1.431 |
| ea_sampling | 62, 0.09s | 62, 0.07s | 54, 1.22s | 1.516 |
| isofit | 62, 0.11s | 62, 0.09s | 54, 1.23s | 1.572 |

- WLS/OLS error ratio consistent across all configs: **1.43–1.57×** (expected range 1.2–2.1×).
- isoster 7–17× faster than photutils across all configs.
- AutoProf adapter not importable in the uv environment (needs separate numpy <2 Python).
- photutils returned 0 isophotes for `fix_geometry` — all three geometry params locked simultaneously appears unsupported.

### dI/I Panel Y-Axis Cap (`isoster/plotting.py`)

- When any dI/I data points exceed ±100%, the Y-axis is capped at ±108% (with 8% margin).
- Outlier points are clamped to the boundary and rendered as filled triangle markers (▲ for positive outliers, ▼ for negative) to visually indicate lower/upper limits.
- Non-outlier data retains original markers. Cap only activates when outliers exist — well-behaved panels are unaffected.

### Variance Map Input Validation (`isoster/driver.py`)

Improved the `fit_image()` validation block to handle all pathological variance values:

| Input | Previous behavior | New behavior |
|-------|-------------------|--------------|
| `NaN` | Silently propagated through fit | Replaced with `1e30` (near-zero weight), `RuntimeWarning` emitted |
| `inf` / `-inf` | `+inf`: weight=0 (silent). `-inf`: corrupted fit | Replaced with `1e30`, `RuntimeWarning` emitted |
| `<= 0` | Warning, clamped to `1e-30` | Same, but message improved to mention clamping |
| Caller mutation | Array modified in-place | **Copy-on-write** — `variance_map.copy()` before any modification |

4 new tests in `test_variance_map.py::TestInputValidation`: `test_nan_values_warn_and_sanitized`, `test_inf_values_warn_and_sanitized`, `test_caller_array_not_mutated`.

### Byte-Identity Audit

- Confirmed all WLS code paths in `driver.py`, `fitting.py`, `sampling.py` are gated by `if variances is not None` or `if variance_map is not None`.
- Default (`variance_map=None`) path is byte-identical to main — verified by `TestByteIdentity` tests and manual diff review.
- 6 ungated plotting improvements (error bars on eps/PA panels, data-driven Y-axes, dI/I cap, x-axis skip-innermost) are intentional QA polish bundled with this branch.

### Documentation Updates

- **`docs/algorithm.md`**: Fixed stale `IsophoteData` field count (4 → 5, added `variances`).
- **`docs/user-guide.md`**: Expanded WLS input requirements with NaN/inf handling, copy-on-write guarantee, constraint mode compatibility, expected WLS/OLS error ratio range.
- **`docs/configuration-reference.md`**: Added new "Variance Map / WLS Fitting" section with input validation table and parameter interaction notes.

## Current State

### Branch State
- Branch: `feat/variance-map` (off `main` at `414c2c3`)
- **All changes uncommitted** — 10 modified tracked files + 3 new untracked feature files
- 277 tests passing (+ 4 new validation tests = 281 total on this branch)
- 3 test failures from parked `feat/gradient-free-fallback` untracked files (expected, not part of this branch)

### Parked Files (do NOT commit)
- `examples/example_gradient_free_fallback/`
- `tests/unit/test_gradient_free_fallback.py`, `tests/unit/test_phase27_features.py`
- `docs/gradient-free-fallback-issue-report.md`, `docs/review_gemini_20260312.md`
- `.superset/`

### Files Modified (this branch, all sessions)

**Modified (tracked):**
- `isoster/driver.py` — variance_map validation + sanitization, threading through fit loops
- `isoster/fitting.py` — WLS paths in all harmonic/gradient/error functions (+316 lines)
- `isoster/sampling.py` — `IsophoteData.variances` field, variance sampling
- `isoster/plotting.py` — dI/I cap, error bars on all panels, data-driven Y-axes
- `tests/unit/test_driver.py` — `**kwargs` in mock functions
- `docs/algorithm.md`, `docs/spec.md`, `docs/user-guide.md`, `docs/future.md`, `docs/configuration-reference.md`

**New (untracked, part of this feature):**
- `tests/unit/test_variance_map.py` — 24 tests (20 original + 4 new validation)
- `examples/example_variance_map/run_variance_map_demo.py` — single-galaxy OLS vs WLS demo
- `examples/example_wls_systematic/run_wls_systematic.py` — multi-config systematic harness

## Next Steps

- Commit all `feat/variance-map` changes (excluding parked files) — ready for review
- Test with additional galaxies (add to `GALAXY_REGISTRY`) to validate WLS generalization
- Run with AutoProf in the numpy <2 subprocess environment to complete the 4-method comparison
- Investigate why photutils returns 0 isophotes for `fix_geometry` on this galaxy

## Lessons Learned

- **Variance map sanitization must be explicit**: `np.inf` passes `> 0` checks silently, producing weight=0 (harmless) or weight=-0 for `-inf` (harmful). `NaN` propagates silently through all arithmetic. Always check `isnan` and `isinf` separately before the positive-check.
- **Copy-on-write is essential for scientific arrays**: Users pass the same variance map to multiple calls. Mutating it in-place causes subtle cross-contamination bugs that are extremely hard to diagnose.
- **WLS error ratios are stable across constraint modes**: The 1.43–1.57× range held across all 6 configs for this galaxy. This is expected — WLS error bars reflect per-pixel noise, which is independent of geometry constraints.
- **Photutils `fix_geometry` is fragile**: With all three params fixed (`fix_center + fix_pa + fix_eps`), photutils returned 0 isophotes. isoster handled this correctly with 62 isophotes.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
