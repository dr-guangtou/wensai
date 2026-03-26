---
title: Signatures of Self-Interacting Dark Matter on Cluster Density Profile and Subhalo Distributions
authors:
  - Arka Banerjee
  - Susmita Adhikari
  - Neal Dalal
  - Surhud More
  - Andrey Kravtsov
first_author: Banerjee
year: 2019
journal: JCAP (submitted)
arxiv_id: "1906.12026"
doi: N/A
topics:
  - dark matter
  - self-interacting dark matter
  - weak lensing
  - cluster halos
  - splashback radius
tags:
  - astro/lensing
  - astro/cluster
  - astro/dark_matter
  - astro/splashback
  - asrto/sidm
status: digest
source: Paper Digest
type: paper
special_request: Detailed summary for research investigation - focus on SIDM basic concepts
---

## tl;dr

This paper presents the **first comprehensive study of SIDM signatures on cluster-scale halo profiles using large cosmological simulations**. The authors investigate how self-interacting dark matter (SIDM) affects:
1. **Central density profiles** (core formation)
2. **Subhalo distributions** (tidal disruption enhancement)
3. **Splashback radius** (halo boundary)
4. **Halo shapes** (rounding effect)

Key finding: **Current DES-Y1 weak lensing data already constrain σ/m < 2 cm²/g**, comparable to Bullet Cluster limits. Future LSST data will reach σ/m ~ 1 cm²/g, making **cluster halo profiles competitive probes of dark matter physics**.

The study explores both **velocity-independent** and **velocity-dependent** cross-sections, as well as **isotropic vs anisotropic scattering**, finding that combined measurements of particle profiles (via lensing) and subhalo distributions (via galaxy counts) can **break degeneracies** between different SIDM models.

---

# Part 1: SIDM Fundamentals

## What is Self-Interacting Dark Matter (SIDM)?

### The Problem with Cold Dark Matter

The ΛCDM paradigm is extremely successful on large scales (CMB, large-scale structure), but faces several **small-scale tensions**:

| Problem | Description | Scale |
|---------|-------------|-------|
| **Core-cusp** | Dwarf galaxies show flat central cores, not cuspy NFW profiles | ~kpc |
| **Too-big-to-fail** | Massive MW subhalos are too dense compared to bright dwarfs | ~10 kpc |
| **Missing satellites** | Fewer observed satellites than predicted | ~100 kpc |
| **Diversity problem** | Rotation curve diversity at fixed halo mass | ~1-10 kpc |

### The SIDM Solution

**Basic idea** (Spergel & Steinhardt 2000): Dark matter particles can **scatter elastically** off each other via non-gravitational forces.

**Mechanism:**
1. Particles in high-density regions (center of halos) have **more collisions**
2. Collisions **exchange energy** → heat flows from hot (outer) to cold (inner) regions
3. Inner particles gain energy → **orbits expand** → **central density decreases**
4. Result: **Cores form** instead of cusps

### Key Parameter: Cross-Section per Unit Mass

The strength of SIDM is characterized by **σ/m**:

$$\frac{\sigma}{m} \sim \text{cm}^2/\text{g}$$

**Reference scales:**
| σ/m | Effect | Constraint |
|-----|--------|------------|
| **~1 cm²/g** | Can create kpc-scale cores in dwarfs | Target for small-scale problems |
| **< 0.1 cm²/g** | Negligible effects | Essentially CDM |
| **> 10 cm²/g** | Cores in cluster halos | Ruled out by observations |
| **~2 cm²/g** | Upper limit from Bullet Cluster | Current constraint |

### Why cm²/g is Interesting

1. **Nuclear physics scale**: σ ~ barn (10⁻²⁴ cm²) for nucleons
2. **For m ~ 1 GeV**: σ/m ~ 10⁻²⁴ cm² / 10⁻²⁴ g ~ 1 cm²/g
3. **Natural scale** for GeV-mass particles with strong interactions

---

## Types of SIDM Models

### 1. Isotropic, Velocity-Independent

**Simplest case**: Hard-sphere scattering
- Cross-section: $\frac{d\sigma}{d\Omega} = \text{const}$
- No velocity dependence
- Equal probability for all scattering angles

**Implementation in simulations:**
- When particles come within interaction radius $h_{SI}$:
- Probability of interaction: $P_{ij} = \frac{\sigma}{m_i} \cdot \frac{1}{v_{rel}} \cdot g_{ij} \cdot \Delta t$
- If interaction occurs: scatter by random angle θ ∈ [0, π/2]

### 2. Anisotropic, Velocity-Independent

**Motivation**: Light mediator particles (dark photons, etc.)

**Cross-section form**:
$$\frac{d\sigma}{d\Omega} \propto \frac{1 + \cos^2\theta}{1 - \cos^2\theta}$$

