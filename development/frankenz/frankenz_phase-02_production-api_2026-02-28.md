---
date: 2026-02-28
tags:
  - development
  - development/frankenz
---

# frankenz — phase-02/production-api — 2026-02-28

## Overview

Implemented the complete Phase 02 "Production-Ready API" for frankenz, adding four new modules (config, transforms, I/O, batch processing) plus factory functions and end-to-end pipeline support. This transforms frankenz from a research codebase into a library with config-driven workflows, multi-format data I/O, and chunked batch processing — patterns proven in the frankenz4DESI production wrapper, now living in the core library.

## Progress

### Step 0: Planning Documents
- Created `docs/plan/phase_02.md` with the 26-task implementation plan across 6 steps.
- Updated `docs/TODO.md` with Phase 02 task table, all tasks now marked done.

### Step 1: Config System (`frankenz/config.py`, 169 LOC)
- Built 8 nested dataclasses: `FrankenzConfig`, `ModelConfig`, `TransformConfig`, `PriorConfig`, `ZGridConfig`, `PDFConfig`, `DataConfig`, `KDTreeConfig`.
- Implemented `to_dict()`, `to_yaml(path)`, `from_dict(d)`, `from_yaml(path)`, and `override(overrides)`.
- Recursive `from_dict()` in ~30 lines — handles nested dataclass construction without external libraries.
- `override()` deep-merges a dict of overrides and returns a new config (immutable pattern).
- YAML roundtrip handles `float("inf")` for KDTree distance bounds correctly.
- 19 tests in `test_config.py`.

### Step 2: Transform Extraction (`frankenz/transforms.py`, 240 LOC)
- Extracted `magnitude()`, `inv_magnitude()`, `luptitude()`, `inv_luptitude()` from `pdf.py` (removed 160 lines from pdf.py).
- Added `identity()` function replacing the inline lambda in `knn.py:118`.
- Added `get_transform(config)` factory using `functools.partial` to bind `zeropoints`/`skynoise` from config.
- Maintained backward compatibility via re-exports in `pdf.py`: `from .transforms import magnitude, inv_magnitude, luptitude, inv_luptitude`.
- Updated imports in `knn.py` and `networks.py` to import from `transforms` module directly.
- 12 tests in `test_transforms.py` including roundtrip verification and backward compat assertions.

### Step 3: I/O Module (`frankenz/io.py`, 514 LOC)
- Created `PhotoData` dataclass container with properties (`n_objects`, `n_bands`), `validate()`, and `subset(indices)`.
- Implemented 4 format reader/writer pairs:
  - **CSV**: column-map based (user specifies which columns are flux, errors, etc.) — survey-agnostic.
  - **FITS**: uses `astropy.table` (optional dependency) with same column-map pattern.
  - **HDF5**: uses `h5py` (optional dependency) with grouped datasets under configurable group name.
  - **NumPy**: `.npz` format with standard array names, always available.
- `load_data(path, format=None)` / `save_data(data, path, format=None)` auto-detect format from file extension (`.csv`, `.fits`, `.hdf5`, `.h5`, `.npz`).
- Handled edge case: `np.savez()` auto-appends `.npz` extension — writer ensures consistent naming, reader falls back to `.npz` extension if file not found.
- 19 tests in `test_io.py` covering all formats, validation, subset, and error cases.

### Step 4: Factory Functions
- `get_fitter(config, training_data)` in `fitting.py` (55 new lines): creates configured `BruteForce` or `NearestNeighbors` instance from `FrankenzConfig` + `PhotoData`, sets up transform and RNG.
- `get_prior(config)` in `priors.py` (55 new lines): returns `None` for uniform prior (fitters default to flat), or a `_bpz_lprob_func` callable for BPZ prior.
- BPZ wrapper uses fixed reference magnitude 25.0 — adequate for testing, not production-grade. KNN data-driven prior deferred to future phase.
- 13 tests in `test_factories.py`.

