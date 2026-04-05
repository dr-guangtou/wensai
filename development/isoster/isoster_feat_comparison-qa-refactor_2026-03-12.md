---
date: 2026-03-12
tags:
  - development
  - development/isoster
---

# isoster — feat/comparison-qa-refactor — 2026-03-12

## Progress

### Phase 30: Comparison QA Refactor (Tasks 1-7 complete)

- Extracted multi-method comparison QA figure from `benchmarks/benchmark_baseline/baseline_shared.py` into `isoster/plotting.py` as reusable public API
- Added `METHOD_STYLES` dict for isoster/photutils/autoprof visual styling
- Added `build_method_profile()` to standardize isophote lists (isoster/photutils) and array dicts (autoprof) into a common profile format
- Added `plot_comparison_qa_figure()` with three auto-detected layout modes:
  - Mode 1 (solo): data + isophote overlays, model, residual
  - Mode 2 (1v1): data, two residual panels with per-method isophote overlays
  - Mode 3 (3-way): data, three residual panels with per-method overlays
- Implemented cross-method PA normalization via `anchor=` parameter — first method unwrapped freely, subsequent methods anchored to first method's median PA
- Added errorbars on SB panel via log10 error propagation from `intens_err`
- Wrote 19 unit tests, all passing; full suite 223 tests passing
- Exported `plot_comparison_qa_figure`, `build_method_profile`, `METHOD_STYLES` from `isoster/__init__.py`
- Refactored `baseline_shared.py`: removed ~270 lines of duplicated plotting code, replaced with thin wrapper calling library functions
- Updated `docs/spec.md` and `docs/todo.md`

### Cosmetic Refinements

- Tightened title-to-panel and colorbar-to-image gaps
- Replaced axis labels on left panels with scale bar (on data image only) and in-figure text labels
- Shortened centroid offset label to `$\delta$ Cen (pix)`
- Removed SB panel title to avoid overlap with figure title
- Moved runtime statistics from figure title to bottom-left of SB panel (one line per method, in method color)
- Legend rules: Mode 1 shows all stop codes; Mode 2/3 shows only method names (open markers still rendered for non-zero stop codes but unlabeled)

### AutoProf Center Extraction

- Discovered AutoProf uses a single fixed center (`fix_center=True`) for all isophotes
- Center is stored in `.aux` file only, not in `.prof` output
- Added `parse_autoprof_center()` to `autoprof_adapter.py` to extract center from `.aux` file
- `run_autoprof_fit()` now injects constant `x0`/`y0` arrays into profile
- This enables: (a) isophote overlays on AutoProf residual panels, (b) centroid offset comparison relative to isoster's reference center

### Centroid Offset Reference Improvement

- Changed centroid offset computation: reference is now isoster's robust median center (median of inner 10 stop=0 isophotes after 3-sigma clipping) instead of per-method median
- All methods measured relative to the same reference, enabling absolute center comparison

## Current State

### Branch: `feat/comparison-qa-refactor`
- 2 commits pushed, plus uncommitted cosmetic + autoprof center changes
- 19 comparison QA tests passing, 223 total tests passing
- Generated example figures for ESO243-49 in all three modes at `outputs/benchmark_baseline/eso243-49/figures/`

### Key Issues
- Parked `feat/gradient-free-fallback` untracked files still in working tree (do not commit)
- Main branch has 3 commits ahead of origin (not pushed)

### Next Steps
- Commit remaining cosmetic + autoprof center changes
- Merge `feat/comparison-qa-refactor` into main (pending approval)
- Re-run full benchmark suite to regenerate all galaxy figures with new layout
- Push main to origin

## Lessons Learned
- AutoProf wraps photutils internally with `fix_center=True` — all isophotes share one center. The center lives only in the `.aux` file, not `.prof`. Always check the raw output files when adapter code seems to lose information.
- For multi-method centroid comparison, a shared reference center (from the primary method) is more informative than per-method medians — it reveals both drift and absolute offset simultaneously.
- Legend management in multi-method figures needs mode-aware logic: detailed stop-code legends help in solo mode but create clutter in comparison modes.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
