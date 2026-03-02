---
date: 2026-02-27
tags:
  - development
  - development/isoster
---

# isoster — feat/bench-vs-autoprof — 2026-02-27

## Progress

- Created Phase 25 benchmark infrastructure to compare isoster against AutoProf (FFT-based isophote fitter) on real galaxy images
- Implemented `benchmarks/utils/autoprof_adapter.py` — subprocess-based AutoProf wrapper that bridges the numpy 2.x / numpy 1.x incompatibility
- Implemented `benchmarks/performance/bench_vs_autoprof.py` — full benchmark script with galaxy registry, parameter estimation, fair-comparison strategy, comparison plots, and CLI interface
- Ran successful benchmarks on 3 galaxies: IC3370_mock2 (Huang2013 mock), eso243-49 (edge-on S0), and ngc3610 (boxy-bulge elliptical)
- Created `docs/plan/phase-25.md` (plan), `docs/lessons-autoprof.md` (lessons), updated `docs/todo.md` with Phase 25 tracing table and results
- Updated `benchmarks/README.md` with AutoProf benchmark commands

## Benchmark Results

### Performance (isoster vs AutoProf)

| Galaxy | isoster | AutoProf | Speedup | med_rel_I | med_eps | med_PA_deg |
|--------|---------|----------|---------|-----------|---------|------------|
| IC3370_mock2 | 0.168s (59 iso) | 2.856s (64 iso) | **17x** | 0.9% | 0.005 | 0.5 |
| eso243-49 | 0.065s (49 iso) | 4.317s (56 iso) | **66x** | 1.2% | 0.038 | 4.5 |
| ngc3610 | 0.064s (49 iso) | 2.609s (56 iso) | **41x** | 3.0% | 0.031 | 0.3 |

- Mean speedup: **33x** across all galaxies (isoster 0.099s vs AutoProf 3.261s)
- Surface brightness profiles agree excellently (sub-1% for the mock galaxy)
- Ellipticity and PA agreement good in the mid-radial range; divergence at large radii expected due to different fitting philosophies (per-isophote vs FFT-regularized)
- IC3370_mock2 had 55/59 stop=0 (converged) with 4 gradient errors at the outer edge
- Both real galaxies achieved 49/49 stop=0 (all converged)

### Profile Agreement Assessment

- **IC3370_mock2**: Excellent SB overlay across full radial range. Ellipticity and PA track closely until ~150px where AutoProf's regularization smooths to constant values while isoster follows local variations
- **eso243-49** (edge-on S0): Good SB agreement to ~100px. AutoProf extends further (to ~190px) due to its FFT regularization handling low-S/N regions. Ellipticity diverges at 30-50px where this edge-on galaxy transitions from round inner to highly elliptical outer isophotes — tools handle this transition differently
- **ngc3610** (boxy elliptical): Excellent SB agreement. At large radii (>50px), isoster PA becomes unstable as ellipticity drops below 0.1 (PA poorly constrained for near-circular isophotes) — expected and documented behavior

## Key Decisions

1. **Subprocess isolation for AutoProf**: AutoProf 1.3.4 has a hard dependency chain: `autoprof → photutils 1.5.0 → numpy <2`. isoster uses numpy 2.3.5. Installing AutoProf into the uv venv immediately downgraded numpy and broke photutils 2.3.0 C extensions. Decision: run AutoProf via subprocess using the system Python (miniforge3, which has AutoProf with numpy 1.26). The adapter spawns a subprocess, runs the pipeline, writes timing to a JSON sidecar, and parses the `.prof` output back in the isoster environment. Configurable via `AUTOPROF_PYTHON` env var.

2. **Fair comparison strategy**: Both tools receive identical initial conditions — same fixed center, ellipticity, PA, background level, and background noise. AutoProf's automatic background/PSF/center pipeline steps are bypassed via `ap_set_*` parameters. This ensures the benchmark measures fitting algorithm differences, not pipeline automation differences.

3. **Multi-band FITS handling**: eso243-49 and ngc3610 are 3-band LegacySurvey cutouts (shape 3×256×256). isoster can handle any 2D array directly, but AutoProf's file reader expects a 2D Primary HDU. Solution: extract band 0 and write a temporary 2D FITS to `output_dir/` for AutoProf's consumption.