**Key features:**
- **Diverges** at small angles (cos θ → 1)
- **Forward-scattering dominates** (small momentum transfer)
- More "drag" than "evaporation"

**Momentum transfer cross-section**:
$$\sigma_T = \int \frac{d\sigma}{d\Omega} (1 - \cos\theta) d\Omega$$

This is **finite** even when σ diverges.

**Physical effects:**
- **Drag**: Subhalo moving through host experiences friction-like force
- **Evaporation**: Subhalo particles get unbound by collisions
- Anisotropic models enhance drag vs evaporation

### 3. Velocity-Dependent

**Motivation**: Light mediators with mass $m_\phi$

**Cross-section form** (Yukawa-like):
$$\frac{\sigma}{m} = \frac{\sigma_0}{m} \cdot \frac{1}{1 + (v_{rel}/w)^2}$$

where:
- $\sigma_0/m$ = low-velocity cross-section
- $w$ = velocity scale related to mediator mass
- $v_{rel}$ = relative velocity

**Key features:**
- **Low velocities** (dwarfs): High cross-section → core formation
- **High velocities** (clusters): Low cross-section → minimal effects
- **Naturally explains** why cores exist in dwarfs but not clusters

**Velocity scales:**
| Object | Velocity scale | Effect |
|--------|----------------|--------|
| Dwarf galaxies | ~50 km/s | Strong SIDM effects |
| Galaxy groups | ~300 km/s | Moderate effects |
| Galaxy clusters | ~1000 km/s | Weak effects (if velocity-dependent) |

---

## Physical Effects of SIDM

### 1. Core Formation

**Mechanism**: Thermal conduction
- Particles in high-density center have more collisions
- Energy flows from hot outer regions to cold center
- Central particles heat up → orbits expand → density drops

**Timescale**:
$$t_{core} \sim \frac{1}{\rho \cdot (\sigma/m) \cdot v}$$

**Result**: Isothermal core with $\rho \propto r^0$ instead of $\rho \propto r^{-1}$

### 2. Subhalo Evaporation

**Mechanism**: Subhalo particles scatter with host particles
- If scattered particle gains energy > binding energy → unbound
- Subhalo mass decreases over time

**Rate**:
$$\frac{dM}{dt} \propto \rho_{host} \cdot (\sigma/m) \cdot v_{rel}$$

**Result**: Subhaloes disrupted faster than CDM, especially those on radial orbits passing through center.

### 3. Subhalo Drag

**Mechanism**: Non-head-on collisions transfer momentum
- Creates dynamical friction-like force
- Subhalo loses orbital energy → spirals inward

**Effect**: Displaces galaxy from subhalo center (observable with lensing + optical)

### 4. Halo Rounding

**Mechanism**: Collisions isotropize velocity distribution
- Elongated halos become rounder
- Axis ratios increase toward unity

### 5. Splashback Radius Shift

**Splashback radius** ($R_{sp}$): Location of minimum slope in density profile

**CDM**: Set by largest apocenters of first-orbit material

**SIDM effects:**
- Subhalos on radial orbits (which would have largest apocenters) are **disrupted first**
- Splashback moves **inward** by ~20% for σ/m ~ 3 cm²/g

---

# Part 2: Simulation Details

## Simulation Setup

**Code**: Modified GADGET-2 with SIDM module

**Implementation**:
1. Tree-walk identifies particle pairs within $h_{SI}$
2. Compute interaction probability: $P_{ij} = \frac{\sigma}{m_i} \cdot \frac{g_{ij}}{v_{rel}} \cdot \Delta t$
3. If random number < P: scatter particles
4. Communication: velocities exchanged between processors

**Box size**: 256 h⁻¹ Mpc (large enough for statistical sample of clusters)

**Mass resolution**: $3.4 \times 10^8$ h⁻¹ M⊙

**Halo finder**: Rockstar

## SIDM Models Simulated

| Model | σ/m (cm²/g) | Type | Notes |
|-------|-------------|------|-------|
| CDM | 0 | - | Fiducial |
| SIDM-iso-1 | σ/m = 1 | Isotropic | Standard |
| SIDM-iso-2 | σ/m = 2 | Isotropic | Strong |
| SIDM-aniso-1 | σT/m = 1 | Anisotropic | Drag-enhanced |
| SIDM-aniso-3 | σT/m = 3 | Anisotropic | Very strong |
| SIDM-vdep-1 | σ0/m = 10, w=500, u=1000 | Velocity-dependent | Cluster-suppressed |
| SIDM-vdep-2 | σ0/m = 10, w=1000, u=2000 | Velocity-dependent | Intermediate |
| SIDM-vdep-3 | σ0/m = 10, w=1600, u=2000 | Velocity-dependent | Mild |

---

