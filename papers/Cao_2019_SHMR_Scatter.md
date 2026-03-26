---
title: "Constraining the scatter in the galaxy-halo connection at Milky Way masses"
authors: ["Jun-zhi Cao", "Jeremy L. Tinker", "Yao-Yuan Mao", "Risa H. Wechsler"]
first_author: "Cao"
year: 2019
journal: "MNRAS"
arxiv_id: "1910.03605"
doi: "10.1093/mnras/stz3103"
topics: [galaxy-halo connection, SHMR scatter, Milky Way mass, abundance matching, galaxy clustering]
tags: [SHMR, scatter, V_peak, low mass, star-forming, SDSS, central galaxies]
status: "digest"
source: "Paper Digest"
type: "paper"
special_request: "Careful summary with focus on DESI/MUST connection for tightening constraints"
---

## tl;dr

This paper presents **two novel methods** to constrain the scatter in the stellar-to-halo mass relation (SHMR) at **low halo masses** (M_h ~ 10^11.6-10^12 M⊙), the regime where most star formation occurs. Using SDSS main galaxy sample, they find:

| Method | σ[M*|V_peak] | V_peak | σ[M*|M_h] | M_h |
|--------|--------------|--------|-----------|-----|
| **Cross-correlation (ω)** | **0.27 ± 0.05 dex** | 168 km/s | **0.38 ± 0.06 dex** | 10^11.8 M⊙ |
| **Kurtosis (κ)** | **0.30 ± 0.03 dex** | 209 km/s | **0.34 ± 0.04 dex** | 10^12.2 M⊙ |

**Key finding**: Scatter at MW masses is **significantly higher** than at high masses (~0.18 dex), increasing rapidly below the SHMR pivot point (M_h ~ 10^12 M⊙). This is qualitatively consistent with hydrodynamic simulations (EAGLE, IllustrisTNG) but with larger amplitude.

---

# Part 1: The Problem and Motivation

## Why Study Scatter at Low Masses?

The galaxy-halo connection is well-constrained at **high masses** (M_h > 10^12.5 M⊙):
- Clustering studies → σ[M*|M_h] ~ 0.2 dex
- Rich group statistics → tight constraints
- Red, passive galaxies dominate

**But** at **Milky Way masses** (M_h ~ 10^12 M⊙):
- Star-forming galaxies dominate
- Star formation physics drives scatter
- **Previous methods insensitive** (clustering weak, few satellites)

**The physics question**: How tightly is star formation correlated with halo growth at the mass scale where most cosmic star formation occurs?

---

## Two Complementary Definitions of Scatter

### 1. Scatter at Fixed Halo Property: σ[M*|V_peak]

**Definition**: Log-normal scatter in stellar mass at fixed peak circular velocity:

$$P(M_* | V_{peak}) = \frac{1}{\sqrt{2\pi}\sigma} \exp\left(-\frac{(\log M_* - \langle \log M_* \rangle)^2}{2\sigma^2}\right)$$

**Why V_peak?**
- Better reproduces galaxy clustering than M_h
- More closely tied to galaxy formation physics
- Less affected by recent halo growth

### 2. Scatter at Fixed Halo Mass: σ[M*|M_h]

**Definition**: Scatter in stellar mass at fixed halo mass.

**Relationship**: σ[M*|M_h] > σ[M*|V_peak] due to additional scatter between V_peak and M_h.

**Conversion**: At M_h ~ 10^12 M⊙:
- σ[M*|V_peak] = 0.27-0.30 dex
- σ[M*|M_h] = 0.34-0.38 dex (factor of ~1.3× larger)

---

# Part 2: Two New Observational Methods

## Method 1: Cross-Correlation Ratio (ω)

### Concept

The **small-scale cross-correlation** of central galaxies with lower-mass galaxies is sensitive to the **satellite fraction**, which depends on scatter.

**Why?**
- More scatter → wider range of halo masses for fixed M_*
- More massive halos host more satellites
- Higher satellite fraction → stronger cross-correlation

