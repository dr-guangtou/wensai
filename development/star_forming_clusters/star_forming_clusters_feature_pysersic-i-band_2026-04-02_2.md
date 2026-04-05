---
date: 2026-04-02
tags:
  - development
  - development/star_forming_clusters
---

# star_forming_clusters — feature/pysersic-i-band — 2026-04-02 (session 2)

## Progress

Iterated the pysersic Sérsic fitting pipeline from a basic 2-component model to a physically-motivated 2+2 component decomposition of the red4522 BCG, achieving central fractional residual of 5.7% within the inner 50 kpc.

### Multi-Component Decomposition

Starting from a 2-component model where Component B had n=7.6 (unphysically steep), developed a decomposition strategy that splits each component into an inner+outer pair with empirically-motivated initial parameters:

- **Inner component**: r_eff = 0.2× single-Sérsic, n=2, flux = 30% of single, slightly rounder
- **Outer component**: r_eff = 1.2× single-Sérsic, n=1 (exponential), flux = 70%, PA offset by 10°

The 2+2 decomposition converged to:

| Component | Role | r_eff (pix/kpc) | n | flux | ellip |
|-----------|------|-----------------|---|------|-------|
| A | Core A nucleus | 0.6 / 0.7 | 0.72 | 585 | 0.09 |
| B | Core A envelope | 6.7 / 7.4 | 0.94 | 1164 | 0.76 |
| C | Core B compact | 3.5 / 3.9 | 2.87 | 2067 | 0.10 |
| D | Diffuse halo | 28.9 / 32.1 | 2.32 | 3876 | 0.08 |

All Sérsic indices below 3 — a dramatic improvement from the n=7.6 single-Sérsic fit.

### Failed Approaches (Instructive)

1. **Sequential extra component**: Fit 2 cores first, subtract, fit 3rd component on residual. Failed because the 2-core model (especially Component B with n=7.6) already absorbed the envelope flux. The residual had no coherent structure for a 3rd component — it found r_eff=320 pixels (the background).

2. **Simultaneous FitMulti with 3 identical-position sources**: MAP optimizer diverged — two sources initialized at the same position create a degenerate parameter space. Produced all-NaN model regardless of mask fraction.

3. **Very tight position priors (sigma=0.1 pix)**: Caused `LeftTruncatedDistribution got invalid low parameter` errors. sigma=0.5 was numerically safe.

The key insight: parameter coupling between components is too strong for sequential fitting. All components must be optimized jointly, but with well-differentiated initial parameters to avoid degeneracy.

### Interloper Detection Overhaul

Redesigned the interloper detection policy:

- **Iteration 0**: High-threshold (5σ, npixels=20) detection on the original image. Only finds 7 high-confidence interlopers; the giant BCG envelope still appears as a single segment.
- **Iteration 1+**: Lower threshold (3σ, npixels=10) detection on the BCG-subtracted residual. Finds 13 real interlopers as compact, individual sources.
- Fresh interloper sample each iteration (not carried over from previous).
- Each interloper fitted with `sky_type="flat"` to absorb BCG residual background.
- Other detected interlopers masked within each cutout to prevent fitting neighbors.

### QA Figure Updates

- **Interloper detection QA** per iteration: 3-panel (locations on data, segmentation map, segment contours)
- **Interloper mosaic**: all interlopers in one figure (data | model | residual rows) replacing individual per-source figures
- **BCG fitting mask panel**: data with interloper mask (red) and object mask (blue) overlay in the BCG QA
- **Zoomed QA**: interloper mask contours on data panel

### Metric Improvements

- Central fractional residual now computed within a configurable radius (default 50 kpc = 45 pixels) and excludes interloper-masked + bad pixels
- Comparison across models (inner 50 kpc, excluding masked pixels):
  - 2-component (n=2.8, n=7.6): central_frac_resid = 0.161
  - 2+1 decomposition (split B only): central_frac_resid = 0.157
  - 2+2 decomposition (split A+B): **central_frac_resid = 0.057** (3× improvement)

