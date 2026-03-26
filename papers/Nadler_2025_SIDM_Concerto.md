---
title: "SIDM Concerto: Compilation and Data Release of Self-interacting Dark Matter Zoom-in Simulations"
authors: ["Ethan O. Nadler", "Demao Kong", "Daneng Yang", "Hai-Bo Yu"]
first_author: "Nadler"
year: 2025
journal: "ApJ"
arxiv_id: "2503.10748"
doi: "10.3847/1538-4357/adf553"
topics: [SIDM, dark matter simulations, zoom-in simulations, galaxy halos, subhalo populations]
tags: [SIDM Concerto, velocity-dependent, core collapse, subhalo mass function, density profiles, strong lensing]
status: "digest"
source: "Paper Digest"
type: "paper"
special_request: "Important reference for SIDM research - simulation suite for observational comparisons"
---

## tl;dr

SIDM Concerto is a **public suite of 14 cosmological zoom-in simulations** spanning **4 orders of magnitude in host mass** (LMC to cluster scale) with **ultra-high resolution** (~2×10^7 particles per host). The suite includes CDM and three **strong, velocity-dependent SIDM models** that are compatible with current small-scale structure data and cluster constraints.

**Key scientific findings**:
1. **Core-collapsed fraction peaks** at V_peak ~ 30-60 km/s, corresponding to the transition from v^-4 to v^0 in the SIDM cross-section
2. **Subhalo mass functions suppressed by ~50%** in LMC, MW, and Group hosts (but not in clusters) for GroupSIDM
3. **Subhalo inner density slopes are more diverse** in SIDM than CDM, sensitive to both cross-section amplitude and shape
4. **First demonstration** of the turnover in core-collapsed fraction using cosmological simulations

**Data products**: Publicly available at https://doi.org/10.5281/zenodo.14933624

---

# Part 1: Simulation Suite Overview

## Host Halo Mass Scales

SIDM Concerto includes **6 host halos** at 4 mass scales:

| Host Type | Number | M_host (M⊙) | R_vir (kpc) | m_part (M⊙) | ε (pc h⁻¹) | Purpose |
|-----------|--------|-------------|-------------|-------------|-----------|---------|
| **LMC** | 1 | 10^10.9 | 117 | 6.3×10^3 | 40 | LMC satellites, external LMCs |
| **MW** | 2 | 10^12.0-12.2 | 263-307 | 5.0×10^4 | 80 | MW satellites, external MWs |
| **Group** | 2 | 10^13.1-13.5 | 609-818 | 4.0×10^5 | 170 | Strong lensing (flux ratio & imaging) |
| **L-Cluster** | 1 | 10^14.2 | 1380 | 2.7×10^7 | 600 | Strong & weak lensing |

**Total simulations**: 14 (CDM + SIDM variants)

## Resolution and Coverage

- **Particle count**: ~2×10^7 particles per host
- **Mass resolution**: Probes subhalos down to **10^-5 - 10^-4** times host mass
- **Spatial resolution**: 40-600 pc (softening)
- **Subhalo mass range**: 7 decades (10^6 - 10^13 M⊙)
- **High-resolution region**: ~10× R_vir

## Simulation Code

- **Base code**: Modified GADGET-2 with SIDM module
- **SIDM implementation**: Captures both **velocity and angular dependence** of differential cross-section
- **Initial conditions**: MUSIC (Hahn & Abel 2011) with nested refinement regions
- **Cosmology**: Planck ΛCDM parameters

---

# Part 2: SIDM Models

## Velocity-Dependent Cross-Section

The differential cross-section follows (Ibe & Yu 2010; Yang & Yu 2022):

$$\frac{d\sigma}{d\cos\theta} = \frac{\sigma_0 w^4}{[w^2 + v^2 \sin^2(\theta/2)]^2}$$

where:
- v = relative scattering velocity
- θ = scattering angle
- σ_0 = cross-section amplitude
- w = velocity at which cross-section transitions from v^-4 to v^0 scaling

**Physical motivation**: Light dark photon mediator

## Three SIDM Models

### 1. **GroupSIDM**
- σ_0/m = **147.1 cm²/g**
- w = **120 km/s**