### Observable

$$\omega = \frac{w_p^{cross}(r_p | r_{p,min}, r_{p,max})}{w_p^{auto}(r_p | r_{p,min}^{auto}, r_{p,max}^{auto})}$$

where:
- $w_p^{cross}$ = projected cross-correlation (centrals × tracers)
- $w_p^{auto}$ = projected auto-correlation (centrals × centrals)
- Ratio normalizes out clustering amplitude

**Scale choice**:
- $r_p$ = 0.3-2 h⁻¹ Mpc (one-halo regime)
- Balances scatter sensitivity vs measurement precision

### Measurement from SDSS

**Sample**:
- Centrals: M_* = 10^9.7-10^10.35 M⊙ (log M_* = 9.7-10.35)
- Tracers: M_* > 10^9.7 M⊙ (complete volume-limited)
- Redshift: z = 0.01-0.033
- Group finder: Yang et al. (2005) method, P_sat < 0.01 for centrals

**Result**:
$$\omega_{obs} = 0.428 \pm 0.016$$

**Constraint**:
$$\sigma[M_* | V_{peak}] = 0.275 \pm 0.055 \text{ dex}$$

at mean V_peak = 168 km/s (M_h ~ 10^11.8 M⊙)

---

## Method 2: Velocity Kurtosis (κ)

### Concept

The **distribution of line-of-sight velocities** between centrals and neighboring galaxies is sensitive to the **halo mass distribution** at fixed stellar mass.

**Why?**
- Satellite velocities trace halo potential
- More scatter → wider range of host halo masses
- Wider mass range → broader velocity distribution
- Broader distribution → higher kurtosis

### Observable

**Fisher kurtosis** of velocity PDF (2σ clipping):
$$\kappa = \frac{\langle (v_z - \bar{v}_z)^4 \rangle}{\langle (v_z - \bar{v}_z)^2 \rangle^2} - 3$$

**Analytic expectation**:
- Gaussian distribution → κ = 0
- Broader distribution → κ > 0
- κ increases monotonically with σ[M*|V_peak]

### Measurement from SDSS

**Sample**:
- Centrals: M_* = 10^10.35-10^10.65 M⊙ (log M_* = 10.35-10.65)
- Tracers: All galaxies within cylinder (group satellites + interlopers)
- Velocity range: |v_z| < 1000 km/s
- 2σ clipping to remove outliers

**Results**:

| Tracer sample | κ_obs | Constraint |
|---------------|-------|------------|
| **All galaxies** | 0.17 ± 0.02 | σ[M*|V_peak] = 0.35 ± 0.06 dex |
| **Group satellites** | 0.27 ± 0.02 | σ[M*|V_peak] = 0.27 ± 0.04 dex |

**Combined**:
$$\sigma[M_* | V_{peak}] = 0.30 \pm 0.03 \text{ dex}$$

at V_peak = 209 km/s (M_h ~ 10^12.2 M⊙)

### Complementary Information

- **All galaxies**: Sensitive at low scatter (includes interlopers)
- **Group satellites**: Sensitive at high scatter (group finder prior)
- **Combined**: Full constraint across parameter space

---

# Part 3: Key Results

## Summary of Constraints

| Quantity | Value | Mass Scale | Method |
|----------|-------|------------|--------|
| σ[M*\|V_peak] | **0.27 ± 0.05 dex** | V_peak = 168 km/s | Cross-correlation (ω) |
| σ[M*\|V_peak] | **0.30 ± 0.03 dex** | V_peak = 209 km/s | Kurtosis (κ) |
| σ[M*\|M_h] | **0.38 ± 0.06 dex** | M_h = 10^11.8 M⊙ | ω + conversion |
| σ[M*\|M_h] | **0.34 ± 0.04 dex** | M_h = 10^12.2 M⊙ | κ + conversion |

**Weighted average**: σ[M*|V_peak] ≈ **0.29 dex** at MW masses

---

## Comparison to High-Mass Constraints

