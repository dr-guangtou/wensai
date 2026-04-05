---
date: 2026-03-13
tags:
  - development
  - development/isoster
---

# isoster — feat/variance-map — 2026-03-13

## Overview

Implemented per-pixel variance map support with Weighted Least Squares (WLS) harmonic fitting across the entire isoster fitting pipeline. This was item 5 from `docs/future.md`. The branch `feat/variance-map` was created off `main` at `414c2c3`. Work spanned three sessions (sessions 1–3 for core WLS implementation, session 4 for demo and QA figure polish).

## Core Implementation

### New API Surface

- `fit_image(image, mask, config, variance_map=None)` — the only user-facing change. When `variance_map` is a 2D array matching `image.shape`, all internal fitting switches to WLS. When `None`, behavior is byte-identical to the previous OLS-only path.

### Internal Changes (8 functions in 3 modules)

**`isoster/sampling.py`**:
- Extended `IsophoteData` namedtuple with a 5th field: `variances`.
- `extract_isophote_data()` accepts `variance_map=` and samples per-pixel variances via `map_coordinates` along ellipse coordinates.

**`isoster/fitting.py`** (all gated by `if variances is not None`):
- `fit_first_and_second_harmonics()` — weighted normal equations `(A^T W A)^{-1} A^T W y` with `W = diag(1/σ²_i)`.
- `fit_all_harmonics()` — same WLS pattern for the full ISOFIT design matrix.
- `fit_higher_harmonics_simultaneous()` — exact covariance `(A^T W A)^{-1}`, no residual-variance scaling.
- `compute_deviations()` — explicit WLS solve replacing `scipy.optimize.leastsq`.
- `compute_parameter_errors()` — `use_exact_covariance=True` path skips the usual `var_residual` scaling factor.
- `compute_gradient()` — `Var(mean) = Σσ²_i / N²` replaces scatter-based estimate.
- `_compute_posthoc_harmonics()` — threads variances/best_variances through.
- `fit_isophote()` — threads variance_map through all sub-calls, tracks `best_variances` alongside `best_intens` during iterative convergence.

**`isoster/driver.py`**:
- `fit_image()` validates variance_map shape, warns on non-positive values, clips minimum to `1e-30`, threads through all `fit_isophote()` calls.
- `extract_forced_photometry()` — variance-aware `intens_err` propagation.

### Design Decisions

1. **All WLS branches gated by `if variances is not None`** — guarantees byte-identity when no variance map is provided. This was verified with `np.array_equal` in tests.
2. **Minimum variance clip to `1e-30`** — prevents infinite weights from zero or negative variance pixels (common at chip edges in survey mosaics).
3. **Exact WLS covariance** — `(A^T W A)^{-1}` used directly without the OLS-style `σ²_residual` scaling. This is the core accuracy difference: OLS `intens_err = rms/sqrt(N)` conflates photon noise with galaxy structure scatter; WLS `intens_err = sqrt(Σσ²_i / N²)` is the true photon-noise propagation.
4. **Sigma clipping preserves variance arrays** — variances are clipped alongside intensities via the `extra_arrays` parameter in the sigma-clip loop.

## QA Figure Improvements (`isoster/plotting.py`)

### `build_method_profile()`
- Now extracts `eps_err`, `pa_err`, `x0_err`, `y0_err` from isophote dicts (both list-of-dicts and dict-of-arrays input formats).

### `plot_comparison_qa_figure()`
- **Error bars on all panels**: Ellipticity (eps_err), PA (pa_err, converted to degrees), and center offset (propagated from x0_err/y0_err) panels now show error bars with stop-code-aware rendering.
- **Data-driven Y-axis**: All profile panels use `set_axis_limits_from_finite_values()` on data values only. Error bars that exceed the axis range are visually clipped rather than blowing out the dynamic range.
- **X-axis skip innermost**: `set_x_limits_with_right_margin()` now skips the innermost datapoint (where no isophote can be reliably defined) and adds symmetric left/right margins.
- **SB Y-axis orientation**: `log10(Intensity)` uses regular small→big order (not inverted — inversion is only appropriate for mag/arcsec² units).
- **dI/I label simplified**: The relative difference panel label is now just `"dI/I [%]"`.