4. **Parameter estimation for unknown galaxies**: IC3370_mock2 has known geometry from the existing exhaustive benchmark config. For eso243-49 and ngc3610, the script runs a coarse preliminary isoster fit (astep=0.2, maxit=30) to estimate center, ellipticity, and PA from the median of the middle third of the radial profile. Background is estimated from 50×50 pixel corner regions (median for level, std for noise).

5. **AutoProf Pipeline import path**: The plan document referenced `autoprof.pipeline_steps.Isophote_Fit.Isophote_Pipeline` — this does not exist. The correct import is `autoprof.Pipeline.Isophote_Pipeline`. Discovered during first test run.

6. **AutoProf .prof format**: The plan assumed `ascii.commented_header` format. Actual format is CSV with a commented first line (units) and an uncommented second line (column names: R, I, I_e, ellip, etc.). Fixed to use `ascii.csv` with `comment="#"`.

## Current State

### Files Delivered (uncommitted, on branch `feat/bench-vs-autoprof`)

| File | Lines | Purpose |
|------|-------|---------|
| `benchmarks/utils/autoprof_adapter.py` | 268 | Subprocess AutoProf wrapper + .prof parser |
| `benchmarks/performance/bench_vs_autoprof.py` | ~860 | Main benchmark script with CLI |
| `docs/plan/phase-25.md` | 69 | Phase plan |
| `docs/lessons-autoprof.md` | 94 | AutoProf integration lessons |
| `benchmarks/README.md` | modified | Added AutoProf commands |
| `docs/todo.md` | modified | Phase 25 tracing + results |

### Output Artifacts

All under `outputs/benchmarks_performance/bench_vs_autoprof/`:
- `summary.json`, `summary.csv` — machine-readable results
- `plots/comparison_{galaxy}.png` (×3) — per-galaxy 3-panel overlay (SB, eps, PA)
- `plots/runtime_comparison.png` — side-by-side bar chart
- `autoprof_{galaxy}/` (×3) — raw `.prof`, `.aux`, logs

### Key Issues

- No blockers. All 224 existing tests pass.
- AutoProf cannot be added to `pyproject.toml` due to numpy version conflict — must remain a system-level dependency with subprocess bridge
- The `AUTOPROF_PYTHON` path is hardcoded to `/Users/mac/miniforge3/bin/python3` as default — will need to be adjusted for other machines

### Next Steps

- Commit the branch and request review
- Consider adding isoster-only mode results to a persistent baseline (like the IC3370 exhaustive benchmark)
- Optionally extend to more galaxies if FITS data becomes available
- Consider whether AutoProf comparison should be included in the public README or kept as internal benchmarking

## Lessons Learned

- **AutoProf's numpy 1.x lock-in is a hard blocker for co-installation** — the photutils 1.5.0 dependency has compiled Cython extensions that crash under numpy 2.x. The only clean solution is process-level isolation. This is a common pain point in the astro-Python ecosystem as packages migrate to numpy 2.x at different rates.
- **AutoProf's `.prof` format is not `commented_header`** — despite the `#` on line 1, the column name line (line 2) is not commented. Use `ascii.csv` with `comment="#"` to parse correctly.
- **AutoProf's `Isophote_Pipeline` lives in `autoprof.Pipeline`, not `autoprof.pipeline_steps.Isophote_Fit`** — the module-level `pipeline_steps` subpackage contains individual step implementations, while the orchestrator class is in `Pipeline`.
- **Multi-band FITS files trip up AutoProf** — it reads the primary HDU but doesn't squeeze or select a band. Must write a clean 2D FITS for it.
- **PA convention between tools**: isoster uses radians (math, CCW from +x); AutoProf init uses degrees (astro, CCW from +y). Conversion: `pa_autoprof = degrees(pa_isoster) - 90`. The output `.prof` PA is also in astro convention and needs `radians((pa_deg + 90) % 180)` to convert back.
- **AutoProf produces smoother outer profiles** — its FFT-based global optimization with radial regularization naturally damps noise at large radii, producing flat eps/PA profiles where isoster (per-isophote fitting) shows scatter. Neither is "wrong" — they reflect different fitting philosophies.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
