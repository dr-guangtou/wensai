---
date: 2026-03-04
repo: isoster
branch: main
tags:
  - development
  - astro/photometry
---
## Progress

- **Resolved Centroid Drift**: Investigated and fixed the systematic >10px drift in LSB outskirts observed in mock galaxies.
- **Implemented Gradient SNR-based Damping**: Dynamically scales `geometry_damping` based on $|g|/\sigma_g$ to stabilize Newton-Raphson updates near the noise floor.
- **Added Optional Step Clipping**: Introduced `clip_max_shift` (5.0), `clip_max_eps` (0.1), and `clip_max_pa` (0.5) as configurable safeguards against noise-induced jumps.
- **Fixed Systematic Offset**: Corrected a 0.5px tracking gap by aligning `isoster` truth definitions with 0-based pixel indexing `(nx-1)/2`.
- **Truth-Aware QA Overhaul**: Updated `plot_drift_qa` to highlight Huang2013 model components using white overlays on images and gold stars on 1D profiles.
- **Native Residual Integration**: Modified benchmark to use native `AutoProf` (`_genmodel.fits`) and `photutils` (`build_ellipse_model`) reconstruction for fair 2D comparisons.
- **Robust PA Normalization**: Overhauled `normalize_pa_degrees` with double-angle unwrapping and global truth anchoring to eliminate 80^\circ$ jumps.
- **Verification**: Validated stability on 4 target galaxies (NGC 1453, 3585, 5061, 1404) across two noise levels (Wide and Ultra-Wide).
- **Performance**: Confirmed zero overhead in high-S/N regions; `isoster` remains ~30x faster than `photutils`.
- **Merged to main**: Finalized investigation and merged `feat/investigate-centroid-drift` via merge-commit.

## Lessons Learned

- Newton-Raphson corrections $\Delta \propto 1/g$ explode as  	o 0$; dynamic damping proportional to the gradient SNR is essential for LSB tracking.
- Coordinates defined as "center of pixel" vs "edge of pixel" (1-based vs 0-based) account for most systematic 0.5px offsets in benchmark comparisons.
- Per-iteration clipping acts as an effective "circuit breaker" for noise spikes but must be relaxed enough to allow legitimate structural twists.
- Global anchoring of unwrapped PA profiles to a known reference point significantly improves visualization of multi-component fits.

## Key Issues

- Proceed to Roadmap Item 3: Vectorized Template Photometry (grid-projection extraction using `binned_statistic`).
- Evaluate potential for automated centroid fixing when Gradient SNR drops below a hard floor (e.g. SNR < 1).