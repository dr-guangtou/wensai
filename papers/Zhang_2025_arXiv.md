---
title: Photometric Redshift Estimation for Rubin Observatory Data Preview 1 with Redshift Assessment Infrastructure Layers (RAIL)
authors:
  - T. Zhang
  - E. Charles
  - J.F. Crenshaw
  - S.J. Schmidt
  - LSST DESC
first_author: Zhang
year: 2025
journal: arXiv
arxiv_id: 2510.07370v1
doi: N/A
topics:
  - photometric redshifts
  - Rubin Observatory
  - LSST
  - machine learning
  - cosmology
tags:
  - photo-z
  - RAIL
  - LSST
  - template-fitting
status: digest
source: Paper Digest
type: paper
---

## tl;dr

First systematic photo-z analysis using real Rubin Observatory DP1 data, demonstrating that the RAIL framework with 8 algorithms achieves LSST Y1 requirements (bias < 0.005, scatter ~ 0.03) for 6-band photometry in ECDFS. Machine-learning methods outperform template-fitting across redshift, and adding Euclid NIR improves photo-z at z > 1.2. Validates RAIL pipeline readiness for LSST operations.

## Key Question

How well do photometric redshift estimation algorithms perform on real Rubin Observatory DP1 data, and is the RAIL framework ready for LSST-scale production?

## Methodology

**Innovative aspects:**
- First application of the RAIL (Redshift Assessment Infrastructure Layers) framework to real LSST Commissioning Camera data (DP1)
- Systematic comparison of 8 photo-z algorithms (2 template-fitting, 6 machine-learning) on identical data
- Reference catalog constructed from spec-z, grism-z, and high-quality photo-z in ECDFS field
- Cross-matching with DESI DR1 and Euclid NIR for validation and improvement studies
- Three training configurations: 6-band (ugrizy), 4-band (griz), and 6-band + Euclid NIR (YJH)

**Data:**
- Extended Chandra Deep Field South (ECDFS): deep ugrizy coverage
- SV_38_7 field: griz only
- Validation: DESI DR1 spectroscopic redshifts

## Main Results

- **Bias:** Machine-learning algorithms achieve bias < 0.005, meeting LSST Y1 requirement
- **Scatter:** $\sigma_{\rm NMAD} \sim 0.03$, well below LSST Y1 requirement of 0.1
- **Outlier rate:** ~10% (defined as $|\Delta z| > 0.15$)
- **Binning accuracy:** FlexZBoost achieves 78.1% for tomographic binning
- **Redshift range:** Performance degrades at $z > 1.2$ and $i$-mag > 23
- **Euclid NIR improvement:** Adding YJH bands reduces bias, scatter, and outlier rates at $z > 1.5$
- **Template-fitting vs ML:** Template methods show more bias across the full redshift range
- **Ensemble n(z):** Stacked photo-z PDFs successfully recover true redshift distribution in ECDFS test set

## Key Figures

- **Figure 5:** Photo-z performance metrics (bias, scatter, outlier rate) vs redshift and $i$-band magnitude for all 8 algorithms — shows degradation at $z > 1.2$ and $i$ > 23
- **Figure 6:** PIT-QQ plot for PDF calibration — some methods (CMNN) give overconfident error bars; template methods skewed toward high-z
- **Figure 7:** FlexZBoost performance comparison with/without Euclid NIR — NIR improves metrics at $z > 1.5$
- **Figure 8:** Stacked n(z) vs true distribution — most algorithms recover ensemble distribution well in ECDFS

## Summary of the 8 Photo-z Algorithms

**Template-Fitting Methods:**

1. **BPZ** — Compares observed photometry to SED templates with Bayesian priors; uses 136 SEDs with dust extinction applied to blue templates. Can extrapolate beyond training set but limited by SED-template mismatch.

2. **LePhare** — Similar template-fitting approach with internal dust extinction grid (E(B-V) = 0.05–0.5); uses same base SED set as BPZ. More flexible dust modeling than BPZ.

**Machine-Learning Methods:**

3. **TPZ (Trees for Photo-z)** — Uses random forests to regress redshift from multiband photometry; handles non-linear color-redshift relationships empirically.

4. **FlexZBoost** — Uses boosted decision trees for color-to-redshift mapping; achieved best binning accuracy (78.1%) and tightest scatter among tested methods.

5. **kNN** — Predicts redshift from average of nearest neighbors in color-magnitude space; simple but effective baseline method.

6. **CMNN (Color-Matched Nearest Neighbors)** — Improves on kNN by weighting neighbors using Mahalanobis distance in color space; gives overconfident PDFs according to PIT-QQ analysis.

7. **GPz** — Gaussian Processes modeling of redshift-color relation; showed larger overall dispersion compared to other ML methods in this study.

8. **DNF** — Fits local linear models using nearest neighbors; provides lowest bias, scatter, and outlier rate at highest redshifts ($z > 1.2$).

## Critical Notes

**Strengths:**
- First validation of RAIL on real LSST data
- Comprehensive comparison of multiple algorithms on identical datasets
- Cross-validation with external surveys (DESI, Euclid)

**Limitations:**
- Training set depth limits robustness past $z \approx 1.2$
- Some algorithms struggle with non-detections in certain bands
- Limited hyperparameter optimization performed
- LSSTComCam g-band red leak (won't affect LSSTCam)

## Open Questions

- How will performance scale to full LSST depth and area?
- What is the optimal training set selection strategy for heterogeneous galaxy populations?
- Can hybrid approaches (template + ML) combine strengths of both methods?
- How to best handle non-detections and negative fluxes in photo-z algorithms?

---
## Follow-up Discussion

(To be appended during follow-up questions)