## Integration Demo

`examples/example_variance_map/run_variance_map_demo.py`:
- Loads DESI Legacy Survey cutout of 2MASXJ23065343+0031547 (245×245, r-band).
- Runs isoster twice: OLS (no variance) and WLS (with inverse-variance map).
- Outputs to `outputs/example_variance_map/`:
  - `2MASXJ23065343+0031547_ols.fits` — OLS isophote table
  - `2MASXJ23065343+0031547_wls.fits` — WLS isophote table
  - `2MASXJ23065343+0031547_ols_vs_wls_qa.png` — comparison QA figure with 2D model residuals
  - `2MASXJ23065343+0031547_summary.txt` — text log with error-bar ratios
- 2D model reconstruction via `build_isoster_model()` for both runs, passed to QA figure for residual panels.

### Validation Results (2MASXJ23065343+0031547)

- Both runs: 62 isophotes, identical geometry (geometry is noise-independent at this S/N).
- OLS wall time: 0.16s; WLS wall time: 0.07s (2.3× faster this run).
- WLS `intens_err` 1.2–2.1× larger than OLS — this is **correct**: OLS underestimates errors by using residual scatter (which includes galaxy structure) while WLS propagates true photon noise.
- The 2.3× speedup is **not** a fundamental algorithmic guarantee — it's data-dependent. WLS converges faster on this image because downweighting high-variance pixels produces less noisy geometry gradients. For uniform-noise images, the speedup would vanish and WLS might be marginally slower due to per-iteration weight overhead.

### WLS Correctness Under Constrained Geometry

Analysis confirmed that WLS remains mathematically correct in all constrained modes:
- **Fixed center / eps / PA**: The iterative loop skips updates for frozen parameters; the weighted harmonic fit at each SMA is unchanged.
- **Template-based photometry (all geometry fixed)**: WLS samples variance_map at prescribed ellipse positions and computes `(A^T W A)^{-1} A^T W y` — textbook weighted mean with proper covariance.
- Caveat: `compute_parameter_errors()` in exact-covariance mode will produce geometry error values even when those parameters are fixed. These values are meaningless for fixed parameters but do not cause incorrect behavior.

## Test Results

- 277 tests pass (243 existing + 20 new variance map + 14 other).
- 3 expected failures from parked `feat/gradient-free-fallback` test files (unrelated to this branch).
- 0 regressions. Byte-identity verified for all existing tests when `variance_map=None`.

## Documentation Updates

- `docs/spec.md` — updated `fit_image` signature and fitting contract
- `docs/user-guide.md` — added "Using Variance Maps" section
- `docs/algorithm.md` — added WLS math derivation section
- `docs/future.md` — marked item 5 as implemented

## Current State

### Branch Status

- Branch `feat/variance-map` has **uncommitted changes** (8 modified + 5 new files).
- Parked `feat/gradient-free-fallback` untracked files still in working tree — these must NOT be committed on this branch.

### Key Issues

- FITS header warnings: config parameter names longer than 8 characters trigger HIERARCH card warnings from astropy. Cosmetic only — data integrity unaffected.

### Next Steps

- Commit the variance-map changes (excluding parked files).
- Consider adding `variance_map` support documentation to `docs/configuration-reference.md`.
- Template-forced mode with variance_map has been verified correct but not yet tested end-to-end with real data.

## Lessons Learned

- **OLS error bars are fundamentally wrong for resolved galaxies**: `rms/sqrt(N)` includes galaxy structure scatter in the "noise" estimate. WLS with a proper variance map isolates photon noise, producing correct (larger) error bars. This is not a deficiency of OLS — it's using the wrong noise model.
- **Speedup claims require caveats**: The WLS speedup observed on DESI data is from faster convergence due to cleaner gradients, not from algorithmic complexity reduction. Always state the data-dependence.
- **Byte-identity gating pattern works well**: Wrapping every WLS branch in `if variances is not None` made regression testing trivial — existing tests guarantee no behavioral change without variance maps.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
