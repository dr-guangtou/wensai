---
date: 2026-03-13
tags:
  - development
  - development/isoster
---

# isoster — main — 2026-03-13

## Progress

- **Harmonic isophote overlays**: `draw_isophote_overlays()` now renders the actual non-elliptical isophote shape when harmonic coefficients (a3/b3, a4/b4, ...) are present. Uses `_compute_harmonic_contour()` to sample 360 points along the perturbed ellipse and draws as a `matplotlib.patches.Polygon`. Backward-compatible: falls back to pure `Ellipse` patches when no harmonics exist. New `draw_harmonics=True` parameter controls this.
- **Harmonic pipeline plumbing**: `build_method_profile()` and `_build_isos_for_overlay()` now preserve harmonic coefficient arrays through the full profile-to-overlay pipeline, so comparison QA figures (all 3 layout modes) show the perturbed contours.
- **QA reorganization**: moved `qa/generate_comparison_figures.py` to `examples/example_qa_comparison/`. Rewrote the script to use the library's `plot_comparison_qa_figure` and `benchmarks/utils/sersic_model.py` instead of duplicating mock generation and bespoke plotting. Exposed `PRESET_CASES` dict and `run_single_case()` function for reuse by other benchmark scripts.
- **Documentation**: created `docs/qa.md` — comprehensive reference for all QA plotting functions (`plot_qa_summary`, `plot_qa_summary_extended`, `plot_comparison_qa_figure`, `draw_isophote_overlays`), helper utilities, `METHOD_STYLES`, stop-code colors, and the synthetic comparison script CLI/reuse API.
- **Regenerated all baseline QA figures** for the 3 benchmark galaxies (eso243-49, IC3370_mock2, ngc3610) with harmonic-aware overlays. 223 tests passing.

## Current State

### Key Metrics
- 223 tests passing (full suite, excluding 3 parked-branch test files)
- 3 benchmark galaxies: all 3 methods (isoster, photutils, autoprof) succeed
- Commit `414c2c3` on main, 1 commit ahead of origin (not pushed)

### Key Issues
- Parked `feat/gradient-free-fallback` untracked files still in working tree — do NOT commit
- eso243-49 isoster still needs retry:1 with EA+LSB config (0 isophotes on first attempt)
- IC3370_mock2 has non-zero stop codes in outskirts with expanded maxsma (761px)

### Next Steps
- Push main to origin (6 commits ahead total including earlier unpushed work)
- Investigate eso243-49 first-attempt failure root cause
- Consider adding harmonic profile panels (a3/b3/a4/b4 vs SMA) to the comparison QA figure layout

## Lessons Learned
- `_detect_harmonic_orders()` must scan both `a{n}` and `b{n}` keys — isophote dicts may have `b4` without `a4` (e.g., when only one coefficient is significant). Initial implementation only checked `a{n}` and missed orders.
- The full overlay pipeline has 3 stages: `build_method_profile` (list-of-dicts to arrays) -> `_build_isos_for_overlay` (arrays back to dicts) -> `draw_isophote_overlays`. Harmonic keys must survive all 3 stages. Easy to miss the middle reconstruction step.
- For synthetic truth-vs-fit comparisons, truth can be injected as a "method" into `plot_comparison_qa_figure` via `build_method_profile` with a custom style (black markers), avoiding the need for a separate plotting function.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
