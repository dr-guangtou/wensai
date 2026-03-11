---
date: 2026-03-05
tags:
  - development
  - dev/isoster
---
# isoster — feat/gradient-free-fallback — 2026-03-05

## Progress

- **Phase 28: Gradient-free Brent fallback** — implemented the core feature that prevents premature `stop_code=-1` in low-surface-brightness (LSB) outer isophotes by switching from Newton-Raphson geometry updates to 1D Brent minimization when the radial gradient SNR drops below a configurable threshold.
- Added two new config parameters to `IsosterConfig`: `use_gradient_free_fallback` (default `True`) and `gradient_free_snr_threshold` (default `1.5`).
- Implemented `_gradient_free_geometry_update()` in `fitting.py` (~190 lines net), handling all 4 geometry parameters (center x/y, PA, eps) via `scipy.optimize.minimize_scalar` with bounded Brent method.
- Updated docs: `algorithm.md` (mechanism description), `configuration-reference.md` (new params), `spec.md`, `future.md`.
- Wrote 6 unit tests covering: stop-code prevention, geometry reasonableness, high-SNR passthrough, config defaults, fixed-geometry respect, computational budget.
- Updated `tests/integration/test_edge_cases.py` for compatibility.

- **Phase 28b: Comparison example script** — created `examples/example_gradient_free_fallback/` with a self-contained script that compares fallback ON vs OFF vs photutils.
  - Handles 2D and 3D FITS cubes automatically.
  - Supports `--noise-sigma` injection to stress-test the fallback.
  - Produces a QA comparison figure (2-column layout: image panels + 5 stacked 1D profiles on `sma^0.25` x-axis).
  - Prints a summary table with isophote count, max SMA, runtime, and stop-code distribution.

## Key Results

| Test case | Fallback ON | Fallback OFF | Observation |
|-----------|------------|-------------|-------------|
| IC3370 mock (clean) | 67 iso, **all sc=0** | 67 iso, 11 sc=-1 | Fallback eliminates gradient errors |
| IC3370 mock (noise=5) | 67 iso, 61 sc=0 + 6 sc=2 | 67 iso, 33 sc=-1 | Benefit amplified by noise |
| eso243-49 (real galaxy) | 50 iso, **all sc=0** | **0 isophotes** | Without fallback, fitting completely fails on this target |

Runtime overhead: ~7x slower for fallback-ON (0.57s vs 0.08s on IC3370), but still 37x faster than photutils (21s). The overhead comes from `minimize_scalar` calls only at low-SNR radii; high-SNR isophotes use the fast gradient path.

## Current State

### Uncommitted changes (on `feat/gradient-free-fallback`)
- `isoster/config.py` — 2 new fields
- `isoster/fitting.py` — `_gradient_free_geometry_update()` + integration into `fit_isophote`
- `docs/algorithm.md`, `docs/configuration-reference.md`, `docs/spec.md`, `docs/future.md` — updated
- `tests/unit/test_gradient_free_fallback.py` — 6 new tests
- `tests/unit/test_phase27_features.py` — phase 27 feature tests
- `tests/integration/test_edge_cases.py` — compatibility update
- `examples/example_gradient_free_fallback/` — new example (2 files)

### Key Issues
- None blocking. Feature is functionally complete and tested.

### Next Steps
- Commit and push the `feat/gradient-free-fallback` branch.
- Run full test suite (`uv run pytest tests/`) before merge.
- Consider adding the example to the docs site navigation.
- Possible follow-up: adaptive `gradient_free_snr_threshold` based on background noise estimation.

## Lessons Learned

- The gradient-free fallback completely transforms behavior on challenging targets (eso243-49 went from 0 to 50 isophotes). This validates the design decision to make it the default.
- The `normalize_pa_degrees` helper (double-angle unwrap trick) is essential for any PA comparison plot — without it, 180-degree jumps corrupt visual comparisons.
- When writing example scripts that produce matplotlib figures, avoid TeX-dependent label strings (`$...$`) unless `text.usetex` is explicitly managed — the default renderer may attempt LaTeX compilation and fail on missing fonts.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
