---
title: "Frankenz Code Review"
date: 2026-02-27
version: 0.3.5
reviewer: Song Huang (with Claude Code)
tags:
  - frankenz
  - code-review
  - bugs
  - photo-z
status: actionable
severity_levels:
  - CRITICAL (will crash or produce silently wrong results)
  - HIGH (likely to cause issues in production use)
  - MEDIUM (correctness or usability issue under specific conditions)
  - LOW (cosmetic, style, or minor maintainability)
---

# Frankenz Code Review

## Summary

| Category | Count |
|----------|-------|
| Critical bugs | 2 |
| High severity | 3 |
| Medium severity | 6 |
| Low severity | 7 |
| **Total** | **18** |

---

## Critical Bugs

### BUG-01: `mag_err()` uses undefined variable names [CRITICAL]

**File**: `frankenz/simulate.py:86-90`

The function signature defines parameters `mag`, `maglim`, `sigdet`, but the function body uses the undefined names `m`, `mlim`, `sigmadet`. Calling this function will raise `NameError`.

```python
# simulate.py:54 - function signature
def mag_err(mag, maglim, sigdet=5., params=(4.56, 1., 1.)):

# simulate.py:86-90 - body uses wrong names
F = 10**(-0.4 * (m - 22.5))            # NameError: 'm' undefined, should be 'mag'
Flim = 10**(-0.4 * (mlim - 22.5))      # NameError: 'mlim' undefined, should be 'maglim'
Fnoise = (Flim / sigmadet)**2 * k * teff - Flim  # NameError: 'sigmadet' undefined, should be 'sigdet'
```

**Impact**: Function is completely broken. Not called elsewhere in the library, but exported in `__all__` (`simulate.py:22`) and would crash any user code that calls it.

**Fix**: Replace `m` with `mag`, `mlim` with `maglim`, `sigmadet` with `sigdet`.

---

### BUG-02: `loglike()` silently mutates input arrays in place [CRITICAL]

**File**: `frankenz/pdf.py:309-311`

```python
# pdf.py:309-311
clean = np.isfinite(data) & np.isfinite(data_err) & (data_err > 0.)
data[~clean], data_err[~clean], data_mask[~clean] = 0., 1., False
```

The function directly modifies the caller's `data`, `data_err`, and `data_mask` arrays. Since numpy arrays are passed by reference, the caller's original data is permanently corrupted.

**Impact**: HIGH. In any workflow that calls `loglike()` multiple times (e.g., the per-object loop in `BruteForce._fit()` at `bruteforce.py:192-193` or `NearestNeighbors._fit()` at `knn.py:355`), data from previous iterations is silently corrupted. This can produce subtly wrong likelihoods. The issue is particularly dangerous because `loglike()` is called once per object inside the fitting loop, so the data array is modified N_obj times.

**Affected call chain**:
- `BruteForce._fit()` (`bruteforce.py:193`) -> `logprob()` (`pdf.py:398`) -> `loglike()` (`pdf.py:309`)
- `NearestNeighbors._fit()` (`knn.py:375`) -> `logprob()` -> `loglike()`
- All network-based fitters follow the same path

**Fix**: Operate on copies at the start of `loglike()`:
```python
data = np.array(data, copy=True)
data_err = np.array(data_err, copy=True)
data_mask = np.array(data_mask, copy=True)
```

**Note**: In practice, the corruption may be benign for most objects because `loglike` is called per-object (1D `data` sliced from the 2D array), and the cleaning step only zeroes out already-invalid values. However, the `data_mask[~clean] = False` line is the real danger: it permanently disables mask bits on the shared array. If a band has `NaN` error for one reason in one iteration, subsequent iterations will see that band as permanently masked.

---

## High Severity Bugs

### BUG-03: Custom `feature_map` validation references undefined variables [HIGH]

**File**: `frankenz/knn.py:134-136`

```python
# knn.py:131-139
else:
    try:
        # Check if `feature_map` is a valid function.
        _ = feature_map(np.atleast_2d(X_train[0]),    # NameError: 'X_train' not defined
                        np.atleast_2d(Xe_train[0]),   # NameError: 'Xe_train' not defined
                        *fmap_args, **fmap_kwargs)
    except:
        # If all else fails, raise an exception.
        raise ValueError("The provided feature map is not valid.")
```