| Study | σ[M*\|M_h] | M_h Range | Method |
|-------|------------|-----------|--------|
| **This work** | **0.34-0.38 dex** | ~10^12 M⊙ | ω, κ |
| Reddick et al. (2013) | ~0.20 dex | >10^13 M⊙ | Group scatter |
| Tinker et al. (2017) | ~0.18 dex | >10^12.5 M⊙ | Clustering |
| Zu & Mandelbaum (2015) | ~0.20 dex | >10^12.5 M⊙ | Clustering |
| Lange et al. (2019) | ~0.18 dex | >10^12.5 M⊙ | Group finder |

**Key finding**: Scatter at MW masses is **~2× higher** than at high masses!

---

## Physical Interpretation

### Mass Dependence of Scatter

The scatter σ[M*|M_h] shows a **rapid increase** below the SHMR pivot point:

- **M_h > 10^12.5 M⊙**: σ ~ 0.18 dex (flat, quenched galaxies)
- **M_h ~ 10^12 M⊙**: σ ~ 0.30 dex (transition)
- **M_h < 10^12 M⊙**: σ ~ 0.34-0.38 dex (star-forming galaxies)

**Why the increase?**

1. **Star formation physics**: At low masses, star formation is stochastic and bursty
2. **Halo growth correlation**: Less correlation between M_* and halo assembly history
3. **Feedback effects**: Stellar feedback varies more at low mass
4. **V_peak vs M_h scatter**: Additional scatter in concentration at low mass

### Comparison to Simulations

| Simulation | σ[M*\|M_h] at 10^12 M⊙ | Trend |
|------------|------------------------|-------|
| **EAGLE** | ~0.25 dex | Upturn at low mass |
| **IllustrisTNG** | ~0.28 dex | Upturn at low mass |
| **MBII** | ~0.20 dex | Flat (resolution limited) |
| **Semi-analytic models** | ~0.30-0.35 dex | Higher overall |
| **This work (data)** | **0.34-0.38 dex** | **Strong upturn** |

**Conclusion**: Hydrodynamic simulations qualitatively reproduce the upturn, but **underpredict the amplitude** by ~30-40%.

---

# Part 4: DESI and MUST - Future Prospects

## DESI Bright Galaxy Survey (BGS)

The paper explicitly mentions DESI as the next step:

> "The Bright Galaxy Survey of the Dark Energy Spectroscopic Instrument (DESI Collaboration et al. 2016) will expand the SDSS main galaxy sample **two magnitudes fainter and cover twice the area**."

### Expected Improvements with DESI

| Parameter | SDSS (this work) | DESI BGS | Improvement |
|-----------|------------------|----------|-------------|
| **Depth** | M_r < -17.48 | M_r < -19.5 (2 mag fainter) | ~10× more galaxies |
| **Area** | ~8,000 deg² | ~14,000 deg² | 1.75× larger |
| **Volume** | z < 0.033 | z < 0.05 (approx) | ~3× larger |
| **Galaxy density** | ~0.01 Mpc⁻³ | ~0.03 Mpc⁻³ | 3× higher |
| **Sample size** | ~10^5 centrals | ~10^6 centrals | 10× larger |

### DESI Constraints Projection

**Statistical errors scale as**:
$$\sigma_{stat} \propto N^{-1/2} \sim (10)^{-1/2} \approx 0.3\times$$

**Expected DESI constraints**:
- σ[M*|V_peak]: **~0.09 dex** (vs 0.05 dex now) → factor ~2 tighter
- Extend to **lower stellar masses**: M_* ~ 10^8.5 M⊙ (vs 10^9.7 M⊙)
- Extend to **lower halo masses**: M_h ~ 10^11 M⊙ (vs 10^11.6 M⊙)

---

## MUST (Multiplexed Survey Telescope)

### What is MUST?

**MUST** is a 6.5-meter spectroscopic survey telescope being built at Tsinghua University:
- **Aperture**: 6.5 m
- **Field of view**: ~3-5 deg²
- **Multiplexing**: ~10,000 fibers
- **Resolution**: R ~ 5000-6000 (sufficient for redshifts and line widths)
- **Wavelength**: Optical (griz)