# Part 3: Key Results

## 1. Stacked Density Profiles

**Sample**: Clusters in mass range $1-2 \times 10^{14}$ h⁻¹ M⊙

### Central Regions (r < 200 kpc)

- **Isotropic SIDM (σ/m = 1 cm²/g)**: ~10% density reduction at r ~ 100 kpc
- **Isotropic SIDM (σ/m = 2 cm²/g)**: ~20% density reduction
- **Anisotropic (σT/m = 1 cm²/g)**: Similar to isotropic σ/m = 2
- **Velocity-dependent**: Smaller effects at cluster scales

### Outer Regions (r ~ Rsp)

- Density differences extend to **splashback radius**
- Early-forming halos (high concentration): Larger SIDM effects
- Late-forming halos: Smaller differences

**Key insight**: SIDM effects are **not limited to the core** — they propagate to Rsp!

---

## 2. Splashback Radius

**Measurement**: Minimum of logarithmic slope, d ln ρ / d ln r

### Particle Splashback

**CDM**: $R_{sp} \approx 0.9$ h⁻¹ Mpc for clusters

**SIDM effects**:
- **Velocity-independent**: Rsp decreases by ~10-20% for strong interactions
- **Velocity-dependent**: No significant change at cluster velocities
- **Early-forming halos**: Larger Rsp shift
- **Late-forming halos**: Minimal change

### Subhalo Splashback

**CDM**: Similar to particle splashback

**SIDM**: Rsp decreases by ~20% for σT/m = 3 cm²/g

**Mechanism**: Subhalos on radial orbits (which define splashback) are **preferentially destroyed** by SIDM

---

## 3. Subhalo Distributions

### Number Density Profiles

**Observation**: Subhalo profiles suppressed out to virial radius

**Magnitude**:
- σT/m = 1 cm²/g: ~10% suppression at r ~ 500 kpc
- σT/m = 3 cm²/g: ~20% suppression

**Velocity-dependent models**:
- **Paradox**: Strong suppression even when cluster-scale σ/m < 1 cm²/g!
- **Reason**: High σ/m at **subhalo internal velocity scales** (~50 km/s)
- Subhalos are **less bound** before infall → easier disruption

### Degeneracy Breaking

**Problem**: Velocity-dependent and velocity-independent models can give similar subhalo profiles

**Solution**: Combine with **particle density profiles** (from lensing)
- Lensing: Sensitive to cluster velocity scale (~1000 km/s)
- Subhalo counts: Sensitive to subhalo velocity scale (~50-200 km/s)
- **Together**: Break degeneracy!

---

## 4. Weak Lensing Constraints

### Observable: ΔΣ (Excess Surface Density)

$$\Delta\Sigma(R) = \bar{\Sigma}(<R) - \Sigma(R)$$

where:
- $\Sigma(R)$ = projected 2D mass density at radius R
- $\bar{\Sigma}(<R)$ = mean surface density within R

### Current Data: DES Year 1

**Statistical uncertainty**: ~10% on scales of interest (R ~ 0.5-3 h⁻¹ Mpc)

**Constraints**:
- σ/m ~ 2 cm²/g produces ~20% signal
- **DES-Y1 errors comparable to σ/m = 2 cm²/g signal**
- Current constraints: **σ/m < 2 cm²/g** (comparable to Bullet Cluster!)

### Future Prospects

| Survey | Cluster count | Expected error | Cross-section reach |
|--------|---------------|----------------|---------------------|
| DES-Y3 | 3× DES-Y1 | ~6% | σ/m ~ 1.5 cm²/g |
| HSC | Deeper | ~5% | σ/m ~ 1 cm²/g |
| LSST | ~10⁵ clusters | ~2% | **σ/m ~ 0.5 cm²/g** |

**Key point**: Stacked weak lensing can **compete with Bullet Cluster** and probe lower cross-sections!

---

## 5. Halo Shapes

**Measurement**: Axis ratios from unweighted quadrupole tensor

**Results**:
- **CDM**: λ₂/λ₁ ~ 0.6, λ₃/λ₁ ~ 0.4 at r ~ 500 kpc
- **SIDM**: Both ratios increase (halos become rounder)
- Effect increases with radius
- Velocity-dependent models show similar rounding

---

# Part 4: Observational Signatures Summary

## Observable Effects at Different Radii

| Radius | Observable | CDM | SIDM signature |
|--------|-----------|-----|----------------|
| **r < 100 kpc** | Core density | Cusp (ρ ∝ r⁻¹) | Core (ρ ∝ const) |
| **r ~ 200-500 kpc** | Lensing ΔΣ | NFW profile | ~10-20% lower |
| **r ~ Rsp** | Splashback location | Rsp ~ 0.9 Mpc | Rsp reduced by 10-20% |
| **r < Rvir** | Subhalo counts | NFW-like profile | 10-20% suppression |
| **All r** | Halo shape | Triaxial | Rounder |

