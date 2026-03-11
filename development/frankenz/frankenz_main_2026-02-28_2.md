---
date: 2026-02-28
tags:
  - development
  - dev/frankenz
---
# frankenz — Phases 01+02 Complete — 2026-02-28

## Overview

This entry documents the completion of frankenz's modernization across 5 sessions in a single day. The library went from a dormant v0.3.5 research codebase with 5 critical/high bugs and zero tests to a production-ready v0.4.0 with 142 tests, 4 new modules, a 995-line user manual, and 6 updated demo notebooks. All work is committed and merged to `main`.

## Full Development Arc

### Phase 01: Codebase Stabilization (Sessions 1-2)

**Goal**: Fix all bugs, add test coverage, modernize the codebase.

**Bug fixes (5 critical/high + 4 medium)**:
- `simulate.py`: `mag_err()` used undefined variable names (`m`, `mlim`, `sigmadet` instead of `mag`, `maglim`, `sigdet`) — function was completely broken
- `pdf.py`: `loglike()` silently mutated input arrays in place — corrupted caller's data across iterations in the fitting loop
- `knn.py`: Custom `feature_map` validation referenced undefined `X_train`/`Xe_train` — any custom feature map always failed with a misleading error
- `samplers.py`: `hierarchical_sampler.reset()` cleared wrong attributes (`samples_prior`, `samples_counts` instead of `samples`)
- `pdf.py`: `pdfs_summarize()` mutated input PDFs via `/=` operator
- `pdf.py`: `_loglike_s()` had no max iteration guard — potential infinite loop
- All 13 bare `except:` clauses replaced with `except Exception:`
- All duplicate `import warnings` removed across 10 modules
- Docstring parameter errors in `priors.py` corrected

**Code hygiene**:
- Removed all Python 2 compatibility: `from __future__`, `import six`, `from six.moves`
- Replaced 3 wildcard imports (`from .pdf import *`) with explicit imports
- Fixed `Npoints=5e4` float default that broke on Python 3's strict `int` requirement

**Test suite**: 70 tests across 11 files, ~1.7s runtime. Session-scoped `MockSurvey` fixture (SDSS filters, CWW+BPZ templates, 250 objects, seed=42).

**Packaging**: Retired `setup.py` entirely. Migrated to `pyproject.toml` + hatchling. `requires-python = ">=3.9"`.

**Commit**: `ed0971e` on `phase-01/stabilize`, merged at `1ae216f`.

### Phase 02: Production-Ready API (Sessions 2-5)

**Goal**: Add config system, I/O, factories, and batch processing — patterns proven in the frankenz4DESI production wrapper.

#### New Modules

**`config.py`** (169 LOC, 19 tests):
- 8 nested dataclasses: `FrankenzConfig` > `ModelConfig`, `TransformConfig`, `PriorConfig`, `ZGridConfig`, `PDFConfig`, `DataConfig`, `KDTreeConfig`
- `from_dict()` / `to_dict()` / `from_yaml()` / `to_yaml()` / `override()`
- Pure dataclasses + pyyaml — no YACS dependency (unlike frankenz4DESI)
- Recursive `from_dict()` handles nested dataclass construction in ~30 lines

**`transforms.py`** (240 LOC, 12 tests):
- Extracted `magnitude()`, `inv_magnitude()`, `luptitude()`, `inv_luptitude()` from `pdf.py`
- Added `identity()` transform (replaces inline lambda in `knn.py`)
- `get_transform(config)` factory binds `zeropoints`/`skynoise` via `functools.partial`
- Backward-compatible re-exports in `pdf.py` preserve all existing import paths

**`io.py`** (514 LOC, 19 tests):
- `PhotoData` dataclass: `flux`, `flux_err`, `mask`, `redshifts`, `redshift_errs`, `band_names`, `metadata`
- `validate()` method catches shape mismatches early; `subset(indices)` for chunking
- 4 format reader/writer pairs: CSV (column-map), FITS (astropy), HDF5 (h5py), NumPy (.npz)
- `load_data()` / `save_data()` auto-detect format from file extension
- Optional dependencies with lazy imports and helpful `ImportError` messages

