---
date: 2026-03-13
tags:
  - development
  - development/isoster
---

# isoster — feat/comparison-qa-refactor — 2026-03-13

## Progress

- Merged `feat/comparison-qa-refactor` into `main` (3 branch commits + merge commit `a7e27e7`)
- **AutoProf harmonic measurement enabled**: added `ap_iso_measurecoefs=(3,4)` to default options in `run_autoprof_fit()`, parsing a3/b3/a4/b4 columns from `.prof` output, persisting in ECSV
- **Eccentric anomaly sampling for isoster**: set `use_eccentric_anomaly=True` in benchmark config to match AutoProf's native EA sampling for fair comparison (isoster defaults to PA sampling; AutoProf always uses EA via `arctan((1-eps)*tan(E))` transform)
- **Auto-computed maxsma from image diagonal**: removed hardcoded `maxsma` from all 3 galaxy registry entries; now computed as `0.95 * half_diagonal` at runtime. New values: eso243-49 171px (was 118), IC3370_mock2 761px (was 283), ngc3610 171px (was 118)
- **LSB-tuned isoster defaults for benchmarks**: `integrator='adaptive'` with `lsb_sma_threshold=80.0` (switches to median in outskirts), `permissive_geometry=True` (continues through weak diagnostics)
- **Retry mechanism for all 3 methods**: max 3 attempts per method; on retry, geometry is perturbed (eps +/-0.02, pa +/-0.05 rad), `maxit` increased (100/200), `maxgerr` relaxed (0.8/1.2). Retry count threaded to QA figures (`"photutils: 2.24s; retry: 1"`) and report tables (new Retries column)
- **Multi-mode QA figures**: benchmark now generates all 3 layout modes per galaxy (solo, 1v1, 3-way) — 9 figures total across 3 galaxies
- **Bug fix**: `build_photutils_config()` was hardcoding `maxgerr=0.5` instead of reading from `config_overrides`, so retry escalation never reached photutils. This caused ngc3610 photutils to fail all 3 retries before the fix
- **Cosmetic refinements committed** (from prior session): scale bars replacing axis labels, runtime stats in SB panel, mode-aware legend, robust centroid reference for center offset panel, AutoProf center extraction from `.aux` files

## Current State

### Benchmark Results (final run)

| Galaxy | isoster | photutils | AutoProf |
|--------|---------|-----------|----------|
| eso243-49 | 54 iso, 0.07s, retry:1 | 54 iso, 1.74s | 56 iso, 7.09s |
| IC3370_mock2 | 69 iso, 0.15s | 69 iso, 4.90s | 62 iso, 3.67s |
| ngc3610 | 54 iso, 0.09s | 54 iso, 2.33s, retry:1 | 53 iso, 10.04s |

- 223 tests passing (full suite, excluding 3 parked-branch test files)
- Branch merged to `main`, local only (not pushed)
- Parked `feat/gradient-free-fallback` untracked files still in working tree

### Key Issues

- **eso243-49 isoster retry**: first attempt returns 0 isophotes with new EA+LSB config; succeeds on retry 1 with perturbed geometry. Root cause not yet investigated — may be EA sampling shifting convergence behavior at the starting SMA
- **IC3370_mock2 outskirt stop codes**: isoster has 8 gradient failures (-1) in outer isophotes; photutils has 18 stop=2 (max iterations) and 14 stop=4/5. The expanded maxsma (761px) pushes deep into noise
- **Parked branch cleanup**: untracked files from `feat/gradient-free-fallback` still in working tree (`.superset/`, gradient-free docs, test files)

### Next Steps

- Push `main` to origin when ready
- Investigate eso243-49 first-attempt failure with EA sampling
- Consider capping maxsma for IC3370_mock2 if the deep-outskirt stop codes are problematic
- Clean up parked `feat/gradient-free-fallback` untracked files or stash them

## Lessons Learned

- **Config passthrough matters**: `build_photutils_config` silently hardcoding `maxgerr=0.5` instead of reading from overrides meant retry escalation was invisible to photutils. Always pass configurable parameters through, even if you start with a sensible default.
- **EA vs PA sampling**: AutoProf uses eccentric anomaly sampling (denser near semi-minor axis), isoster defaults to position angle (uniform polar). This is a non-trivial difference for high-ellipticity galaxies and should be documented as a comparison caveat.
- **Auto maxsma is better than hardcoded**: Half-diagonal with 5% margin is a good heuristic. The old hardcoded values (118px for 256x256 images) were too conservative and caused early stopping well before the image edge.
- **Retry mechanism works**: Both eso243-49 (isoster) and ngc3610 (photutils) needed retries — the mechanism caught real failures and recovered with relaxed parameters.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
