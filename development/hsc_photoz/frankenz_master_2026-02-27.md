---
date: 2026-02-27
tags:
  - development
  - dev/hsc_photoz
  - dev/frankenz
  - astro/photometry
  - dev/tool
---
# frankenz — master — 2026-02-27

## Progress

- Completed a thorough code review of all 7 core Python modules in the `frankenz` photometric redshift library (v0.3.5, by Josh Speagle): `pdf.py`, `bruteforce.py`, `knn.py`, `networks.py`, `simulate.py`, `priors.py`, `samplers.py`.
- Identified 18 issues total: 2 critical, 3 high, 6 medium, 7 low severity — all documented with precise `file:line_number` references and suggested fixes in `docs/frankenz_review.md`.
- Wrote a complete user manual (`docs/frankenz_usage.md`) covering the full pipeline from model grid preparation through PDF construction, point estimate extraction, and population/hierarchical inference.
- Mapped the architecture: frankenz is a **Bayesian template-matching** framework (not data-driven ML) with four fitting backends (`BruteForce`, `NearestNeighbors`/KMCkNN, `SelfOrganizingMap`, `GrowingNeuralGas`) that differ only in which subset of models are compared per object.

## Current State

### Key Issues

- **BUG-02 (CRITICAL)**: `loglike()` in `pdf.py:309-311` mutates the caller's `data`, `data_err`, `data_mask` arrays in place. This can silently corrupt data across the per-object fitting loop. Highest priority fix.
- **BUG-01 (CRITICAL)**: `mag_err()` in `simulate.py:86-90` uses undefined variable names (`m`, `mlim`, `sigmadet`). Function is completely broken but not called internally.
- **BUG-03 (HIGH)**: Custom `feature_map` validation in `knn.py:134` references undefined `X_train`, `Xe_train`.
- **BUG-04 (HIGH)**: `hierarchical_sampler.reset()` in `samplers.py:339` doesn't clear `self.samples` — resets wrong attributes.
- **BUG-05 (HIGH)**: `pdfs_summarize()` in `pdf.py:984` mutates input PDFs via `/=`.
- No formal test suite exists. No CI/CD. Only validation is 6 demo notebooks.

### Next Steps

- Fork the `frankenz` repo on GitHub under personal account.
- Fix BUG-01 through BUG-05 (the 5 critical/high bugs) as first commits.
- Add convergence guard (max iteration limit) to `_loglike_s()` iterative loop (`pdf.py:199`).
- Drop Python 2 / `six` compatibility overhead.
- Add minimal unit tests for `loglike`, `gauss_kde`, `pdfs_summarize`.
- Write an end-to-end validation script with real photometric data.

## Lessons Learned

- **`free_scale=True` is essential** for template fitting when model amplitudes are arbitrary. Without it, correct-redshift templates at wrong luminosity are heavily penalized — this is a common user pitfall.
- **`dim_prior=True`** applies a chi2-distribution correction rather than a standard multivariate normal likelihood. This is unusual and may surprise users expecting standard chi2 behavior. Need to document this clearly.
- **`logprob()` applies flat priors by default** (`lnprior = 0`). Users wanting BPZ or other informative priors must write a custom `lprob_func` — this is not obvious from the API.
- The in-place mutation pattern (`data[~clean] = 0.`) is a recurring anti-pattern in this codebase. It's the single most dangerous bug because it produces silently wrong results rather than crashing.
- The generator-based architecture (`_fit`, `_predict`, `_fit_predict`) is well-designed for streaming, but the `save_fits=True` default pre-allocates full `(N_data, N_model)` arrays that make it impractical for large surveys without explicit `save_fits=False`.

---
*Agent: Claude Code (claude-opus-4-6) · Session: be973a49-b9f9-4b00-9de4-22829b363d1c*