**`batch.py`** (150 LOC, 5 tests):
- `run_pipeline(config, training_data, test_data, chunk_size=1000)` — full config-driven pipeline
- `PipelineResult` dataclass: `pdfs`, `zgrid`, `summary`, `config`
- Chunked processing avoids OOM; optional tqdm progress bar
- Backend-specific kwargs handled (KNN vs BruteForce have different `fit_predict` signatures)

#### Factory Functions
- `get_fitter(config, training_data)` in `fitting.py` — creates configured `BruteForce` or `NearestNeighbors`
- `get_prior(config)` in `priors.py` — returns uniform (None) or BPZ prior callable
- 13 tests in `test_factories.py`

#### Integration
- Version bump to 0.4.0 in `__init__.py` + `pyproject.toml`
- `pyyaml` added to required deps; optional extras: `fits`, `hdf5`, `progress`, `all`
- 4 end-to-end tests in `test_pipeline.py`
- **Final: 142 tests pass in ~2.5s**

**Commits**: `d8a9f82` on `phase-02/production-api`, merged at `9f4428f`.

### User Manual (Session 4)

**`docs/frankenz_manual.md`** — 995 lines, 9 sections:
1. What Is Frankenz (algorithm pipeline, fitting backends)
2. Installation (core + optional extras with uv)
3. Input Data (MockSurvey, real data prep, PhotoData, multi-format I/O)
4. Pipeline (direct API, KDE dictionary, two-step, config-driven `run_pipeline`)
5. Configuration Reference (all 8 dataclasses, every field documented, YAML example)
6. Complete Worked Example (mock data to performance metrics)
7. Population and Hierarchical Inference
8. Pitfalls (8 issues: `free_scale`, flux matching, memory, KDE bandwidths, etc.)
9. Module Reference

All code examples tested against live codebase — direct API, config pipeline, and I/O roundtrips all verified working.

### Demo Notebook Updates (Session 5)

Updated all 6 notebooks in `demos/` for v0.4.0:

| Notebook | Changes |
|----------|---------|
| 1 - Mock Data | Replaced `dill` with `pickle`; added `PhotoData`/`save_data`/`load_data` demo section |
| 2 - Photometric Inference | Added config-driven pipeline section (`FrankenzConfig` + `run_pipeline`) with comparison plot vs direct API |
| 3 - Photometric PDFs | Migrated `fz.pdf.luptitude` to `fz.transforms.luptitude` |
| 4 - Posterior Approximations | Added `get_fitter()` factory reference as markdown cell; fixed `logsumexp` import |
| 5 - Population Inference | Removed Python 2 compat imports only |
| 6 - Hierarchical Inference | Removed Python 2 compat imports only |

Common changes across all notebooks:
- Removed `from __future__ import (print_function, division)`
- Removed `from six.moves import range`
- Removed `import dill` where present
- Fixed `scipy.misc.logsumexp` try/except fallback (dead since scipy 1.0)

**Commit**: `b30831b` on `phase-02/demos-and-docs`, merged to `main` (fast-forward).

### Documentation Updates (Session 5)

- `docs/LESSONS.md`: Added Phase 02 design lessons (config vs YACS, re-exports for backward compat, PhotoData container, factory pattern, chunked batch, optional deps) and notebook modernization notes
- `docs/frankenz_review.md`: Bumped version to 0.4.0; marked batch processing (item 5) and FITS/HDF5 I/O (item 6) as done
- `docs/TODO.md`: Added Step 7 with 9 documentation/demo tasks (P02_027-P02_035), all done

## Quantitative Summary

