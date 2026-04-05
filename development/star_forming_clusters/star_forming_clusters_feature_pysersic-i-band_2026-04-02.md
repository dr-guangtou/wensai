---
date: 2026-04-02
tags:
  - development
  - development/star_forming_clusters
---

# star_forming_clusters — feature/pysersic-i-band — 2026-04-02

## Progress

Built an iterative Sersic profile fitting pipeline for red4522 using pysersic (JAX/NumPyro), applied to HSC i-band imaging as the first step toward multi-band photometric modeling.

### Architecture
- Three-file structure under `hsc/pysersic/`: `config_fitting.yaml` (all parameters), `fitting_utils.py` (reusable functions), `fit_i_band.py` (main driver script).
- Reuses existing `hsc/image_prep_utils.py` for data loading, coordinate conversions, FITS I/O.
- 4-phase pipeline: setup (peak detection + source detection) → BCG fit (FitMulti) → interloper fit (FitSingle cutouts) → iterate.

### Key Technical Decisions
- **FitMulti with 2 independent Sersic profiles** for BCG instead of pysersic's `doublesersic`, because `doublesersic` shares centroids — unsuitable for the ~5 pixel (0.84", 5.5 kpc) core separation.
- **Iterative peak detection** for BCG cores: light Gaussian smoothing (sigma=0.5 pix), find brightest peak, subtract PSF-scale Gaussian (sigma=2 pix), find second peak. This resolves the close double core that standard peak detection missed.
- **Interloper fitting in cutouts** with `sky_type="flat"` to absorb the positive BCG residual background, and masking of other detected interlopers within each cutout to prevent the model from fitting neighbors.
- **Square cutouts with minimum size 51x51** (odd dimensions) — pysersic's FFT convolution fails on non-square or too-small images.
- **student_t_loss** throughout for robustness to artifacts.

### Results (i-band, 2 iterations)
- **BCG Core A** (brighter): x=324.3, y=321.3, flux=2032, r_eff=4.3 pix (4.8 kpc), n=2.7
- **BCG Core B** (diffuse): x=320.3, y=318.4, flux=5710, r_eff=14.8 pix (16.4 kpc), n=6.0
- **13 interlopers** detected and fitted (all successful after cutout fixes)
- **Reduced chi2**: 1.57 (total model), down from ~18 (BCG-only, first attempt)
- **Fractional residual**: 0.60 (total), 0.17 (central 50 pix)

### QA Figures
- 6-panel BCG QA per iteration (data, model, residual, fractional residual map, radial profile, parameter summary)
- **Zoomed 95 kpc QA** showing inner region with 1D slice through both cores — clearly shows double-peak structure
- 3-panel per-interloper QA (data, model, residual)
- Convergence plot (fractional residual + chi2 vs iteration)
- Final summary (full-frame data, total model, residual)

### Bug Fixes During Development
- **Peak detection too aggressive** (smoothing sigma=2, threshold=5*sigma): only found 1 core. Fixed by reducing smoothing to 0.5 pix and using iterative peak-subtract approach.
- **Interloper cutouts failing** (44/60 failed): two causes — (1) cutouts smaller than 25x25 PSF, (2) non-square images causing FFT shape mismatch in pysersic. Fixed by enforcing square cutouts with min_size=51 and odd dimensions.
- **BCG parameters not extracted**: FitMulti returns nested dicts (`source_0`, `source_1`) not flat keys (`xc_0`, `yc_0`). Fixed parameter extraction to handle both formats.
- **Interloper models fitting wrong sources**: no masking of neighbors within cutouts, and no background component to absorb BCG residual. Fixed by adding `sky_type="flat"` and masking other interloper segments.
- **60 interlopers detected** (too many): detection threshold too aggressive (2.0 sigma, 8 pixels). Raised to 3.0 sigma, 15 pixels → 13 interlopers.

## Current State

### Key Issues
- Component B has n=6.0 (hitting warning threshold) — it is absorbing the diffuse envelope. Needs a 3rd component (low-n envelope) to allow B to relax.
- Central fractional residual still 0.17 — significant unmodeled structure in the BCG center.
- All work is uncommitted on `feature/pysersic-i-band`.

### Next Steps
- Add 3rd Sersic component (diffuse envelope, fixed low n~1-2) to the BCG FitMulti catalog.
- Investigate whether the second core (Component A, r_eff=4.3 pix) is the true merger companion or a nuclear point source.
- Extend to other bands once the i-band model is satisfactory.
- Consider whether pysersic is sufficient for the full multi-band pipeline or if a custom NumPyro model is needed.

## Lessons Learned
- pysersic's FFT convolution is sensitive to image dimensions: non-square images cause shape broadcasting errors; cutouts must be ≥ 2x PSF size.
- `doublesersic` shares centroids — not documented prominently but critical to know for mergers with separated cores.
- For fitting sources on top of a diffuse residual, `sky_type="flat"` is essential. Without it, the Sersic model absorbs the background gradient and produces wrong structural parameters.
- Iterative peak detection (find peak → subtract → find next) is more reliable than multi-peak detection for resolving close doubles near the PSF FWHM limit.
- The 1D intensity slice through both cores is the most informative diagnostic for double-core systems — more revealing than azimuthally-averaged radial profiles.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