**Designed for**: Group-mass hosts
- Produces extremely dense core-collapsed subhalos (analogous to observed lensing perturbers)
- Produces extremely low-concentration cored isolated halos (analogous to ultra-diffuse galaxies)

### 2. **GroupSIDM-70**
- σ_0/m = **70 cm²/g**
- w = **120 km/s**

**Purpose**: Study impact of varying σ_0 at fixed w

### 3. **MilkyWaySIDM**
- σ_0/m = **147.1 cm²/g**
- w = **24.3 km/s**

**Designed for**: MW-mass hosts
- Diversifies (sub)halo density profiles
- Compatible with MW satellite observations

---

## Effective Cross-Sections

The effective cross-section σ_eff/m as a function of V_max:

| V_max | GroupSIDM | GroupSIDM-70 | MilkyWaySIDM |
|-------|-----------|--------------|--------------|
| 30 km/s | ~100 cm²/g | ~50 cm²/g | ~50 cm²/g |
| 100 km/s | ~20 cm²/g | ~10 cm²/g | ~5 cm²/g |
| 300 km/s | ~2 cm²/g | ~1 cm²/g | ~0.5 cm²/g |

**Key**: At cluster scales (V_max ~ 1000 km/s), all models have σ_eff/m < 1 cm²/g, consistent with cluster constraints!

---

# Part 3: Key Scientific Results

## 1. Core-Collapse Fraction

**Observable**: τ_0 = ρ_s / ρ(3r_s) (central density relative to CDM prediction)

**Definition**:
- τ_0 < 0.15: Core-expansion phase (decreasing central density)
- τ_0 > 0.75: Core-collapsed phase (central density exceeds CDM)

### Key Finding: **Peak in Core-Collapsed Fraction**

**Result**: Core-collapsed fraction peaks at **V_peak ~ 30 km/s** (isolated halos) and **V_peak ~ 60 km/s** (subhalos)

**Physical interpretation**:

The gravothermal collapse timescale:
$$t_c \propto (\sigma_0/m)^{-1} M^{(n-1)/3} c^{(n-7)/2}$$

For **high-mass halos** (n = 4 regime):
$$t_c \propto M c^{-3/2}$$
→ Concentration decreases with mass → t_c **increases** with mass

For **low-mass halos** (n = 0 regime):
$$t_c \propto M^{-0.2}$$
→ t_c **increases** as mass **decreases**

**The peak reflects the transition** from v^-4 to v^0 in the cross-section!

### Host-Mass Dependence

- **LMC hosts**: Lower core-collapsed fraction (less time for evolution)
- **MW hosts**: Intermediate
- **Group hosts**: **Highest** core-collapsed fraction
- **L-Cluster hosts**: **Nearly zero** (σ_eff/m too small at cluster velocities)

---

## 2. Subhalo Mass Function Suppression

**Result**: In GroupSIDM model, subhalo mass functions are **suppressed by ~50%** relative to CDM in LMC, MW, and Group hosts.

**Mechanisms**:
1. **Enhanced tidal disruption**: Cored subhalos are more easily disrupted
2. **Evaporation**: Subhalo-host interactions unbind particles
3. **Both effects** contribute

### Velocity-Dependent Effect

| Host | GroupSIDM | GroupSIDM-70 | MilkyWaySIDM |
|------|-----------|--------------|--------------|
| **LMC** | ~50% suppression | ~40% suppression | ~50% suppression |
| **MW** | ~50% suppression | ~40% suppression | ~30% suppression |
| **Group** | ~50% suppression | ~30% suppression | N/A |
| **L-Cluster** | **Consistent with CDM** | **Consistent with CDM** | **Consistent with CDM** |

**Key insight**: L-Cluster shows **no suppression** because σ_eff/m < 1 cm²/g at cluster velocities!

---

## 3. Subhalo Density Profile Diversity

**Observables**:
- Inner density slope γ (ρ ∝ r^γ)
- Projected enclosed mass M_2D(<R)
- Central density slope

### Key Finding: **Enhanced Diversity**

**CDM**: Subhalo density profiles are relatively uniform (NFW-like, γ ≈ -1)

**SIDM**: Much wider range:
- **Core-expanded**: γ ≈ 0 (flat cores)
- **Core-collapsed**: γ ≈ -1.5 to -2 (steep cusps)

