---
date: 2026-04-02
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — feature/autoprof-benchmark — 2026-04-02

## Progress

- **Designed and implemented full AutoProf benchmark pipeline (Step 4d)**, mirroring the photutils benchmark (Step 4a) two-phase pattern: Phase 1 (fitting) + Phase 2 (analysis + QA).
- **Subprocess isolation architecture**: AutoProf v1.3.4 pins `photutils<=1.5.0`, conflicting with the project's modern stack. Solved by running AutoProf in an isolated venv (`/tmp/autoprof_venv`) via subprocess. The orchestrator (`fit_autoprof.py`) runs in the main env, dispatches per-galaxy JSON options to `autoprof_worker.py` in the venv, then parses `.prof`/`.aux`/`_genmodel.fits` outputs.
- **5 benchmark configs run on 96 demo galaxies** (478 profiles, 478 models):
  - `baseline` (95/96): clip + median, default regularization
  - `no_clip` (95/96): no sigma clipping
  - `deep` (96/96): fit_limit=1.0, geometric_scale=0.05, early interpolation — **produces 2x more isophotes** (median 104 vs 53), confirming AutoProf's depth advantage
  - `fixed_sga_center` (96/96): center locked to SGA Tractor position via `ap_set_center`
  - `high_regularization` (95/96): regularization_scale=2.0, fewer PA instability flags
- **QA figures generated** for all configs (493 per-galaxy + 15 summary figures), following isoster/Huang2013 campaign style with tool-agnostic `plot_galaxy_qa(tool="autoprof")`.
- **Column mapping**: AutoProf `.prof` output (R in arcsec, SB in mag/arcsec^2, PA in astronomical convention) converted to standardized FITS profile matching photutils schema (sma in pixels, intens in nanomaggies/pixel, PA in math convention radians).

## Bug Fixes

- **WFIT header missing**: QA titles showed "0.0s" wall time because `convert_profile_to_fits()` never wrote the `WFIT` FITS header keyword. Fixed by passing `wall_time` from the subprocess status JSON through to the header.
- **Isophote overflow in QA panels**: Large outer isophotes (especially `deep` config) extended beyond the image boundary, expanding the axes. Fixed by locking axis limits after adding ellipse patches: `ax.set_xlim(-0.5, nx-0.5); ax.set_ylim(-0.5, ny-0.5)`. Recorded as a guideline in `LESSONS.md` for all future isophotal QA.
- **Config rename**: `fixed_geometry` was a misnomer — `ap_isoinit_pa_set`/`ap_isoinit_ellip_set` only seed initialization, the FFT fitter still varies PA/eps per isophote. Renamed to `sga_init`, then replaced with `fixed_sga_center` which only locks the center (the scientifically useful test).

## Key Findings

- **AutoProf `deep` config** confirms the claimed ~2 mag/arcsec^2 depth advantage: SB profiles extend to ~32 mag/arcsec^2 vs ~28 for baseline, with 2x finer radial sampling (104 vs 53 median isophotes).
- **AutoProf has no fix_pa/fix_eps**: Unlike photutils, AutoProf's FFT fitter always varies geometry per isophote. Only the center can be truly fixed via `ap_set_center`.
- **Residual dipole investigation**: Some galaxies show a minor-axis dipole in AutoProf model residuals. Traced to AutoProf's single global center vs the true per-radius photocenter variation. Not universal — varies with galaxy morphology and center offset magnitude. Accepted as intrinsic to AutoProf's approach.

## Current State

### Files Created
- `config/autoprof_benchmark.yaml` — 5 benchmark configs
- `scripts/autoprof_worker.py` — subprocess worker (runs in venv)
- `scripts/autoprof_fitter.py` — config, parsing, column conversion, inventory
- `scripts/fit_autoprof.py` — Phase 1 CLI orchestrator
- `scripts/analyze_autoprof.py` — Phase 2: metrics, flags, QA
- `docs/plan/step4d_autoprof_benchmark.md` — implementation plan

### Files Modified
- `scripts/photutils_plots.py` — added `tool` parameter, isophote clipping
- `docs/todo.md` — Step 4d marked done
- `docs/LESSONS.md` — AutoProf-specific lessons

### Output (not git tracked)
- `output/autoprof/{baseline,no_clip,deep,fixed_sga_center,high_regularization}/` — each with profiles/, models/, qa/, summary/, inventory.fits, report.md

### Key Issues
- Work is uncommitted on `feature/autoprof-benchmark` branch
- `sga_init` output dir remains (old `fixed_geometry` renamed); can be cleaned up

### Next Steps
- Commit and merge `feature/autoprof-benchmark`
- Step 4e: isoster benchmark (the project's own algorithm)
- Step 4f: cross-tool comparison (photutils vs AutoProf vs isoster vs SGA reference)

## Lessons Learned
- **Isophote clipping is a universal QA guideline**: Always lock axes to image extent when overlaying isophote ellipses. Applies to all tools, not just AutoProf.
- **AutoProf venv is volatile at `/tmp`**: Must auto-create if missing. The `ensure_venv()` function handles this transparently.
- **PA convention verified in AutoProf source**: `WriteProf.py` applies `PA_shift_convention` once before writing (math→astro), then reverts for internal state. The `.prof` file PA is in astronomical convention (CCW from +y, degrees).
- **AutoProf `.prof` parsing**: Two header lines — line 0 is a `# units...` comment, line 1 is column names. Use `np.genfromtxt(skip_header=1, names=True)`.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