**Impact**: Passing any custom function as `feature_map` to `NearestNeighbors.__init__()` will always crash with `NameError`, which is then caught by the bare `except:` and re-raised as a misleading `ValueError("The provided feature map is not valid.")`.

**Fix**: Replace `X_train[0]` and `Xe_train[0]` with `self.models[0]` and `self.models_err[0]`. Also replace bare `except:` with `except Exception:`.

---

### BUG-04: `hierarchical_sampler.reset()` resets wrong attributes [HIGH]

**File**: `frankenz/samplers.py:336-341`

```python
# samplers.py:331-334 - __init__ creates these attributes
self.pdfs = pdfs
self.samples = []
self.samples_lnp = []

# samplers.py:336-341 - reset() modifies DIFFERENT attributes
def reset(self):
    self.samples_prior = []    # NOT in __init__! Should be 'self.samples'
    self.samples_lnp = []      # OK
    self.samples_counts = []   # NOT in __init__! Spurious attribute
```

**Impact**: Calling `reset()` does NOT clear `self.samples`. The sampler retains all previous samples. Additionally, it creates two new attributes (`samples_prior`, `samples_counts`) that are never read by any other method.

**Fix**: Change to:
```python
def reset(self):
    self.samples = []
    self.samples_lnp = []
```

---

### BUG-05: `pdfs_summarize()` mutates input PDFs in place [HIGH]

**File**: `frankenz/pdf.py:984`

```python
# pdf.py:983-984
if renormalize:
    pdfs /= pdfs.sum(axis=1)[:, None]  # in-place modification via /=
```

**Impact**: The caller's PDF array is permanently modified. If `pdfs_summarize()` is called multiple times or if the PDFs are needed elsewhere, the data is silently changed.

**Fix**: Use `pdfs = pdfs / pdfs.sum(axis=1)[:, None]` (create new array) instead of `/=`.

---

## Medium Severity Issues

### ISSUE-06: `_loglike_s()` iterative convergence has no maximum iteration limit [MEDIUM]

**File**: `frankenz/pdf.py:198-223`

```python
# pdf.py:198-199
lerr = np.inf
while lerr > ltol:
    # ... iteratively update scale factor ...
    lerr = max(abs(loglike_err))
```

**Impact**: If the iterative scale-factor optimization does not converge (possible with degenerate data/model combinations, e.g., all-zero models or zero-variance data), this becomes an infinite loop.

**Fix**: Add a maximum iteration count:
```python
max_iter = 100
n_iter = 0
while lerr > ltol and n_iter < max_iter:
    n_iter += 1
    ...
if n_iter >= max_iter:
    warnings.warn("Scale factor optimization did not converge.")
```

---

### ISSUE-07: Documentation errors in `priors.py` [MEDIUM]

**File**: `frankenz/priors.py:188-203`

```python
# priors.py:188-195 - parameter names are wrong
def bpz_pz_tm(z, t, m, ...):
    """
    Parameters
    ----------
    t : float          # Should be 'z : float'
        Redshift.

    t : int            # Should be 't : int'
        Type.
```

```python
# priors.py:199-203 - parameter name duplicated
    mbounds : tuple of shape (2,), optional
        Magnitude lower/upper bounds.

    mbounds : tuple of shape (2,), optional     # Should be 'zbounds'
        Redshift lower/upper bounds.
```

**Impact**: Users reading the docstring get incorrect parameter documentation. The function signature is correct (`z, t, m`) but the docstring contradicts it.

---

### ISSUE-08: Memory scaling makes `BruteForce`/`NearestNeighbors` impractical for large surveys [MEDIUM]

**Files**:
- `frankenz/bruteforce.py:182-189` (BruteForce pre-allocates full arrays)
- `frankenz/knn.py:342-352` (NearestNeighbors pre-allocates full arrays)

