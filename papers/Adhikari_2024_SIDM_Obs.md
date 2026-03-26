---
title: Constraints on Dark Matter Self-interactions from Weak Lensing of Galaxies from the Dark Energy Survey around Clusters from the Atacama Cosmology Telescope Survey
authors:
  - Susmita Adhikari
  - Arka Banerjee
  - Bhuvnesh Jain
  - Tae-Hyeon Shin
  - Yi-Ming Zhong
first_author: Adhikari
year: 2024
journal: ApJ (submitted)
arxiv_id: "2401.05788"
doi: N/A
topics:
  - dark matter
  - SIDM
  - weak lensing
  - galaxy clusters
  - DES
  - ACT
  - dissipative DM
tags:
  - astro/sidm
  - astro/dark_matter
  - astro/lensing
  - astro/cosmology
  - astro/cluster
status: digest
source: Paper Digest
type: paper
special_request: Observational constraints using weak lensing - follow-up to Banerjee 2019
---

## tl;dr

This paper presents **the first weak lensing constraints on both elastic (eSIDM) and dissipative (dSIDM) dark matter** using DES Y3 galaxy shapes around ~1000 SZ-selected clusters from ACT. The key results:

- **eSIDM constraint**: $\sigma/m < 1.05$ cm²/g at 95% CL — **comparable to Bullet Cluster**
- **dSIDM constraints**: First limits on energy loss parameter $\nu_{loss} = E_{loss}/m$
- **Best-fit model**: dSIDM-600 with $\sigma/m = 1$ cm²/g, $\nu_{loss} = 600$ km/s ($E_{loss} = 4$ keV m_χ/GeV)
- **Future LSST**: Will reach $\sigma/m \sim 0.5$ cm²/g or better

The study finds **steeper-than-CDM inner density profiles** (0.2-0.4 h⁻¹ Mpc), consistent with dSIDM models in the core-collapse phase. This is the **first observational study to combine semi-analytical fluid simulations with realistic initial conditions** for dSIDM.

---

# Part 1: Observational Setup

## Data Sources

| Survey | Role | Details |
|--------|------|---------|
| **ACT DR5** | Lens sample | ~1000 SZ-selected clusters |
| **DES Y3** | Source galaxies | Background galaxy shapes for weak lensing |
| **Redshift range** | Lens | z ~ 0.2-0.8 (median z = 0.48) |
| **Mass range** | Lens | M ~ 10¹⁴ M⊙ |
| **Radial range** | Profile | R = 0.2-10 h⁻¹ Mpc |

## Observable: Excess Surface Density

The weak lensing observable is the **excess surface density**:

$$\Delta\Sigma(R) = \bar{\Sigma}(<R) - \Sigma(R)$$

where:
- $\Sigma(R)$ = projected 2D surface density at radius R
- $\bar{\Sigma}(<R)$ = mean surface density within R

**Measurement**: Tangential shear of background galaxies → $\Delta\Sigma$

**Statistical uncertainty**: ~10-15% on scales of interest (DES Y3)

---

# Part 2: SIDM Models Constrained

## 1. Elastic SIDM (eSIDM)

**Assumptions:**
- Hard-sphere scattering (isotropic, velocity-independent)
- Cross-section per mass: $\sigma/m$
- Cluster-scale halos are in **core expansion phase** (not yet collapsed)

**Physical effect**:
- Energy transfer from outskirts to center → **core formation**
- Central density decreases, becomes flat
- Adjacent region becomes **steeper than CDM**

**Simulation method**: Cosmological N-body (GADGET-2 with SIDM module)

## 2. Dissipative SIDM (dSIDM)

**Assumptions:**
- Elastic + dissipative scattering
- **Dark photons** emitted during scattering → energy loss
- Three parameters:
  - $\sigma/m$ = elastic cross-section (fixed at 1 cm²/g)
  - $\sigma'/m$ = dissipative cross-section (fixed at 1 cm²/g)
  - $E_{loss}/m$ = energy loss per mass (varied)

