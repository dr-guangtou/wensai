---
date: 2026-02-27
title: Frankenz Usage Guide
author: "Song Huang (documentation), Joshua S. Speagle (code)"
tags:
  - project
  - dev/frankenz
  - astro/photometry
  - project/hsc
status: draft
version: 0.3.5
---
# Frankenz Usage Guide

## Overview

`frankenz` is a **Bayesian template-matching photometric redshift** library. It does **not** use data-driven ML (no random forests, neural nets, boosting). Instead, it compares observed photometry against a pre-computed library of SED templates at known redshifts, computes likelihoods, and constructs posterior PDFs via kernel density estimation (KDE).

### Core Pipeline

```
SED Templates + Filters + Redshift Grid
         |
         v
   Model Photometry Grid (N_model, N_filter)
         |
         v
   Compare vs. Observed Data (N_obj, N_filter)
         |  [chi2 likelihood]
         v
   Log-posterior weights per model
         |  [KDE smoothing]
         v
   Redshift PDF per object (N_obj, N_zgrid)
         |
         v
   Point estimates + credible intervals
```

### Fitting Methods

| Method | Class | Strategy | When to Use |
|--------|-------|----------|-------------|
| **Brute Force** | `BruteForce` | Evaluate ALL models | Small model grids (< 10k), or gold-standard reference |
| **KMCkNN** | `NearestNeighbors` | K Monte Carlo KDTrees, k nearest neighbors each | Large model grids (> 10k), production runs |
| **SOM** | `SelfOrganizingMap` | Self-organizing map nodes | Dimensionality reduction, visualization |
| **GNG** | `GrowingNeuralGas` | Adaptive node growth | Auto-topology, exploratory |

All four produce the same output format: `(N_obj, N_zgrid)` PDF arrays.

---

## Installation

```bash
# From source
git clone <repo_url>
cd frankenz
pip install .

# Dependencies: numpy, scipy, matplotlib, six, pandas, networkx
```

---

## Step-by-Step Usage

### Step 1: Prepare the Model Grid

The model grid is an array of synthetic photometry at known redshifts. Each row represents one (SED template, redshift) combination evaluated through your survey filters.

**Option A: Using built-in mock survey tools**

```python
import numpy as np
from frankenz import simulate

survey = simulate.MockSurvey()

# Load a pre-defined survey (filter set + depth)
# Available: 'cosmos', 'euclid', 'hsc', 'lsst', 'sdss'
survey.load_survey('hsc')

# Load SED template library
# Available: 'brown' (129 galaxies), 'cww+' (8 templates), 'polletta+' (31 templates)
survey.load_templates('cww+')

# Optional: load BPZ prior
survey.load_prior('bpz')

# Generate model grid at specified redshifts
zgrid_model = np.arange(0, 6.01, 0.01)
survey.make_model_grid(zgrid=zgrid_model)

# Extract arrays
models = survey.models           # shape: (N_model, N_filter)
models_err = survey.models_err   # shape: (N_model, N_filter)
models_mask = survey.models_mask # shape: (N_model, N_filter), binary

# Redshifts corresponding to each model row
model_redshifts = survey.model_grid['redshifts']      # shape: (N_model,)
model_redshift_errs = survey.model_grid['redshifts_err']  # shape: (N_model,)
```

**Option B: Using your own model grid**

```python
# You must generate synthetic photometry externally
# (e.g., using EAZY, LePhare, or custom SED fitting code)
models = np.load('my_model_fluxes.npy')       # (N_model, N_filter)
models_err = np.load('my_model_flux_errs.npy') # (N_model, N_filter)
models_mask = np.ones_like(models)              # all valid

model_redshifts = np.load('my_model_redshifts.npy')  # (N_model,)
# Small fixed error for KDE kernel widths:
model_redshift_errs = np.full(len(model_redshifts), 0.005)
```

### Step 2: Prepare Observed Data

```python
# Shape: (N_objects, N_filters)
data = np.array(...)       # Observed fluxes
data_err = np.array(...)   # 1-sigma Gaussian errors (must be > 0 for valid bands)
data_mask = np.array(...)  # Binary: 1 = observed, 0 = missing/invalid
```

> **Critical**: Data and models MUST be in the same flux system with consistent zeropoints. Frankenz performs no internal calibration or unit conversion.

### Step 3: Initialize a Fitter

**Brute Force** (simple, exhaustive):
```python
from frankenz.fitting import BruteForce

fitter = BruteForce(models, models_err, models_mask)
```