```python
# bruteforce.py:182-189 - allocates (N_data, N_model) arrays
self.fit_lnprior = np.zeros((Ndata, Nmodels), dtype='float')
self.fit_lnlike = np.zeros((Ndata, Nmodels), dtype='float')
self.fit_lnprob = np.zeros((Ndata, Nmodels), dtype='float')
self.fit_Ndim = np.zeros((Ndata, Nmodels), dtype='int')
self.fit_chi2 = np.zeros((Ndata, Nmodels), dtype='float')
self.fit_scale = np.ones((Ndata, Nmodels), dtype='float')
self.fit_scale_err = np.zeros((Ndata, Nmodels), dtype='float')
```

**Impact**: For `BruteForce` with N_data=10^6 and N_model=10^5, the 7 arrays above require ~5.2 TB of RAM. Even for `NearestNeighbors` with K*k=500 effective models per object, this is ~26 GB for 10^6 objects. Setting `save_fits=False` avoids this but loses fit diagnostics.

**Mitigation**: Use `fit_predict()` with `save_fits=False` for large runs, or process data in batches.

---

### ISSUE-09: Bare `except:` clauses suppress all exceptions [MEDIUM]

**Files**:
- `frankenz/knn.py:137` - `except:` catches everything including KeyboardInterrupt
- `frankenz/pdf.py:1022` - `except:` in kernel validation
- `frankenz/samplers.py:176` - `except:` in position initialization

**Impact**: Makes debugging extremely difficult. `KeyboardInterrupt` and `SystemExit` are caught and suppressed.

**Fix**: Change all `except:` to `except Exception:`.

---

### ISSUE-10: KNN single Monte Carlo realization for neighbor search [MEDIUM]

**File**: `frankenz/knn.py:358`

```python
# knn.py:358 - only ONE MC draw of the data per object
x_t = rstate.normal(x, xe)  # single MC realization
```

While K=25 Monte Carlo realizations are used for the **models** (via K separate KDTrees), only a **single** MC realization is drawn for each observed object. This means the neighbor set for each object depends on a single noise realization of the data, which may not adequately represent the data uncertainty.

**Impact**: For low-S/N objects, the selected neighbor set may be non-representative. The K model trees help but don't fully compensate.

**Context**: This is likely a deliberate design trade-off for speed, but it's worth noting for users with noisy data.

---

### ISSUE-11: `gauss_kde_dict` edge case when `hpad = 0` and `lpad = 0` [MEDIUM]

**File**: `frankenz/pdf.py:614-617`

```python
# pdf.py:614-617
if lpad == 0:
    norm = kcdf[hpad-1]       # when hpad=0: kcdf[-1] = total CDF (correct)
else:
    norm = kcdf[hpad-1] - kcdf[lpad-1]
```

When `hpad = 0` and `lpad = 0`, `norm = kcdf[-1]` which is the total CDF -- this is correct. However, if `norm` evaluates to `0` (degenerate kernel), the subsequent division `y_wt[i] / norm * kernel[...]` at line 620 produces `inf` or `NaN`.

**Fix**: Add a zero-check:
```python
if norm > 0.:
    pdf[low:high] += (y_wt[i] / norm) * kernel[lpad:2*width+1+hpad]
```

---

## Low Severity Issues

### ISSUE-12: Python 2 compatibility overhead [LOW]

**All source files**

Every module includes:
```python
from __future__ import (print_function, division)
import six
from six.moves import range
```

Python 2.7 reached EOL on 2020-01-01. `setup.py:45` lists Python 2.7 and 3.6 as supported versions. The `six` dependency adds unnecessary complexity.

**Fix**: Remove all `six` usage, `__future__` imports, and update `setup.py` to require Python >= 3.8.

---

### ISSUE-13: Wildcard imports pollute namespace [LOW]

**Files**:
- `frankenz/bruteforce.py:20` - `from .pdf import *`
- `frankenz/knn.py:23` - `from .pdf import *`
- `frankenz/networks.py:26` - `from .pdf import *`

**Impact**: Makes it hard to trace where functions are defined. All of `pdf.__all__` (14 names) are injected into each module's namespace.

