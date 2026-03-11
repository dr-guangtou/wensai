---
date: 2026-02-28
tags:
  - development
  - dev/hsc_photoz
  - dev/frankenz
---
# frankenz — main — 2026-02-28

## Progress

### Phase 01 Stabilization: Complete and Merged

Phase 01 of the frankenz codebase stabilization is finished. All work was committed on the `phase-01/stabilize` branch, merged to `main` (renamed from `master`), and pushed to `origin`.

### Bug Fixes (18/18 review issues resolved)

**Critical/High (5 fixed):**
- P01_001: `simulate.py` `mag_err()` — fixed 3 undefined variable names (`m`→`mag`, `mlim`→`maglim`, `sigmadet`→`sigdet`)
- P01_002: `pdf.py` `loglike()` — fixed silent input array mutation by copying `data`, `data_err`, `data_mask` at function entry
- P01_003: `knn.py` `NearestNeighbors.__init__()` — fixed `feature_map` validation referencing undefined `X_train`/`Xe_train`
- P01_004: `samplers.py` `hierarchical_sampler.reset()` — fixed clearing wrong attributes (`samples_prior`/`samples_counts` → `samples`/`samples_lnp`)
- P01_005: `pdf.py` `pdfs_summarize()` — fixed in-place mutation (`pdfs /= ...` → `pdfs = pdfs / ...`)

**Medium (6 resolved):**
- P01_006: Added `max_iter=100` convergence guard to `_loglike_s()` iterative solver
- P01_007: Replaced all 13 bare `except:` with `except Exception:` across 6 modules
- P01_009: Fixed docstring parameter names in `priors.py` `bpz_pz_tm()` (z/t swap, mbounds/zbounds)
- P01_015: Added `if norm > 0.` guard in `gauss_kde_dict` — the non-dict `gauss_kde` already had this check
- P01_018: Added `warnings.warn()` when `save_fits=True` would allocate >1 GB in BruteForce and NearestNeighbors (4 locations)
- P01_019: Documented single MC data realization as deliberate design trade-off in KNN

**Low (7 resolved):**
- P01_008: Removed duplicate `import warnings` from 10 modules
- P01_010: Removed all Python 2 compatibility (`six`, `__future__`, `iteritems`) from 11 modules
- P01_011: Replaced `from .pdf import *` with explicit imports in `bruteforce.py`, `knn.py`, `networks.py`
- P01_016: Added `warnings.warn()` for non-positive fluxes in `magnitude()`, recommending `luptitude()` instead
- P01_017: Fixed `population_sampler.run_mcmc()` — was passing original `pos_init` instead of resolved `pos` to `sample()`, making resume-from-last-sample logic dead code
- P01_020: Retired `setup.py`, consolidated all metadata into `pyproject.toml` with hatchling build backend
- P01_E01: Fixed `Npoints=5e4` float default to `50000` int for Python 3 `np.linspace`

### Test Suite (70 tests, 11 files)

| File | Tests | Coverage |
|------|-------|----------|
| `test_simulate.py` | 8 | mag_err regression, MockSurvey init |
| `test_pdf_mutation.py` | 5 | loglike + pdfs_summarize mutation regression |
| `test_pdf_math.py` | 11 | _loglike, _loglike_s, loglike wrapper, gaussian |
| `test_pdf_utilities.py` | 10 | magnitude/luptitude roundtrips, PDFDict, KDE |
| `test_knn.py` | 5 | feature_map validation, KNN pipeline |
| `test_bruteforce.py` | 3 | BruteForce fit/predict/GoF |
| `test_samplers.py` | 7 | sampler reset, population_sampler MCMC |
| `test_priors.py` | 9 | pmag, bpz_pt_m, bpz_pz_tm, _bpz_prior |
| `test_reddening.py` | 6 | madau_teff, optical depth components |
| `test_integration.py` | 3 | Full pipeline photo-z correlation |

- Fast tests (`-m "not slow"`): 60 tests in ~1.3s
- Full suite: 70 tests in ~2s

### Documentation

- **`docs/frankenz_usage.md`**: Rewrote to frame frankenz as supervised Bayesian learning (not template fitting). Added real-data workflow example based on frankenz4DESI patterns, training set selection guidelines, updated pitfalls for `free_scale` guidance
- **`docs/frankenz_review.md`**: All 18 issues marked with resolution status. Summary table shows 18/18 resolved
- **`docs/TODO.md`**: All Phase 01 tasks marked done
- **`docs/LESSONS.md`**: Updated with Phase 01 learnings

### Packaging

- Retired `setup.py` in favor of `pyproject.toml` with hatchling build backend
- `uv pip install -e .` confirmed working
- `python_requires >= 3.9`, `six` dependency removed
- Keywords updated: "template fitting" → "supervised learning"
- Project URL, readme, license all properly configured

### Branch Management

- Renamed `master` → `main` (local + remote)
- `phase-01/stabilize` branch merged via `--no-ff` and can be deleted

## Current State

### Key Issues
- None. Clean state on `main`, all tests pass, no uncommitted changes.

### Next Steps
- **P01_014** (optional): Run demo notebooks 1-4 to validate no regressions
- **Phase 02 planning**: Production-ready API — config system (YACS), HDF5 I/O, batch processing, data-driven priors (incorporating frankenz4DESI patterns)
- **Phase 03**: End-to-end HSC pipeline with training/validation/prediction workflow
- Delete local `phase-01/stabilize` branch

## Lessons Learned

- **NumPy augmented assignment (`/=`, `[]=`) is the most dangerous pattern in scientific Python libraries.** Two separate instances in frankenz silently mutated caller data through array aliasing. Always use `a = a / b` instead of `a /= b` when the input should be preserved.
- **`setup.py` → `pyproject.toml` migration is trivial** when there's no custom build logic. Hatchling handles everything, `uv` installs cleanly, and all the metadata (URL, readme, license) that was broken or empty in setup.py gets proper fields.
- **ISSUE-17 (dead code) was actually a real bug**: The `run_mcmc()` resume logic computed a starting position but then passed the original `None` to `sample()`. What looked like harmless dead code was actually broken resume functionality.
- **Chi-squared log-PDF gives `-inf` at chi2=0**: Mathematically correct for dof>2, but means a "perfect match" gets the worst possible score when `dim_prior=True`. Tests must use near-matches, not exact matches.
- **`pmag()` is a galaxy number count prior**: It peaks at the faintest magnitudes in the grid, not at the detection limit. This is correct physics (faint galaxies vastly outnumber bright ones) but counter-intuitive if you expect a detection probability.

---
*Agent: Claude Code (claude-opus-4-6) · Session: c1c184f7-24a8-4d33-b4e8-f9966cd3f6a7*