**Physical effect**:
- Energy dissipation → **accelerated core collapse**
- Halos reach **deep core-collapse phase** within Hubble time
- Inner density becomes **steeper than CDM** (cuspy)

**Bulk cooling rate**:
$$C = \frac{\sigma'}{m} \cdot \frac{\rho^2}{\sqrt{\pi}} \cdot \nu^2 \nu_{loss}^2 \cdot \frac{e^{-\nu_{loss}^2/\nu^2}}{(1 + \kappa)^2}$$

where $\nu$ = velocity dispersion, $\nu_{loss} = E_{loss}/m$

**Simulation method**: Semi-analytical fluid simulation (faster than N-body for core-collapse)

---

## dSIDM Benchmarks

| Model | σ/m (cm²/g) | ν_loss (km/s) | E_loss (keV m_χ/GeV) | Evolution |
|-------|-------------|---------------|----------------------|-----------|
| dSIDM-300 | 1.0 | 300 | 1.0 | Some collapse |
| dSIDM-600 | 1.0 | 600 | 4.0 | **Full collapse** (best fit) |
| dSIDM-2000 | 1.0 | 2000 | 44.4 | Boltzmann-suppressed |

**Physical interpretation**:
- **ν_loss ~ ν_virial** → Maximum cooling efficiency
- **ν_loss << ν_virial** → Weak cooling
- **ν_loss >> ν_virial** → Boltzmann suppression (hard to excite particles)

---

# Part 3: Key Observational Results

## 1. Stacked Density Profiles

### Elastic SIDM (eSIDM)

**Signature**:
- **Core formation**: Inner region (r < 0.3 h⁻¹ Mpc) becomes flat
- **Steepening**: Adjacent region (0.3-1 h⁻¹ Mpc) becomes steeper than CDM
- **Outer region**: Approaches CDM at r > 1 h⁻¹ Mpc

**Physical cause**:
- Energy flows from hot outskirts to cold center
- Central particles expand orbits → density drops
- Material "piles up" at edge of core → steepening

### Dissipative SIDM (dSIDM)

**Signature**:
- **Accelerated collapse**: Inner region becomes **steeper than CDM**
- **Steepness depends on ν_loss**:
  - dSIDM-600: Steepest inner profiles (fully collapsed)
  - dSIDM-300: Intermediate steepness
  - dSIDM-2000: Mild steepening (Boltzmann-suppressed cooling)

**Inner slope** (core-collapse phase):
- **eSIDM**: γ ~ -2.2 (conduction-dominated)
- **dSIDM**: γ ~ -1.5 to -2.0 (bulk cooling + conduction)

**Key insight**: dSIDM produces **steeper-than-CDM** profiles, while eSIDM produces **flatter-than-CDM** cores!

---

## 2. Comparison to DES-ACT Data

### Observational Finding

The measured $\Delta\Sigma$ profile shows:
- **Inner region (R < 0.4 h⁻¹ Mpc)**: **Steeper than CDM predictions**
- **Middle region (0.4-1 h⁻¹ Mpc)**: Consistent with CDM
- **Outer region (> 1 h⁻¹ Mpc)**: Consistent with CDM

### Model Comparison

| Model | χ²/d.o.f. | Verdict |
|-------|-----------|---------|
| CDM | 1.1 | Acceptable |
| eSIDM (σ/m = 1) | 0.9 | Good |
| dSIDM-300 | - | Excluded by ν_loss constraints |
| **dSIDM-600** | **0.5** | **Best fit** |
| dSIDM-2000 | - | Acceptable |

**Key result**: Data prefers **steeper inner profiles**, consistent with dSIDM-600!

---

## 3. Constraints on eSIDM

### Method: Forward Modeling

1. Simulate cluster sample with same mass/redshift distribution as data
2. Compute $\Delta\Sigma$ for each cluster
3. Stack to get model prediction
4. Compare to data via χ²

### Result

**95% CL upper limit**:
$$\sigma/m < 1.05 \text{ cm}^2 \text{g}^{-1}$$

**Comparison to other constraints**:

| Probe | Constraint | Scale |
|-------|------------|-------|
| **This work** | σ/m < 1.05 cm²/g | Cluster profiles |
| Bullet Cluster | σ/m < 2 cm²/g | Merging clusters |
| Strong lensing | σ/m < 1 cm²/g | Cluster cores |
| Dwarf cores | σ/m ~ 1-10 cm²/g | Dwarf galaxies |

**Key point**: Weak lensing cluster profiles provide **competitive constraints**!

---

## 4. Constraints on dSIDM (Novel!)

### Method: Two-Step Calibration

**Step 1**: Calibrate collapse fraction vs. $\nu_{loss}$
- Run fluid simulations for each cluster in sample
- Determine if each halo is core-collapsed or cored
- Compute collapsed fraction $f_c$ as function of $\nu_{loss}$

**Step 2**: Calibrate $\Delta\Sigma$ vs. collapsed fraction
- Core-collapsed halos have steeper profiles
- Cored halos have flatter profiles
- Stacked profile is linear combination

**Combine**: Constrain $f_c$ from data → constrain $\nu_{loss}$

### Results

**Excluded ranges at 95% CL**:
- $\nu_{loss} < 160$ km/s
- $240 < \nu_{loss} < 320$ km/s
- $1600 < \nu_{loss} < 2000$ km/s
- $\nu_{loss} > 2800$ km/s

**Best fit**: $\nu_{loss} \sim 600$ km/s

**Physical interpretation**:
- $\nu_{loss} \sim \nu_{virial}$ of cluster → maximum cooling
- Consistent with E_loss ~ 4 keV for GeV-mass DM

---

# Part 4: Physical Interpretation

## Why dSIDM-600 is the Best Fit

### Observational Evidence

1. **Steeper inner profile** (R < 0.4 h⁻¹ Mpc):
   - eSIDM predicts flatter core → disfavored
   - dSIDM predicts steeper cusp → favored

2. **Full core collapse** within Hubble time:
   - dSIDM-600: All halos collapse
   - dSIDM-300: Some halos remain cored
   - dSIDM-2000: Boltzmann-suppressed cooling

3. **Optimal cooling efficiency**:
   - $\nu_{loss} = 600$ km/s ~ $\nu_{virial}$ of clusters
   - Maximum energy dissipation rate

### Physical Picture

**dSIDM-600 scenario**:
- Dark matter particles scatter and emit dark photons
- Dark photons escape → energy lost from halo
- Cooling rate ~ heating rate from conduction
- Halos reach deep core-collapse in ~few Gyr
- Inner density becomes steeper than CDM

**Key signature**: Steeper inner profile + normal outer profile

---

## M-Shaped Behavior of Density Enhancement

As $\nu_{loss}$ increases, the density enhancement compared to CDM shows "M-shaped" behavior:

1. **ν_loss ~ 0**: No dissipation → eSIDM-like (lower density)
2. **ν_loss ~ 300 km/s**: Weak cooling → partial collapse → moderate enhancement
3. **ν_loss ~ 600 km/s**: **Maximum cooling** → full collapse → **largest enhancement**
4. **ν_loss ~ 2000 km/s**: Boltzmann suppression → partial collapse → moderate enhancement
5. **ν_loss >> ν_virial**: No cooling → eSIDM-like

**Physical cause**: Balance between bulk cooling (which accelerates collapse) and conduction (which slows it)

---

# Part 5: Systematics and Caveats

## Current Limitations

| Systematic | Impact | Mitigation |
|------------|--------|------------|
| **Miscentering** | Affects inner profile | Use only R > 0.5 h⁻¹ Mpc |
| **Boost factor** | Contamination from correlated structures | Uncertainty in inner bins |
| **BCG light** | Affects shape measurements at R < 0.1 h⁻¹ Mpc | Exclude innermost bins |
| **Baryonic effects** | Can modify inner density | Expected small at R > 0.2 h⁻¹ Mpc |
| **Mass calibration** | Affects profile amplitude | Use shape information |

## Baryonic Effects

**AGN feedback** can also create cores in clusters:
- Heats central gas → potential changes
- Can flatten inner dark matter profile

**Mitigation**:
- Use outer profile (R > 0.5 h⁻¹ Mpc) where baryonic effects are small
- Future: Compare to hydrodynamic simulations with SIDM
- Semi-analytic models combining feedback + SIDM (in development)

**Current status**: Baryonic effects expected to be **small on scales measured** (R > 0.2 h⁻¹ Mpc)

---

# Part 6: Future Prospects

## Upcoming Surveys

| Survey | Cluster sample | Improvement | Expected constraint |
|--------|----------------|-------------|---------------------|
| **DES Y6** | ~3000 clusters | 3× Y3 | σ/m ~ 0.7 cm²/g |
| **LSST** | ~10⁵ clusters | 30× Y3 | **σ/m ~ 0.1-0.5 cm²/g** |
| **Euclid** | ~10⁵ clusters | 30× Y3 | σ/m ~ 0.1-0.5 cm²/g |
| **eROSITA** | ~10⁵ X-ray clusters | Full sky | σ/m ~ 0.5 cm²/g |

## LSST Capabilities

**Improvements over DES Y3**:
1. **10× more clusters**: Better statistics
2. **4× source galaxy density**: Lower shape noise
3. **Deeper imaging**: Higher redshift reach
4. **Better photo-z**: Reduced systematics

**Expected constraints**:
- **eSIDM**: σ/m ~ 0.1 cm²/g at 99% CL
- **dSIDM**: Fraction of collapsed halos to ~10%

**Key insight**: **Outer profile alone** (R > 0.5 h⁻¹ Mpc) can constrain σ/m ~ 0.5 cm²/g!

---

## Multi-Wavelength Synergy

| Probe | Advantage | Complementarity |
|-------|-----------|-----------------|
| **Optical (LSST)** | Large cluster samples | Statistical power |
| **SZ (Simons Obs, CMB-S4)** | High-redshift clusters | Evolution constraints |
| **X-ray (eROSITA)** | Mass calibration | Reduced systematics |
| **Strong lensing** | Inner profile resolution | Core physics |

**Combined**: Can probe velocity-dependence of σ/m

---

# Part 7: Comparison to Banerjee et al. (2019)

| Aspect | Banerjee 2019 | This paper (Adhikari 2024) |
|--------|---------------|----------------------------|
| **Focus** | Simulation predictions | Observational constraints |
| **Data** | None (predictions) | DES Y3 + ACT DR5 |
| **SIDM models** | Elastic only | Elastic + dissipative |
| **Method** | N-body only | N-body (eSIDM) + fluid (dSIDM) |
| **Constraint** | Forecasts only | σ/m < 1.05 cm²/g (95% CL) |
| **Key finding** | Lensing can constrain | **Confirmed with real data** |

**Connection**: This paper validates the Banerjee 2019 prediction that weak lensing cluster profiles can constrain SIDM!

---

# Part 8: Key Takeaways for Your Research

## Observational Constraints Summary

### Elastic SIDM
$$\sigma/m < 1.05 \text{ cm}^2 \text{g}^{-1} \text{ (95% CL)}$$

**Comparable to Bullet Cluster!**

### Dissipative SIDM
$$\text{Best fit: } \nu_{loss} \sim 600 \text{ km/s}$$
$$E_{loss} \sim 4 \text{ keV} \cdot (m_\chi / \text{GeV})$$

**First constraints on dissipative SIDM from weak lensing!**

---

## Practical Guidance for Observational Studies

### Data Requirements

1. **Cluster sample**: ~1000+ clusters for 10% precision
2. **Source galaxies**: n > 5 arcmin⁻² for lensing
3. **Radial coverage**: 0.2-10 h⁻¹ Mpc (need inner + outer)
4. **Redshifts**: Photo-z sufficient for statistical sample

### Analysis Strategy

1. **Stack clusters** in narrow mass/redshift bins
2. **Measure $\Delta\Sigma$** to R ~ 10 h⁻¹ Mpc
3. **Forward model** from simulations (don't just fit parametric profiles)
4. **Compare to CDM first**, then SIDM models
5. **Use shape + amplitude** to break degeneracies

### Systematics to Control

1. **Miscentering**: Use BCG or X-ray centroid
2. **Boost factor**: Model correlated structures
3. **Photo-z errors**: Propagate through $\Sigma_{crit}$
4. **Shape noise**: Increases toward center
5. **Baryonic effects**: Use R > 0.5 h⁻¹ Mpc for robust constraints

---

## Theoretical Implications

### If dSIDM-600 is Correct

**Particle physics implications**:
- Light dark photon mediator (m_φ ~ MeV-GeV)
- Kinetic mixing ε ~ 10⁻⁴-10⁻³
- DM mass m_χ ~ GeV-10 GeV
- Dissipative cross-section σ' ~ 10⁻²⁴ cm²

**Cosmological implications**:
- Cluster halos in deep core-collapse phase
- Dwarf halos may be cored (lower velocity dispersion)
- **Velocity-dependent** effects across mass scales

### If eSIDM is Correct

**Particle physics implications**:
- Heavy mediator (m_φ >> GeV)
- Contact interaction
- σ/m < 1 cm²/g across all scales

**Cosmological implications**:
- Cluster halos in core expansion phase
- Cores in dwarfs but not clusters

---

## Future Research Directions

### Short-term (1-2 years)

1. **DES Y6 analysis**: Improve constraints by ~50%
2. **HSC data**: Deeper imaging, better inner profile
3. **Velocity-dependent SIDM**: Extend to Yukawa models
4. **Combined probes**: Lensing + satellite counts + splashback

### Medium-term (3-5 years)

1. **LSST Year 1-3**: First sub-cm²/g constraints
2. **eROSITA clusters**: X-ray mass calibration
3. **Strong + weak lensing**: Full profile coverage
4. **Hydro simulations**: Baryons + SIDM simultaneously

### Long-term (5-10 years)

1. **LSST full survey**: σ/m ~ 0.1 cm²/g
2. **Euclid**: Complementary high-z constraints
3. **Multi-wavelength**: Velocity-dependence mapping
4. **Direct detection synergy**: Connect to particle physics

---

## Recommended Reading

**Observational SIDM constraints:**
- This paper (Adhikari+ 2024): Weak lensing
- Andrade et al. (2021): Strong lensing
- Bradac et al. (2006), Wittman et al. (2018): Bullet Cluster

**SIDM theory:**
- Tulin & Yu (2018): Comprehensive review
- Essig et al. (2019): dSIDM core collapse
- Huo et al. (2020): dSIDM particle physics

**Simulations:**
- Banerjee et al. (2019): eSIDM predictions (companion paper)
- Rocha et al. (2013): N-body implementation
- Koda & Shapiro (2011): Fluid simulation method

---

## Summary Table: eSIDM vs dSIDM Signatures

| Observable | CDM | eSIDM | dSIDM-600 |
|-----------|-----|-------|-----------|
| **Inner density** | Cusp (ρ ∝ r⁻¹) | Core (ρ ∝ r⁰) | **Steep cusp** (ρ ∝ r⁻¹·⁵) |
| **Core radius** | ~0 | ~0.3 h⁻¹ Mpc | ~0 (collapsed) |
| **Inner slope** | γ = -1 | γ = 0 | **γ = -1.5 to -2** |
| **ΔΣ at R < 0.4 Mpc** | Standard | Lower | **Higher** |
| **ΔΣ at R > 1 Mpc** | Standard | Slightly lower | Standard |
| **Evolution time** | - | ~100 Gyr | **~5-10 Gyr** |

**Key discriminant**: Steeper vs flatter inner profile!

---

## Follow-up Discussion

(Reserved for future questions and analysis)

**Your investigation roadmap:**
1. Compare Banerjee 2019 (theory) vs Adhikari 2024 (observations)
2. Study dSIDM particle physics models (dark photons)
3. Examine velocity-dependent cross-section constraints
4. Plan combined lensing + satellite analysis
5. Prepare for LSST-era constraints