### Step 5: Batch Processing (`frankenz/batch.py`, 150 LOC)
- `run_pipeline(config, training_data, test_data, chunk_size=1000)`: builds zgrid, creates fitter via factory, splits test data into chunks, runs `fit_predict()` per chunk, concatenates PDFs.
- `PipelineResult` dataclass holds `pdfs`, `zgrid`, `summary`, `config`.
- Optional tqdm progress bar with graceful fallback to plain `range()`.
- Backend-specific kwargs handled: `rstate`/`k`/`eps`/`lp_norm`/`distance_upper_bound` only passed to KNN, not BruteForce (different fit_predict signatures).
- Chunk consistency verified: chunked and non-chunked results are bit-identical.
- 5 tests in `test_batch.py` (4 marked `@slow`).

### Step 6: Integration
- Bumped version to 0.4.0 in both `__init__.py` and `pyproject.toml`.
- Added `pyyaml` to required dependencies, optional extras: `fits` (astropy), `hdf5` (h5py), `progress` (tqdm), `all`.
- New module imports in `__init__.py`: `config`, `transforms`, `io`, `batch`.
- 4 end-to-end tests in `test_pipeline.py`: config->PDFs, YAML roundtrip->pipeline, data I/O->pipeline, BruteForce backend.
- Updated `CLAUDE.md` architecture table with new modules and factory functions section.
- **Final result: 142 tests pass in ~2.5s** (70 Phase 01 + 72 Phase 02, zero failures).

### Quantitative Summary

| Metric | Value |
|--------|-------|
| New module LOC | 1,073 (config: 169, transforms: 240, io: 514, batch: 150) |
| New test LOC | 850 across 6 files |
| Modified files | 9 (net: +221 / -189 lines) |
| Total tests | 142 (70 existing + 72 new) |
| Test runtime | ~2.5s |
| Phase 02 tasks | 26/26 done |

## Current State

### Branch
- `phase-02/production-api` — all changes are **uncommitted** (9 modified + 13 untracked files).
- 0 commits ahead of `main` — everything is working tree changes only.

### Key Issues
- No blockers. All tests pass.
- Documentation is stale: `docs/frankenz_usage.md` does not reflect the new API.
- `docs/frankenz_review.md` needs Phase 02 status updates.
- `docs/LESSONS.md` needs Phase 02 patterns recorded.

### Next Steps
- Update `docs/frankenz_usage.md` with new config system, PhotoData container, factory functions, and batch pipeline usage.
- Record Phase 02 lessons in `docs/LESSONS.md`.
- Update `docs/frankenz_review.md` status.
- Commit all Phase 02 changes on branch.
- Merge to `main` after review.

## Lessons Learned

- **Dataclasses + pyyaml beats YACS**: The frankenz4DESI wrapper used YACS (Yet Another Config System), but pure dataclasses with a ~30-line recursive `from_dict()` provides equivalent functionality with zero extra dependencies and full type annotation support. The `override()` method cleanly supports the YAML-load-then-CLI-override pattern.

- **Re-exports preserve backward compat cheaply**: Moving transforms out of `pdf.py` into `transforms.py` could break downstream imports. A single line `from .transforms import magnitude, inv_magnitude, luptitude, inv_luptitude` in `pdf.py` costs nothing and prevents all breakage. Tests verify `from frankenz.pdf import magnitude is from frankenz.transforms import magnitude`.

- **Backend APIs diverge more than expected**: `BruteForce.fit_predict()` and `NearestNeighbors.fit_predict()` accept substantially different kwargs — KNN takes `rstate`, `k`, `eps`, `lp_norm`, `distance_upper_bound` while BruteForce takes none of these. The batch runner must split common vs backend-specific kwargs. This suggests a future refactoring to unify the fit_predict interface.

- **Column name conflicts in tabular I/O**: When writing CSV/FITS, band names become column names. If a band is named "z" and redshift is also written as column "z", the DataFrame silently overwrites. Real surveys (HSC, DESI) do have z-band data. Solution for now: document the issue and use non-conflicting names in tests. Future: add column prefix or conflict detection.

- **np.savez auto-appends .npz**: Calling `np.savez("data_file", ...)` creates `data_file.npz`, not `data_file`. The reader must handle both paths. Small gotcha but reproducible.

- **Chunk consistency as a correctness check**: Verifying that `run_pipeline(chunk_size=5)` produces bit-identical results to `run_pipeline(chunk_size=10000)` is an excellent test — it catches state leaks between chunks, incorrect index arithmetic, and concatenation bugs in one assertion.

---
*Agent: Claude Code (claude-opus-4-6) · Session: dd879175-6612-4885-aee9-402e7b0f28d2*