| Metric | Before (v0.3.5) | After (v0.4.0) |
|--------|-----------------|----------------|
| Source modules | 9 | 13 (+config, transforms, io, batch) |
| Source LOC | ~7,500 | ~8,572 |
| Test files | 0 | 17 |
| Test LOC | 0 | ~1,892 |
| Tests | 0 | 142 |
| Test runtime | N/A | ~2.5s |
| Critical/high bugs | 5 | 0 |
| All review issues | 18 open | 18 resolved |
| Python support | 2.7+ (broken) | >=3.9 |
| Packaging | setup.py | pyproject.toml + hatchling |
| Config system | none | 8 dataclasses + YAML |
| Data I/O | none | CSV/FITS/HDF5/NumPy |
| User manual | none | 995 lines |
| Net lines changed | — | +7,988 / -635 across 54 files |

## Current State

### Branch
- `main` — all feature branches merged, working tree clean
- Three merged branches: `phase-01/stabilize`, `phase-02/production-api`, `phase-02/demos-and-docs`

### Key Issues
- No blockers. All work complete.
- Minor: `knn.py:882` RuntimeWarning for very small mock data (N < 100) — edge case, not a bug
- `git branch --unset-upstream` needed — remote `origin/master` was renamed locally to `main`
- No CI/CD pipeline configured yet

### Next Steps
- **Phase 03: HSC Pipeline** — end-to-end pipeline for HSC survey photo-z with training/validation/prediction workflow
- Set up CI/CD (GitHub Actions — tests are fast at ~2.5s)
- Consider PyPI publication (packaging is ready)
- Consider adding parallelization for the per-object fitting loop (currently single-threaded)

## Lessons Learned

### Architecture
- **Dataclasses + pyyaml beats YACS**: Pure dataclasses with recursive `from_dict()` in ~30 lines provide equivalent functionality to YACS with zero extra dependencies and full type annotations.
- **Re-exports preserve backward compat cheaply**: Moving transforms from `pdf.py` to `transforms.py` needed one line (`from .transforms import ...`) in `pdf.py` to prevent all breakage. Tests verify identity.
- **Backend APIs diverge more than expected**: `BruteForce.fit_predict()` and `NearestNeighbors.fit_predict()` accept substantially different kwargs. The batch runner must split common vs backend-specific kwargs. Future refactoring opportunity.
- **Optional dependencies via lazy imports**: Never import `astropy`/`h5py`/`tqdm` at module level. Import inside the function that needs them and raise `ImportError` with a helpful install message.

### Testing
- **Chunk consistency as a correctness check**: Verifying `run_pipeline(chunk_size=5)` gives bit-identical results to `run_pipeline(chunk_size=10000)` catches state leaks, index bugs, and concatenation errors in one assertion.
- **Session-scoped MockSurvey fixture**: One fixture generation (~0.5s) shared across all 142 tests. Critical for keeping the suite fast.

### Notebooks
- **Keep old API alongside new**: Show both direct API and config-driven approaches side-by-side rather than replacing. Users can compare and migrate at their own pace.
- **Preserve pickle chain**: Notebooks 2-4 load pickle files from Notebook 1. Replacing `dill.dump` with `pickle.dump` is safe (standard Python objects), but can't switch to PhotoData-only I/O without breaking the chain.
- **Dead import fallbacks**: `try: from scipy.special import logsumexp; except: from scipy.misc import logsumexp` has been dead code since scipy 1.0. Clean it up without hesitation.

### Process
- **Testing code examples from the manual against the live codebase** caught parameter naming issues early (`model_labels` vs `train_redshifts`).
- **The `free_scale` distinction** (`True` = color-only, `False` = magnitude matching) is the single most important concept for new users and deserves prominent documentation.
- **Mock data with small N** (< 100) can produce degenerate PDFs and RuntimeWarnings — use N >= 250 in examples for realistic behavior.

---
*Agent: Claude Code (claude-opus-4-6) · Session: 673b2f60-d402-4822-8621-9e177a115510*
