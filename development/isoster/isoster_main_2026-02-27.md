---
date: 2026-02-27
tags:
  - development
  - dev/isoster
---
# isoster — main — 2026-02-27

## Progress

### AutoProf adapter (`benchmarks/utils/autoprof_adapter.py`)
- Built subprocess-based driver to run AutoProf in a separate Python process (AutoProf 1.3.4 requires `photutils 1.5` → `numpy<2`, incompatible with isoster's `numpy 2.x` environment)
- Added `run_ellipse_model=True` option to produce AutoProf's native 2D model FITS via its `EllipseModel` pipeline step
- Fixed `KeyError: 'SB_e'` — when `ap_fluxunits="intensity"`, AutoProf's internal results use `"I_e"` not `"SB_e"`; solution: remove `ap_fluxunits` when running EllipseModel, let AutoProf use default mag mode
- Updated `parse_autoprof_profile` to auto-detect mag (`SB`) vs intensity (`I`) column format with correct conversions and sentinel filtering (AutoProf marks bad outer isophotes as `SB=99.999`)
- Measured import-only subprocess overhead: ~1.5–2.3s per subprocess call (cold/warm); reported `runtime_s` is timing inside subprocess post-import, so both tools are compared at warmed-up algorithm-only level

### Benchmark script (`benchmarks/performance/bench_vs_autoprof.py`)
- Full benchmark with CLI: `--plots`, `--quick`, `--skip-autoprof`, `--galaxies`
- Runs on 3 real galaxy FITS: IC3370_mock2 (1132×1132 px), eso243-49 (256×256 px, 3-band), ngc3610 (256×256 px, 3-band)
- Both tools receive identical initial conditions (center, ε, PA, background, noise) derived from a preliminary isoster fit
- Builds 4 models per galaxy for residual comparison:
  - `iso_native` — isoster with A3/A4 harmonics
  - `iso_no_harm` — isoster without harmonics (common-reconstruction baseline)
  - `ap_native` — AutoProf EllipseModel FITS (proximity-shell algorithm)
  - `ap_common` — AutoProf 1D profile reconstructed via isoster's inverse-mapping (same algorithm as isoster, no harmonics)
- Generates 18×16" multi-panel QA figure per galaxy:
  - Left column: galaxy image (cyan=isoster, orange=AutoProf isophote overlays) + 4 fractional residual maps with per-zone median |residual%| annotations
  - Right column: SB profile (log, SMA^0.25 x-axis, stop-code colours), ΔI/I (%), ellipticity, PA (degrees, folded), per-zone stats text

### PA wrapping fix
- Replaced `_wrap_pa_profile` (sequential `np.unwrap`) with `_fold_pa_to_reference` — folds each PA value independently to within ±90° of the inner-profile median
- `np.unwrap` fails for noisy outer isophotes (stop code −1) whose PA values are random in [0, π]; the fold is robust because each point is treated independently with no sequential dependency
- Added `ax_pa.set_ylim(pa_ref ± 60°)` to keep all three PA panels readable

### Results summary

| Galaxy | isoster (s) | AutoProf (s) | Speedup | med ΔI/I | med ΔPA |
|---|---|---|---|---|---|
| IC3370_mock2 | 0.23 | 3.08 | **13×** | 0.87% | 0.55° |
| eso243-49    | 0.06 | 3.63 | **56×** | 1.56% | 1.79° |
| ngc3610      | 0.06 | 2.74 | **43×** | 2.88% | 0.28° |
| Mean         | 0.12 | 3.15 | **26×** | — | — |

- Timings are algorithm-only (isoster: warmed JIT; AutoProf: `Process_Image` post-import)
- eso243-49 is edge-on S0 — AutoProf's FFT approach regularises geometry globally and diverges at outer radii (SB drops ~4 orders of magnitude below isoster at large SMA); inner-zone residuals agree well (<3%)
- isoster's A3/A4 harmonics visibly reduce residuals for IC3370 (mock galaxy with boxy component) compared to the no-harmonics baseline

### Markdown report
- Written to `outputs/benchmarks_performance/bench_vs_autoprof/REPORT.md`
- Covers: results table, per-galaxy notes, reconstruction strategy comparison, fairness/methodology notes, reproducibility commands

### Cleanup and merge
- Committed on `feat/bench-vs-autoprof` (SHA `02be748`)
- Merged to `main` with `--no-ff` (merge SHA `e0ff5f4`), branch deleted

## Current State

### Key Issues
- None blocking. Phase 25 is complete.
- AutoProf subprocess imports take ~1.5s per call; a persistent worker subprocess could amortize this for batch runs, but current comparison (algorithm-only timing) is scientifically the most meaningful

### Next Steps
- Phase 25 Section 2 (if planned): deeper AutoProf diagnostics, more galaxy sample, or persistent worker subprocess for end-to-end wall-clock comparison
- Potential: push `main` to remote, update `CITATION.cff`, tag a version

## Lessons Learned
- **AutoProf EllipseModel needs mag mode**: `ap_fluxunits="intensity"` stores profile as `"I_e"` internally, but `EllipseModel` unconditionally reads `"SB_e"`. Removing `ap_fluxunits` makes AutoProf use its default mag representation; the adapter's dual-format parser handles conversion in either case.
- **AutoProf sentinel value**: bad/outer isophotes are marked `SB=99.999` in mag mode. After `10^((zp−SB)/2.5)` this becomes ~10^-30, passing `np.isfinite()` but ruining the log-scale SB profile. Filter with `i_raw < 90.0`.
- **PA folding vs unwrapping**: for profiles with noisy outer isophotes, `np.unwrap(period=π)` fails because sequential discontinuities cascade. Use an independent per-point fold: `delta = ((pa - ref) + π/2) % π − π/2` where `ref` is the inner-profile median. Each point is folded without depending on its neighbours.
- **Subprocess timing placement**: time `Process_Image` *inside* the subprocess after imports to get algorithm-only cost — otherwise you pay ~1.5s Python+NumPy import overhead per call, which inflates AutoProf's measured time unfairly.
- **UpdatePipeline single-line**: embedding a multi-line `UpdatePipeline` call in an f-string causes Python indentation errors in the generated script. Use a single-line form.

---
*Agent: Claude Code (claude-sonnet-4-6) · Session: [paste session ID here]*
