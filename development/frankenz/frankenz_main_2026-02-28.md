---
date: 2026-02-28
tags:
  - development
  - dev/frankenz
---
# frankenz — main — 2026-02-28

## Progress
- Updated all 6 demo notebooks in `demos/` for the v0.4.0 API:
  - Notebooks 3, 5, 6: Removed Python 2 compat imports (`__future__`, `six`)
  - Notebook 3: Migrated `fz.pdf.luptitude` to `fz.transforms.luptitude`
  - Notebook 4: Same cleanup + fixed `logsumexp` import + added `get_fitter()` factory reference as markdown cell
  - Notebook 2: Same cleanup + added full config-driven pipeline section (`FrankenzConfig` + `run_pipeline`) with comparison plot vs direct API
  - Notebook 1: Replaced `dill` with `pickle` + added `PhotoData`/`save_data`/`load_data` demo section
- Updated `docs/LESSONS.md` with Phase 02 design lessons (config, PhotoData, factories, chunking, optional deps, notebook strategy)
- Updated `docs/frankenz_review.md` — marked items 5 (batch processing) and 6 (FITS/HDF5 I/O) as done, bumped version to 0.4.0
- Updated `docs/TODO.md` — added Step 7 with 9 documentation/demo tasks (P02_027-P02_035), all done
- Committed on branch `phase-02/demos-and-docs` (b30831b), merged to `main` via fast-forward
- All 142 tests pass in 2.4s
- Phase 02 is now fully complete: code, tests, manual, demos, and docs all committed and merged

## Current State

### Key Issues
- None. All Phase 02 work is complete.
- Minor: `knn.py:882` RuntimeWarning for very small mock data (N < 100) — edge case, not a bug
- `git branch --unset-upstream` needed — remote `origin/master` was renamed locally to `main`

### Next Steps
- Phase 03 (HSC Pipeline) — end-to-end pipeline for HSC survey photo-z with training/validation/prediction workflow
- Consider setting up CI/CD (tests are fast at ~2.5s)
- Consider publishing to PyPI (packaging is ready via `pyproject.toml` + hatchling)

## Lessons Learned
- Keep pickle serialization in Notebook 1 for backward compatibility — notebooks 2-4 load those pickle files, so replacing them with PhotoData-only I/O would break the chain
- Show old and new API side by side rather than replacing — lets users compare and migrate at their own pace
- `scipy.misc.logsumexp` try/except fallback is dead code since scipy 1.0 — just import from `scipy.special` directly
- Re-exports in `pdf.py` for backward compat mean old import paths still work, but demos should use canonical `transforms` module

---
*Agent: Claude Code (claude-opus-4-6) · Session: 673b2f60-d402-4822-8621-9e177a115510*