---

## Comparison to Bullet Cluster

**Bullet Cluster constraint**: σ/m < 2 cm²/g

**Mechanism**: DM-galaxy offset in merging cluster

**Limitations**:
- Single system
- Sensitive to one velocity scale
- High-velocity encounter

**Cluster profile advantages**:
- Statistical sample (thousands of clusters)
- Sensitive to range of velocity scales
- Probes both particles and subhalos
- **Comparable constraint already with DES-Y1!**

---

# Part 5: Future Directions

## Combining Probes

**Optimal strategy**:
1. **Weak lensing** → Particle density profile
2. **Galaxy counts** → Subhalo distribution
3. **Splashback measurement** → Rsp shift
4. **Halo shapes** → Rounding effect

**Together**: Can distinguish between:
- Velocity-dependent vs independent
- Isotropic vs anisotropic
- Different σ/m values

## Observational Requirements

| Requirement | Current | Needed |
|-------------|---------|--------|
| **Cluster sample** | ~10³ | ~10⁴-10⁵ |
| **Lensing S/N** | ~10% | ~2% |
| **Redshift accuracy** | Photometric | Spectroscopic helps |
| **Centering accuracy** | BCG-based | < 10 kpc |

## Systematics to Control

1. **Miscentering**: Can mimic SIDM core signal
2. **Projection effects**: Along line-of-sight structures
3. **Baryonic physics**: Can also create cores
4. **Mass-concentration relation**: Affects profile shape
5. **Halo mass calibration**: Critical for lensing

---

# Part 6: Key Takeaways for Your Research

## Why Cluster-Scale SIDM Studies Matter

1. **Complementary to dwarf galaxies**: Clusters probe high-velocity regime
2. **Large statistical samples**: Surveys provide thousands of clusters
3. **Multiple observables**: Profiles, subhalos, splashback, shapes
4. **Systematics different** from dwarf galaxy studies
5. **Future surveys**: LSST, Euclid, Roman will provide unprecedented data

## Practical Considerations

### For Weak Lensing Analysis

1. **Stack clusters** in narrow mass bins to reduce scatter
2. **Measure ΔΣ** out to R ~ 3 h⁻¹ Mpc (beyond splashback)
3. **Fit parametric models** with SIDM modifications
4. **Control systematics**: miscentering, photo-z errors, shape noise

### For Subhalo Studies

1. **Use satellite galaxies** as subhalo tracers
2. **Measure radial profiles** around clusters
3. **Account for orphan galaxies** (subhalos below resolution)
4. **Model HOD** carefully

### For Splashback Measurements

1. **Identify splashback** from minimum of d ln ρ / d ln r
2. **Stack by concentration/age** to enhance SIDM signal
3. **Compare particle splashback** (lensing) vs **galaxy splashback** (counts)
4. **3D measurements** (kinematics) more powerful than 2D

---

## Recommended Reading

**Foundational SIDM papers:**
- Spergel & Steinhardt (2000): Original SIDM proposal
- Kaplinghat et al. (2016): SIDM review
- Tulin & Yu (2018): Comprehensive review

**Cluster-scale studies:**
- Rocha et al. (2013): SIDM simulations methodology
- Robertson et al. (2017): Bullet Cluster constraints
- This paper: First large-box cosmological SIDM study

**Observational constraints:**
- Harvey et al. (2015): DM-galaxy offsets
- Chang et al. (2018): DES splashback + lensing
- Shin et al. (2018): SZ-selected cluster splashback

---

## Summary Table: SIDM vs CDM

| Property | CDM | SIDM (σ/m ~ 1 cm²/g) |
|----------|-----|---------------------|
| **Central density** | Cuspy (ρ ∝ r⁻¹) | Cored (ρ ∝ const) |
| **Core radius** | ~0 | ~50-100 kpc (clusters) |
| **Subhalo survival** | Tidal disruption only | Tidal + evaporation |
| **Subhalo profile** | NFW-like | 10-20% suppressed |
| **Splashback radius** | Rsp ~ 0.9 Mpc | Rsp reduced 10-20% |
| **Halo shape** | Triaxial (λ₂/λ₁ ~ 0.6) | Rounder (λ₂/λ₁ ~ 0.7) |
| **Observable in lensing** | Standard NFW | ~10% lower ΔΣ |

---

## Follow-up Discussion

(Reserved for future questions and investigation)

**Your next steps:**
1. Review Tulin & Yu (2018) for particle physics motivations
2. Study Rocha et al. (2013) for simulation methodology
3. Examine DES/HSC splashback measurements for observational techniques
4. Consider combining lensing + satellite counts for joint constraints