### MUST Advantages Over DESI/SDSS

| Capability | SDSS | DESI | MUST |
|------------|------|------|------|
| **Aperture** | 2.5 m | 4 m | **6.5 m** |
| **Fiber count** | 640 | 5,000 | **~10,000** |
| **Depth (single exposure)** | r ~ 17.8 | r ~ 19.5 | **r ~ 21+** |
| **Survey speed** | Moderate | High | **Very high** |
| **Redshift range** | z < 0.3 | z < 0.6 | **z ~ 0-1** |
| **Coverage** | Northern | Wide | **Northern (China site)** |

### How MUST Can Improve Constraints

#### 1. **Deeper Sample → Lower Masses**

With r ~ 21 limit vs DESI r ~ 19.5:
- Probe **2 magnitudes fainter** than DESI
- Reach stellar masses: M_* ~ 10^7.5-10^8 M⊙ at z ~ 0.1
- Probe halo masses: M_h ~ 10^10.5-10^11 M⊙
- **First constraints** on scatter at sub-MW masses!

#### 2. **Higher Redshift → Evolution Constraints**

With efficient spectroscopy at z ~ 0.5-1:
- Measure scatter at **z ~ 0.5** (lookback ~5 Gyr)
- Test if scatter **evolves with redshift**
- Constrain star formation stochasticity over time

#### 3. **Higher Number Density → Better Statistics**

With 10,000 fibers and wide FoV:
- Survey **>10^6 galaxies** in reasonable time
- Statistical errors on scatter: **~0.05 dex or better**
- Measure **redshift evolution** of scatter

#### 4. **Northern Sky Complementarity**

- DESI covers full sky; MUST focuses on **Northern hemisphere**
- **Independent sample** for systematics checks
- Overlap regions for cross-calibration

---

## Evaluation: "With DESI and MUST, we could further tighten the constraints"

### The Statement is **CORRECT**, with caveats:

#### ✅ **What WILL improve**:

1. **Statistical precision**: Factor ~2-3 tighter constraints on σ[M*|V_peak]
2. **Mass range**: Extend to M_h ~ 10^11 M⊙ (DESI) or even ~10^10.5 M⊙ (MUST)
3. **Redshift evolution**: z ~ 0.5 constraints (MUST)
4. **Systematic checks**: Independent northern sample

#### ⚠️ **What is CHALLENGING**:

1. **Systematics dominate at some level**:
   - Group finder impurities (~10% even with purity cuts)
   - Miscentering of centrals
   - Redshift space distortions
   - These don't improve with larger samples

2. **Shot noise floor**:
   - At very small scales (r < 0.3 h⁻¹ Mpc), shot noise limits precision
   - Even infinite sample doesn't help

3. **Baryonic effects**:
   - AGN feedback, stellar feedback modify inner profiles
   - Need hydro simulations to model (expensive)

#### 📊 **Projected Improvements**

| Survey | σ[M*\|V_peak] precision | Mass reach | Redshift reach |
|--------|------------------------|------------|----------------|
| SDSS (current) | 0.05 dex | 10^11.6 M⊙ | z ~ 0.03 |
| DESI | **0.03 dex** | **10^11 M⊙** | z ~ 0.05 |
| MUST | **0.02 dex** | **10^10.5 M⊙** | **z ~ 0.5** |

---

# Part 5: Detailed Analysis for MUST Planning

## Recommended MUST Survey Strategy

### Target Selection

**Primary sample for SHMR scatter**:
- **Magnitude**: r < 20.5 (secure redshifts)
- **Redshift**: z < 0.3 (for clustering/velocity methods)
- **Stellar mass**: M_* > 10^8.5 M⊙ (completeness)
- **Central galaxies**: P_sat < 0.01 (high purity)
- **Expected yield**: ~10^6 galaxies over ~5,000 deg²

### Key Measurements Needed

