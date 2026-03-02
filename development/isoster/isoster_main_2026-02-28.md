---
date: 2026-02-28
tags:
  - development
  - development/isoster
---

# isoster — main — 2026-02-28

## Progress

### AutoProf Algorithm Deep Dive (Pure Analysis Session)

This was a pure research/analysis session — no code changes. The goal was to understand AutoProf's FFT-based isophote fitting algorithm in depth and contrast it step-by-step with isoster's approach.

Six detailed reference documents were produced and archived to `docs/archive/review/`:

- **`autoprof-1-algorithm-contrast.md`** — Full side-by-side comparison of sampling mechanics, fitting objectives, update rules, noise robustness, error estimation, and radial range handling between AutoProf and isoster.

- **`autoprof-2-fft-robust-errors.md`** — Theoretical critique of AutoProf's `_FFT_Robust_Errors` method (radius-perturbation pseudo-bootstrap). Key finding: it conflates photon noise with intrinsic radial geometry gradients, producing inflated errors in steep bulge-disk transition regions. It is a *sensitivity* estimate, not a true *noise* uncertainty.

- **`autoprof-3-variance-map-error-propagation.md`** — Full math for exact error propagation using a variance map: WLS covariance `(XᵀWX)⁻¹` replacing isoster's current OLS + residual scaling; background noise floor strategy (`max(rms, σ_bg/√N)`); and the gradient uncertainty term `B²_n·σ²_g/g⁴` currently missing from `compute_parameter_errors`. No Monte Carlo needed.

- **`autoprof-4-higher-order-harmonics.md`** — AutoProf's two distinct Fourier treatments: (1) `Rscale = exp(Σ Am cos(m(θ+Phim)))` geometric shape deformation of the *sampling path* during fitting; (2) post-fit photometric FFT measurement along fixed ellipses. Compared with isoster's three modes (sequential, simultaneous, ISOFIT in-loop). Discusses b4 science (disky vs boxy isophotes), PSF suppression, and robustness considerations.

- **`autoprof-5-isoband-vs-forced.md`** — AutoProf's `_iso_between` band-average mode: activated when `medflux < ap_isoband_start × σ_bg` AND `isobandwidth ≥ 0.5px`; collects all pixels with SMA in `[R−ΔR, R+ΔR]` on the raw integer grid (no interpolation). Pros: maximises pixel count in low-S/N; Cons: destroys angular information, introduces radial smearing bias `(ΔR²/6) × ∂²I/∂r²`, mixes PSF and galaxy signal differently than path sampling. Contrast with isoster's path-only `extract_forced_photometry`.

- **`autoprof-6-algorithm-improvements.md`** — Key result: Jedrzejewski (1987) corrections are **not** ad hoc. They are the exact Newton-Raphson step for the harmonic residual system under the isotropic gradient approximation. The 4×4 Jacobian is block-diagonal, and the Jedrzejewski formulas are its analytic inverse. Then: seven improvement directions across three levels:
  - **Level 1A**: Profile-based gradient — reuse already-computed `I₀(R_{i-1})` as backward finite difference; eliminates 40–60% of per-iteration sampling cost.
  - **Level 1B**: Batched sampling — vectorise all isophotes per iteration via blocked `map_coordinates`.
  - **Level 2C**: Gradient-free outer-disk fallback — when gradient SNR is poor, minimise `Var[Iⱼ(ε,PA)]` via Brent's method; eliminates stop_code=-1 pathology.
  - **Level 2D**: Adaptive step-size (line search / trust region).
  - **Level 2E**: Smooth radial profile prior (Tikhonov regularisation across adjacent isophotes).
  - **Level 3F**: JAX autodiff — `jax.scipy.ndimage.map_coordinates` is differentiable; autodiff through the harmonic projection gives `∂A₂/∂ε` analytically; Adam adds momentum for flat outer-disk landscapes.
  - **Level 3G**: Joint radial profile fitting (AutoProf-style global optimisation).

## Current State

### Key Issues
- `compute_parameter_errors` currently uses OLS + `var_residual` scaling; the gradient uncertainty term and WLS path are not yet implemented.
- `compute_gradient` makes 1–2 extra `extract_isophote_data` calls per iteration (lines 966, 620, 658 of `fitting.py`), representing ~40–60% overhead — identified as highest-value engineering target.
- stop_code=-1 (gradient failure in noisy outer disk) remains an open algorithmic gap.

### Next Steps
- Decide which improvement directions to implement first (Level 1A profile-based gradient is lowest-risk, highest-reward).
- Consider implementing WLS error propagation with variance map as a near-term accuracy improvement.
- Prototype gradient-free fallback (Level 2C) for stop_code=-1 reduction.

## Lessons Learned

- **AutoProf `_FFT_Robust_Errors` is not a noise uncertainty** — it measures sensitivity to radial position perturbation, not photon noise. It inflates in steep gradient regions by design.
- **Jedrzejewski (1987) is rigorous** — the corrections are exact Newton-Raphson under the isotropic gradient approximation; the 4×4 Jacobian happens to be block-diagonal, making each update a scalar division. The algorithm is not dated; it is optimal given its assumptions.
- **AutoProf's higher-order harmonics serve a different purpose** than isoster's: AutoProf deforms the *sampling ellipse shape* for a better-fitting path; isoster measures intensity sinusoids along a *fixed* ellipse. The two are not directly comparable and target different science goals.
- **Isoband vs path sampling** is a fundamental tradeoff: isoband gains pixel count but loses angular structure. For science that requires harmonic decomposition (b4, kinematic misalignment), isoband is inherently unsuitable regardless of S/N.
- **WLS with a variance map is strictly better than OLS + residual scaling** whenever a reliable per-pixel noise map is available. The covariance derivation is straightforward and requires no Monte Carlo.

---
*Agent: Claude Code (claude-sonnet-4-6) · Session: [paste session ID here]*