**Fix**: Use explicit imports: `from .pdf import logprob, gauss_kde, gauss_kde_dict, PDFDict, magnitude, luptitude`

---

### ISSUE-14: Duplicate `import warnings` in all modules [LOW]

**Files**:
- `frankenz/pdf.py:16,17`
- `frankenz/simulate.py:16,17`
- `frankenz/knn.py:17,19`
- `frankenz/bruteforce.py:16,17`
- `frankenz/networks.py:17,19`
- `frankenz/samplers.py:16,17`

Every module imports `warnings` twice. Harmless but sloppy.

---

### ISSUE-15: No handling of negative fluxes in `magnitude()` [LOW]

**File**: `frankenz/pdf.py:652`

```python
# pdf.py:652
mag = -2.5 * np.log10(phot / zeropoints)
```

Negative fluxes (physically possible in background-subtracted photometry) produce `NaN` from `log10`. The `luptitude()` function handles this correctly via `arcsinh`, but `magnitude()` does not warn or handle it.

**Impact**: Low if users use `luptitude` (the default feature map), but can cause silent NaN propagation if `magnitude` is chosen.

---

### ISSUE-16: No formal test suite [LOW]

**Impact**: No automated way to verify correctness after changes. The only validation is through 6 demo notebooks in `demos/`. No CI/CD pipeline.

---

### ISSUE-17: `population_sampler.run_mcmc()` initializes `pos` but then passes `pos_init` to `sample()` [LOW]

**File**: `frankenz/samplers.py:172-191`

```python
# samplers.py:172-182 - run_mcmc computes pos
if pos_init is None:
    try:
        pos = self.samples[-1]
    except:
        pos = self.pdfs.sum(axis=0) / self.pdfs.sum()
else:
    pos = pos_init

# samplers.py:185-187 - but passes pos_init (not pos) to sample()
for i, (x, lnp) in enumerate(self.sample(Niter,
                                         logprior_nz=logprior_nz,
                                         pos_init=pos_init,  # <-- passes original, not computed pos
                                         ...)):
```

The `run_mcmc()` method computes a `pos` variable (trying last sample first, falling back to stacked PDFs), but then passes the **original** `pos_init` to `sample()`, which recomputes it independently. The computed `pos` in `run_mcmc` is never used.

**Impact**: The fallback logic in `run_mcmc` (lines 172-179) is dead code. The `sample()` generator handles initialization correctly on its own, so the practical impact is nil -- just confusing code.

---

### ISSUE-18: `setup.py` metadata is outdated [LOW]

**File**: `frankenz/setup.py`

- Lists Python 2.7 and 3.6 as supported (both EOL)
- URL points to an empty string
- `long_description` is empty
- License is MIT but no LICENSE file exists in the repo

---

## Architecture Notes for Future Development

### Strengths
- Clean separation: `pdf.py` (math) / `bruteforce.py`/`knn.py`/`networks.py` (fitting) / `samplers.py` (inference)
- Generator-based fitting (`_fit`, `_predict`, `_fit_predict`) enables streaming without full materialization
- Numerically stable: uses `logsumexp`, `xlogy`, `gammaln` throughout
- Flexible: custom `lprob_func` allows swapping the entire likelihood framework
- Good photometric utilities: `luptitude` for low-S/N, `PDFDict` for fast KDE

### Weaknesses
- No parallelization (single-threaded Python loops over objects)
- No GPU support
- No I/O utilities (no FITS reader/writer, no catalog integration)
- No cross-validation or calibration diagnostics built in
- The `dim_prior` behavior (chi2-distribution transform) is unusual and may surprise users expecting a standard chi2 likelihood

### Recommended Improvements (Priority Order)

1. **Fix BUG-01 through BUG-05** - straightforward patches, highest impact
2. **Add convergence guard to `_loglike_s`** (ISSUE-06)
3. **Add basic unit tests** for `loglike`, `gauss_kde`, `pdfs_summarize`
4. **Drop Python 2 support** and remove `six`
5. **Add batch processing** to avoid OOM for large datasets
6. **Add FITS I/O** for astronomical catalog integration
7. **Add parallelization** (multiprocessing or joblib) for the per-object loop
