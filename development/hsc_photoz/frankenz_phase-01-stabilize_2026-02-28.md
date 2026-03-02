---
date: 2026-02-28
tags:
  - development
  - development/hsc_photoz
  - frankenz
  - phase-01
---

# frankenz — phase-01/stabilize — 2026-02-28

## Progress

### Critical Bug Fixes (5 bugs)

- **P01_001 `simulate.py` `mag_err()`**: Fixed three undefined variable names in the magnitude error function. The parameters `m`, `mlim`, `sigmadet` were referenced in the function body but the actual parameter names were `mag`, `maglim`, `sigdet`. This function was completely broken — any call would raise `NameError`.

- **P01_002 `pdf.py` `loglike()`**: Fixed silent input array mutation. The "safety check" cleaning step (`data[~clean] = 0.`) modified the caller's arrays in place due to numpy's pass-by-reference semantics. Fix: copy all three input arrays (`data`, `data_err`, `data_mask`) with `np.array()` at function entry before any modification.

- **P01_003 `knn.py` `NearestNeighbors.__init__()`**: Fixed custom `feature_map` validation that referenced undefined `X_train` and `Xe_train` variables (likely leftover from a refactor). Replaced with `self.models` and `self.models_err`. Also changed the bare `except:` to `except Exception:`.

- **P01_004 `samplers.py` `hierarchical_sampler.reset()`**: The reset method was clearing three attributes that don't exist in `__init__` (`samples_prior`, `samples_lnp`, `samples_counts`) instead of the two that do (`samples`, `samples_lnp`). This meant calling `reset()` would create spurious attributes while leaving the actual sample accumulator untouched.

- **P01_005 `pdf.py` `pdfs_summarize()`**: Fixed in-place mutation of input PDFs during normalization. Changed `pdfs /= pdfs.sum(axis=1)[:, None]` to `pdfs = pdfs / pdfs.sum(axis=1)[:, None]`. The augmented assignment modifies the original array; the regular division creates a new array.

### Medium-Severity Fixes (4 issues)

- **P01_006**: Added `max_iter=100` convergence guard to the iterative scale-factor solver `_loglike_s()`. The original `while lerr > ltol:` loop had no escape hatch and could spin indefinitely with pathological inputs.

- **P01_007**: Replaced all 13 bare `except:` clauses across the codebase with `except Exception:`. Bare except catches `KeyboardInterrupt` and `SystemExit`, preventing clean interruption. Affected files: `pdf.py`, `knn.py`, `samplers.py` (2), `simulate.py` (7), `networks.py` (2), `plotting.py`.

- **P01_008**: Removed duplicate `import warnings` statements from all 10 modules. Each module had `import warnings` appearing twice in the import block.

- **P01_009**: Fixed docstring parameter names in `priors.py` `bpz_pz_tm()`. The parameter `z` (redshift) was documented as `t` (type), and `zbounds` was documented as `mbounds`. Two separate copy-paste errors in the docstring.

### Code Hygiene (Python 2 removal + cleanup)

- **P01_010**: Removed all Python 2 compatibility code from every module:
  - Deleted `from __future__ import (print_function, division)` from 11 files
  - Deleted `import six` / `from six.moves import range` / `from six import iteritems` from 11 files
  - Replaced `iteritems(dict)` with `dict.items()` in `networks.py` (3 occurrences)
  - Removed `six` from `setup.py` dependencies
  - Updated `setup.py` classifiers from Python 2.7/3.6 to Python 3.9/3.10/3.11/3.12
  - Added `python_requires=">=3.9"` to `setup.py`

- **P01_011**: Replaced `from .pdf import *` with explicit imports in 3 modules:
  - `bruteforce.py`: `from .pdf import (logprob, gauss_kde, gauss_kde_dict)`
  - `knn.py`: `from .pdf import (logprob, magnitude, luptitude, gauss_kde, gauss_kde_dict)`
  - `networks.py`: `from .pdf import (logprob, magnitude, luptitude, gauss_kde, gauss_kde_dict)`