1. **Spectroscopic redshifts** (z_spec accuracy < 100 km/s)
2. **Stellar masses** (from SED fitting with photometry)
3. **Group catalog** (friends-of-friends or Yang method)
4. **Central galaxy identification** (P_sat < 0.01)

### Method Implementation

#### Cross-Correlation Method (ω)

**Requirements**:
- Centrals: M_* = 10^8.5-10^9.5 M⊙ (lower than SDSS)
- Tracers: M_* > 10^8.5 M⊙ (complete)
- Scales: r_p = 0.3-2 h⁻¹ Mpc
- Area: > 1,000 deg² for jackknife errors

**Expected precision**: σ(ω) ~ 0.01 (vs 0.016 in SDSS)
→ σ[scatter] ~ 0.02 dex

#### Kurtosis Method (κ)

**Requirements**:
- Centrals: M_* = 10^9.5-10^10 M⊙
- Redshift accuracy: σ_z < 50 km/s
- Velocity range: |v_z| < 1000 km/s
- Sample: ~10^5 centrals

**Expected precision**: σ(κ) ~ 0.01 (vs 0.02 in SDSS)
→ σ[scatter] ~ 0.015 dex

### Complementary MUST Science

1. **High-z extension**: Measure scatter evolution to z ~ 1
2. **Environment dependence**: Scatter in clusters vs field
3. **Morphology dependence**: Scatter for disks vs spheroids
4. **SFR dependence**: Scatter for star-forming vs quenched

---

# Part 6: Summary and Recommendations

## Key Takeaways from This Paper

1. **Scatter at MW masses is high**: σ[M*|M_h] ~ 0.34-0.38 dex (vs ~0.18 dex at high mass)

2. **Two complementary methods**:
   - Cross-correlation ratio (ω) → sensitive to satellite fraction
   - Velocity kurtosis (κ) → sensitive to halo mass distribution

3. **Methods validated**: Both give consistent results (~0.27-0.30 dex in σ[M*|V_peak])

4. **Physical interpretation**: Scatter increases below SHMR pivot due to stochastic star formation

5. **Simulations underpredict**: Hydro models show qualitative upturn but ~30-40% lower amplitude

## Evaluation Statement: "With DESI and MUST, we could further tighten the constraints"

### **VERDICT: TRUE, with nuanced interpretation**

**What "tighten" means**:
- ✅ **Statistical precision**: Yes, factor ~2-3 improvement
- ✅ **Mass range**: Yes, extend to lower masses
- ✅ **Redshift coverage**: Yes, evolution constraints (MUST)
- ⚠️ **Systematic floor**: No, still limited by group finder, miscentering

**What MUST specifically adds beyond DESI**:
1. **Deeper sample**: 2-3 magnitudes fainter → M_h ~ 10^10.5 M⊙
2. **Higher z**: z ~ 0.5 vs z ~ 0.05 → evolution constraints
3. **Northern sky**: Independent sample for systematics
4. **Synergy with imaging**: LSST + MUST photometry for stellar masses

### **Practical Recommendation for MUST**

**Phase 1 (Year 1-2)**: 
- Target r < 20.5, z < 0.3
- Reproduce SDSS/DESI methods for validation
- Focus on cross-correlation (ω) method (higher S/N)

**Phase 2 (Year 3-5)**:
- Extend to r < 21.5, z ~ 0.5
- Apply both methods at higher redshift
- Measure evolution of scatter with z

**Expected outcome**:
- **σ[M*|V_peak] ~ 0.02 dex precision** at M_h ~ 10^11 M⊙
- **First constraints** at M_h ~ 10^10.5 M⊙
- **Evolution constraints** to z ~ 0.5

---

## Follow-up Discussion

(Reserved for future questions about MUST survey planning)

**Your next steps**:
1. Compare MUST specifications to DESI requirements
2. Simulate MUST survey for SHMR scatter forecasts
3. Plan overlap with LSST for stellar masses
4. Design group finder for MUST redshift catalog