**Dependence on cross-section**:
- **Higher σ_0/m**: More diversity (wider range of slopes)
- **Different w values**: Different mass scales for core-collapse

### Comparison to Observations

**Strong lensing perturbers** (Nadler et al. 2023a):
- Require high central densities
- Consistent with **core-collapsed SIDM subhalos**
- Difficult to explain in CDM without extreme concentration

**Ultra-diffuse galaxies**:
- Require low central densities
- Consistent with **core-expanded SIDM isolated halos**
- Both core-expansion and core-collapse needed!

---

# Part 4: Connection to Your SIDM Research

## Comparison to Previous Papers

| Paper | Year | Type | Key Contribution |
|-------|------|------|------------------|
| **Banerjee et al.** | 2019 | Theory | Weak lensing predictions for cluster profiles |
| **Adhikari et al.** | 2024 | Observations | DES-ACT constraints (σ/m < 1 cm²/g) |
| **SIDM Concerto (this)** | 2025 | **Simulations** | **High-resolution zoom-ins for comparisons** |

**Connection**: SIDM Concerto provides the **simulation infrastructure** to test models against:
1. Weak lensing cluster profiles (Banerjee 2019 predictions)
2. Strong lensing substructure (Nadler et al. 2023a)
3. Satellite galaxy counts
4. Stellar stream perturbers

---

## Implications for Banerjee 2019 Results

**Banerjee 2019 prediction**: Weak lensing profiles can constrain σ/m ~ 1 cm²/g at cluster scales

**SIDM Concerto validation**:
- L-Cluster host (M_h ~ 10^14.2 M⊙) has σ_eff/m < 1 cm/s at cluster velocities
- **Subhalo mass functions consistent with CDM**
- **No core-collapse** in L-Cluster subhalos
- **Confirms** that cluster-scale observables are insensitive to these SIDM models

**Consistent with Adhikari 2024 constraint**: σ/m < 1.05 cm²/g from DES-ACT!

---

## Implications for Strong Lensing

**Observable**: Flux ratio anomalies and gravitational imaging

**SIDM Concerto predictions**:
1. **Group-mass hosts**: ~50% of subhalos are core-collapsed
   - Extremely high central densities
   - Can explain observed lensing perturbers

2. **L-Cluster hosts**: Subhalos are CDM-like
   - No enhanced perturber abundance
   - Consistent with cluster lensing constraints

**Testable prediction**: Strong lensing perturbers should be **more common in group lenses than cluster lenses** in SIDM models!

---

## Applications to Your Research

### For Cluster Weak Lensing (MUST-Relevant)

1. **Cluster-scale predictions**:
   - SIDM effects on cluster profiles are **minimal** (σ_eff/m < 1 cm²/g)
   - Subhalo populations are **CDM-like**
   - **Consistent** with current weak lensing constraints

2. **What MUST can do**:
   - Probe **lower mass clusters** (M_h ~ 10^13.5-10^14 M⊙)
   - These are in the **transition regime** where SIDM effects emerge
   - **Group-scale lenses** are where SIDM signatures are strongest!

### For Strong Lensing

1. **Group vs cluster comparison**:
   - Group lenses: Expect enhanced perturber abundance
   - Cluster lenses: CDM-like perturber abundance
   - **MUST spectroscopic redshifts** can identify group vs cluster lenses

2. **Subhalo density profiles**:
   - Strong lensing imaging can measure subhalo density slopes
   - SIDM predicts more diverse slopes than CDM
   - **Testable with high-resolution imaging**

---

# Part 5: Data Products and Usage

## What's Available

**Repository**: https://doi.org/10.5281/zenodo.14933624

### Simulation Data
- Particle positions, velocities (snapshots)
- Halo catalogs (Rockstar)
- Merger trees (consistent-trees)
- Subhalo properties (mass, V_max, density profiles, etc.)

### Processed Products
- Density profiles
- Subhalo mass functions
- Core-collapse timescales
- Projected mass profiles

### Analysis Code
- Python scripts for loading/analyzing data
- Examples for reproducing paper figures

---

## Recommended Usage for Your Research

### For Weak Lensing Studies

1. **Download L-Cluster simulations**
2. **Measure ΔΣ profiles** from particle distributions
3. **Compare to MUST cluster lensing data**
4. **Constrain σ_eff/m** at cluster velocities