### Extra Fix: Python 3 Compatibility

- **P01_E01**: Fixed `Npoints=5e4` float default in `MockSurvey.load_survey()`. Python 3's `np.linspace` requires integer `num` parameter. Changed to `Npoints=50000`.

### Test Suite (70 tests, 11 files)

Created a comprehensive test suite from scratch:

| Test File | Tests | Coverage |
|-----------|-------|----------|
| `test_simulate.py` | 8 | mag_err bug regression, MockSurvey initialization |
| `test_pdf_mutation.py` | 5 | loglike + pdfs_summarize mutation regression |
| `test_pdf_math.py` | 11 | _loglike, _loglike_s, loglike wrapper, gaussian |
| `test_pdf_utilities.py` | 10 | magnitude/luptitude roundtrips, PDFDict, KDE, pdfs_summarize |
| `test_knn.py` | 5 | feature_map validation bug, KNN pipeline |
| `test_bruteforce.py` | 3 | BruteForce fit/predict/GoF |
| `test_samplers.py` | 7 | hierarchical_sampler.reset bug, population_sampler |
| `test_priors.py` | 9 | pmag, bpz_pt_m, bpz_pz_tm, _bpz_prior |
| `test_reddening.py` | 6 | madau_teff, optical depth components |
| `test_integration.py` | 3 | Full pipeline photo-z correlation, pdfs_summarize pipeline |
| `conftest.py` | — | Session-scoped MockSurvey fixture (SDSS/CWW+/BPZ, 250 objects) |

- **Fast tests** (`-m "not slow"`): 60 tests, ~1.3s
- **Full suite**: 70 tests, ~1.7s
- Markers: `slow`, `mutation`, `regression`

## Current State

### Verification Checklist (all pass)
1. `pytest -v` — 70 tests pass
2. `pytest -m mutation -v` — 5 mutation regression tests pass
3. `grep -rn 'except:' frankenz/` — zero bare except clauses
4. `grep -rn 'import six' frankenz/` — zero six imports
5. `grep -rn 'import \*' frankenz/` — zero wildcard imports

### Changes Not Yet Committed
- 12 source files modified (44 insertions, 90 deletions net)
- 13 new files created (tests/, pyproject.toml)

### Key Issues
- Changes are on `phase-01/stabilize` branch, **not yet committed or merged**
- Documentation updates (P01_012, P01_013) deferred to Phase 02
- Demo notebook validation (P01_014) deferred — requires manual inspection

### Next Steps
- Commit all changes on `phase-01/stabilize`
- Run demo notebooks 1-4 to verify nothing broke
- Update `docs/frankenz_usage.md` to reframe as supervised learning (not template fitting)
- Update `docs/frankenz_review.md` to mark fixed bugs with status
- Begin Phase 02 planning: config system, HDF5 I/O, batch processing

## Lessons Learned

- **NumPy augmented assignment (`/=`, `[]=`) is dangerous in library code**: It silently mutates caller data through array aliasing. Always use regular operators (`= ... /`) or explicit `np.copy()` when the input should be preserved. Two separate instances of this pattern existed in frankenz.
- **Python 2→3 migration catches**: Beyond obvious `six`/`__future__` removal, watch for `5e4` float literals used as integer arguments (breaks with strict typing in numpy/scipy), and `dict.iteritems()` references hidden behind six imports.
- **Bare `except:` is insidious**: 13 instances across the codebase, many in I/O paths. They catch `KeyboardInterrupt` making debugging impossible during long-running photometry generation.
- **The chi2 distribution log-PDF gives `-inf` at chi2=0**: This is mathematically correct (the mode of chi2 with k>2 dof is at k-2, not 0), but means a "perfect match" in `_loglike()` with `dim_prior=True` gets the worst possible score. Tests must use near-matches, not exact matches.
- **`pmag()` is a galaxy number count prior, not a detection probability**: It peaks at the faintest magnitudes in the grid, reflecting that faint galaxies vastly outnumber bright ones. The exponential cutoff near `maglim` provides the faint-end turnover.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