## Current State

### Key Files

- `hsc/pysersic/config_fitting.yaml` — all parameters including decomposition config
- `hsc/pysersic/fitting_utils.py` — data loading, detection, metrics, QA figures
- `hsc/pysersic/fit_i_band.py` — main pipeline driver
- `data/hsc_images/pysersic/red4522_i_params.yaml` — best-fit parameters (4 BCG + 13 interlopers)
- `data/hsc_images/pysersic/red4522_i_model.fits` — full model image
- `data/hsc_images/pysersic/red4522_i_residual.fits` — residual image
- 11 QA figures in `figures/pysersic/`

### Issues

- Component A (Core A nucleus) has r_eff=0.6 pix — essentially unresolved. May need a pointsource + Sérsic decomposition instead.
- Component B (Core A envelope) has very high ellipticity (e=0.76) — reflects tidal distortion but may be absorbing asymmetric structure.
- All work uncommitted on `feature/pysersic-i-band`.
- The `run_3component_comparison.py` script is outdated and should be removed before commit.

### Next Steps

- Inspect residual image in DS9 for remaining structure; decide if 5th component is needed.
- Consider fixing Component A to `pointsource` profile type.
- Begin extending to other bands (r, z) using the i-band model as initialization.
- Eventually: forced photometry or joint multi-band fitting.

## Lessons Learned

### Multi-Component Sérsic Decomposition

- **Joint fitting is mandatory.** Sequential fitting (fit A, subtract, fit B on residual) fails because strong parameter coupling means A absorbs flux that should go to B. All components must be optimized simultaneously.
- **High Sérsic index (n>4) is a red flag**, not a physical result. It means the single-component model is trying to capture both a steep inner profile and a shallow outer profile. The fix is to split into inner (smaller r_eff, moderate n~2) + outer (larger r_eff, low n~1) components.
- **Initial parameters must be well-differentiated.** Two components at the same position with similar parameters create a degenerate saddle point that breaks the optimizer. The empirical recipe: inner gets 20% of r_eff and 30% of flux; outer gets 120% of r_eff and 70% of flux; inner is slightly rounder; outer has a PA offset.
- **No initial n should exceed 3.** High-n creates steep inner profiles that couple too strongly with inner components.
- **Each component must dominate the surface brightness in some radial range.** No component should be completely "underneath" another. Smaller r_eff components need higher central surface brightness; larger components need fainter centers.
- **High ellipticity (e>0.5) should be made rounder in initial guesses.** Extreme axis ratios create numerical difficulties and often reflect asymmetric structure that a Sérsic can't capture anyway.

### Interloper Detection

- **Detecting interlopers on the original image is dominated by the BCG envelope** — the entire central region becomes one giant segment. Must detect on the BCG-subtracted residual for clean separation of individual sources.
- **Two-stage detection** works well: high-threshold on original for confident initial catalog, then re-detect on residual each iteration for refinement.
- **Each interloper cutout needs sky_type="flat"** to absorb the positive BCG residual background. Without it, the Sérsic model absorbs the gradient and produces wrong structural parameters.
- **Mask other interlopers within each cutout** to prevent the model from fitting a neighbor instead of the target source.

### pysersic Limitations

- **FitMulti diverges with identically-positioned sources** unless initial parameters are sufficiently different. This is a fundamental optimizer limitation, not a bug.
- **autoprior fails on residual images** with negative values. Use `SourceProperties` on `np.clip(residual, 0, None)` or construct priors manually.
- **FFT convolution requires square cutouts** with odd dimensions ≥ 2× PSF size. Non-square images cause shape broadcasting errors.
- **Very tight truncated Gaussian priors (sigma<0.5 pix)** can produce invalid distribution parameters. sigma=0.5 is the practical floor.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