**KMCkNN** (fast, recommended for production):
```python
from frankenz.fitting import NearestNeighbors

fitter = NearestNeighbors(
    models, models_err, models_mask,
    K=25,                    # Number of MC KDTrees (more = robust, slower)
    feature_map='luptitude', # 'luptitude' (default), 'magnitude', or 'identity'
    leafsize=50,             # KDTree leaf size
)
# This prints progress as KDTrees are built: "1/25 KDTrees constructed"
```

### Step 4: Fit and Generate PDFs

Define the output redshift grid:
```python
zgrid = np.linspace(0, 6, 601)  # PDF evaluation grid
```

**One-step fit+predict** (recommended, more memory-efficient):
```python
pdfs = fitter.fit_predict(
    data, data_err, data_mask,
    model_redshifts, model_redshift_errs,
    label_grid=zgrid,
    # Optional: pass likelihood function kwargs
    lprob_kwargs={'free_scale': True, 'dim_prior': True},
    return_gof=False,
    verbose=True,
)
# pdfs shape: (N_objects, len(zgrid))
```

**Two-step fit then predict** (if you want to inspect fits or reuse):
```python
fitter.fit(data, data_err, data_mask,
           lprob_kwargs={'free_scale': True})
pdfs = fitter.predict(model_redshifts, model_redshift_errs, label_grid=zgrid)
```

**Using a pre-computed KDE dictionary** (faster for many objects):
```python
from frankenz.pdf import PDFDict

sigma_grid = np.arange(0.001, 0.5, 0.001)
pdict = PDFDict(zgrid, sigma_grid)

pdfs = fitter.fit_predict(
    data, data_err, data_mask,
    model_redshifts, model_redshift_errs,
    label_dict=pdict,  # uses dictionary instead of label_grid
)
```

### Step 5: Extract Point Estimates and Diagnostics

```python
from frankenz.pdf import pdfs_summarize

# WARNING: pdfs_summarize mutates the input pdfs array when renormalize=True (default)
# Pass pdfs.copy() if you need to preserve the original
results = pdfs_summarize(pdfs.copy(), zgrid)

# Unpack results
(pmean, pmean_std, pmean_conf, pmean_risk) = results[0]   # Mean (L2 optimal)
(pmed, pmed_std, pmed_conf, pmed_risk) = results[1]       # Median (L1 optimal)
(pmode, pmode_std, pmode_conf, pmode_risk) = results[2]    # Mode (MAP)
(pbest, pbest_std, pbest_conf, pbest_risk) = results[3]    # Best (min Lorentz risk)
(plow95, plow68, phigh68, phigh95) = results[4]            # Credible intervals
pmc = results[5]                                            # MC realization

# Each estimator comes with:
#   *_std  : standard deviation around the estimator
#   *_conf : PDF fraction within +/- width window (default: 0.03*(1+z))
#   *_risk : risk under the chosen loss kernel (default: Lorentz)
```

**Goodness-of-fit metrics** (optional):
```python
pdfs, (lmap, levid) = fitter.fit_predict(
    data, data_err, data_mask,
    model_redshifts, model_redshift_errs,
    label_grid=zgrid,
    return_gof=True,
)
# lmap  : ln(MAP) = max log-posterior per object
# levid : ln(evidence) = log of the marginal likelihood
```

### Step 6 (Optional): Population and Hierarchical Inference

**Population N(z) sampling** (given individual PDFs):
```python
from frankenz.samplers import population_sampler

pop = population_sampler(pdfs)  # pdfs: (N_obj, N_zbins)
pop.run_mcmc(
    Niter=1000,      # Number of saved samples
    thin=400,        # Gibbs steps between saves
    mh_steps=3,      # MH proposals per Gibbs step
)
nz_samples, lnpost = pop.results
# nz_samples shape: (1000, N_zbins) - posterior N(z) samples
```

**Hierarchical inference** (jointly infers N(z) and individual redshifts):
```python
from frankenz.samplers import hierarchical_sampler

# IMPORTANT: pdfs must be LIKELIHOODS (not posteriors)
# The prior is modeled hierarchically via a Dirichlet distribution
hier = hierarchical_sampler(pdfs)
hier.run_mcmc(
    Niter=1000,
    thin=5,
    alpha=None,       # Dirichlet concentration (default: flat, alpha=1)
    ref_sample=None,  # Optional spectroscopic reference counts
)
nz_samples, lnpost = hier.results
```

---