### For Strong Lensing Studies

1. **Download Group simulations**
2. **Identify core-collapsed subhalos** (τ_0 > 0.75)
3. **Compute lensing observables** (flux ratios, image positions)
4. **Compare to observed group lenses**

### For Satellite Galaxy Studies

1. **Download MW simulations**
2. **Apply luminosity–halo mass relation**
3. **Predict satellite abundance and radial distribution**
4. **Compare to MW/M31 satellite data**

---

# Part 6: Future Prospects

## Upcoming Observational Tests

### 1. **Strong Lensing Perturbers** (Next 1-3 years)

**Observatories**: JWST, HST, ALMA, Rubin

**Prediction**: Group lenses should show enhanced perturber abundance vs cluster lenses

**Test**: Compare perturber statistics in samples of group vs cluster lenses

### 2. **Satellite Galaxy Diversity** (Next 2-5 years)

**Surveys**: LSST, Roman, Euclid

**Prediction**: Satellite galaxies around MW-mass hosts should show diverse central densities

**Test**: Measure satellite density profiles from IFU surveys

### 3. **Stellar Stream Perturbers** (Next 2-5 years)

**Surveys**: Gaia, LSST, Roman

**Prediction**: GD-1-like perturbers are core-collapsed SIDM subhalos

**Test**: Measure perturber masses and densities from stream gaps

### 4. **Weak Lensing at Group Scale** (Next 5-10 years)

**Surveys**: LSST, Euclid, Roman

**Prediction**: Group-scale lenses may show SIDM signatures (enhanced profiles, subhalo suppression)

**Test**: Stack weak lensing profiles of group-scale lenses

---

## MUST's Unique Role

### Why MUST is Important

1. **Group-scale spectroscopy**:
   - Identify group vs cluster lenses
   - Measure group halo masses
   - **Critical for testing SIDM predictions** (where effects are strongest)

2. **High-redshift clusters**:
   - Probe evolution of SIDM effects
   - Test if core-collapse fraction evolves with redshift

3. **Large sample size**:
   - Statistical studies of cluster vs group lensing
   - Subdividing by host mass, redshift, environment

### Recommended MUST Survey Strategy

1. **Target selection**: Focus on **group-scale lenses** (M_h ~ 10^13-10^13.5 M⊙)
2. **Redshift coverage**: z ~ 0.1-0.5 (balance of statistics and evolution)
3. **Complementary data**: LSST imaging for weak lensing shapes
4. **Analysis**: Compare to SIDM Concerto Group simulations

---

## Open Questions

1. **Baryonic effects**: How do baryons modify SIDM core-collapse?
2. **Redshift evolution**: Does core-collapse fraction evolve?
3. **Environment dependence**: How does environment affect SIDM evolution?
4. **Dissipative SIDM**: Can dSIDM models (Adhikari 2024) be tested with these simulations?

---

# Part 7: Summary

## Key Takeaways

1. **SIDM Concerto is a public, high-resolution simulation suite** spanning LMC to cluster scales
2. **Three velocity-dependent SIDM models** that are compatible with all current constraints
3. **Core-collapsed fraction peaks** at V_peak ~ 30-60 km/s (first cosmological demonstration)
4. **Subhalo mass functions suppressed by ~50%** in LMC/MW/Group, but not in clusters
5. **Density profile diversity enhanced** in SIDM, sensitive to cross-section shape
6. **Data publicly available** for community comparisons

## Connection to Your Research Stack

| Paper | Role | How to Use SIDM Concerto |
|-------|------|-------------------------|
| **Banerjee 2019** | Weak lensing theory | Compare L-Cluster profiles to predictions |
| **Adhikari 2024** | Observations | Validate constraints using L-Cluster simulations |
| **SIDM Concerto** | **Simulations** | **Benchmarks for all observational tests** |

---

## Follow-up Discussion

(Reserved for future questions and analysis)

**Your next steps**:
1. Download SIDM Concerto data for L-Cluster and Group simulations
2. Measure weak lensing profiles and compare to Banerjee 2019 predictions
3. Study subhalo populations in Group hosts for strong lensing applications
4. Plan MUST observations of group-scale lenses