## Key Configuration Parameters

### Likelihood Function Parameters

These are passed via `lprob_kwargs` to `fit()` or `fit_predict()`:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `free_scale` | bool | `False` | Allow free amplitude scaling of models to data. **Essential for template fitting when model amplitudes are arbitrary.** |
| `dim_prior` | bool | `True` | Apply chi2-distribution correction for varying number of observed filters per object. Important for heterogeneous surveys. |
| `ignore_model_err` | bool | `False` | If True, only use data errors (ignore model uncertainties). |
| `ltol` | float | `1e-4` | Convergence tolerance for iterative scale-factor optimization (only used when `free_scale=True` and `ignore_model_err=False`). |
| `return_scale` | bool | `False` | Return the fitted scale factor and its error. |

### NearestNeighbors Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `K` | int | 25 | Number of Monte Carlo KDTrees. More trees = more robust neighbor selection, slower initialization. |
| `k` | int | 20 | Neighbors per tree. Total candidate pool ~= K * k unique models. |
| `feature_map` | str/func | `'luptitude'` | Feature transformation for NN search. `'luptitude'` recommended for photometric data with low S/N. |
| `eps` | float | `1e-3` | Approximate NN tolerance. k-th neighbor within (1+eps) of true distance. |
| `leafsize` | int | 50 | KDTree leaf size (trade-off between build time and query time). |

### KDE Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `wt_thresh` | float | `1e-3` | Ignore models with weight < thresh * max_weight. Speeds up KDE. |
| `cdf_thresh` | float | `2e-4` | Alternative threshold using CDF (used when `wt_thresh=None`). |
| `sig_thresh` | float | `5.0` | Gaussian kernel truncation in units of sigma. |

---

## Common Pitfalls

1. **Forgetting `free_scale=True`**: Without it, template amplitude must exactly match the data. A correct-redshift template at the wrong luminosity will be heavily penalized.

2. **Mismatched flux systems**: Data and models must use identical units and zeropoints. No internal calibration is performed.

3. **`pdfs_summarize` mutates input**: Always pass `pdfs.copy()` if you need the original array.

4. **`loglike()` mutates input data**: The function modifies `data`, `data_err`, `data_mask` in place. Copy before calling if reuse is needed.

5. **Memory for large runs**: `BruteForce` allocates `(N_data, N_model)` arrays. For 1M objects x 100k models, this is ~800 GB. Use `save_fits=False` with `fit_predict` generator if memory is limited.

6. **Flat priors by default**: The `logprob` wrapper applies `lnprior = 0` (flat prior). For informative priors (e.g., BPZ), write a custom `lprob_func` and pass it via `lprob_func=` parameter.

---

## Module Reference

| Module | Purpose | Key Exports |
|--------|---------|-------------|
| `frankenz.fitting` | Fitting classes | `BruteForce`, `NearestNeighbors`, `SelfOrganizingMap`, `GrowingNeuralGas` |
| `frankenz.pdf` | Likelihoods, KDE, PDF tools | `loglike`, `logprob`, `gauss_kde`, `gauss_kde_dict`, `PDFDict`, `pdfs_summarize`, `pdfs_resample`, `magnitude`, `luptitude` |
| `frankenz.simulate` | Mock data generation | `MockSurvey`, `mag_err`, `draw_mag`, `draw_ztm` |
| `frankenz.priors` | Prior distributions | `pmag`, `bpz_pt_m`, `bpz_pz_tm` |
| `frankenz.reddening` | IGM attenuation | `madau_teff` |
| `frankenz.samplers` | Population/hierarchical MCMC | `population_sampler`, `hierarchical_sampler`, `loglike_nz` |
| `frankenz.plotting` | Visualization | `input_vs_pdf`, `cdf_vs_epdf`, `plot2d_network` |

---

## Demo Notebooks

The `demos/` directory contains 6 Jupyter notebooks demonstrating the full workflow:

1. **`1 - Mock Data.ipynb`** - Generate synthetic photometric surveys using `MockSurvey`
2. **`2 - Photometric Inference.ipynb`** - Fit mock data with different methods
3. **`3 - Photometric PDFs.ipynb`** - Generate and analyze redshift PDFs
4. **`4 - Posterior Approximations.ipynb`** - Compare fitting methods and their PDF approximations
5. **`5 - Population Inference with Redshifts.ipynb`** - Population N(z) distributions
6. **`6 - Hierarchical Inference with Redshifts.ipynb`** - Hierarchical Bayesian inference
