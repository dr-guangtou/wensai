---
title: "Assessing Mass Loss and Stellar-to-Halo Mass Ratio of Satellite Galaxies: A Galaxy-Galaxy Lensing Approach Utilizing DECaLS DR8 Data"
authors: ["Chunxiang Wang", "Ran Li", "Huanyuan Shan", "Weiwei Xu", "Ji Yao", "Yingjie Jing", "Liang Gao", "Nan Li", "Yushan Xie", "Kai Zhu", "Hang Yang", "Qingze Chen"]
first_author: "Wang"
year: 2024
journal: "MNRAS"
arxiv_id: "2305.13694"
doi: "10.1093/mnras/stad4186"
topics: [galaxy-galaxy lensing, satellite galaxies, subhalo mass, tidal stripping, cluster environment]
tags: [g-g lensing, DECaLS, redMaPPer, subhalo, SHMR, mass loss, tidal stripping, cluster satellites]
status: "digest"
source: "Paper Digest"
type: "paper"
special_request: "Understand the concept of using g-g lensing signals of cluster members in different radial bins"
---

## tl;dr

This paper presents an elegant method to measure **subhalo mass loss of satellite galaxies** using **galaxy-galaxy lensing** with **DECaLS DR8** weak lensing data and **redMaPPer** cluster catalog. The key innovation is **binning satellite galaxies by their projected cluster-centric distance (Rp)** and measuring their g-g lensing signals separately.

**Main findings**:
1. **Stellar-to-halo mass ratio (SHMR) increases with Rp**: From 4.9 at Rp ~ 0.13 Mpc/h to 77 at Rp ~ 1.12 Mpc/h, indicating dramatic mass loss in the inner regions
2. **Mass loss depends on satellite stellar mass**: U-shaped variation with minimum at M* ~ 4×10^10 M⊙
3. **High-mass satellites lose more**: M* > 10^11 M⊙ experience 86% mass loss at Rp = 0.5 R_200c
4. **Discrepancy with IllustrisTNG**: Observed SHMR in outskirts is ~5× higher than simulation predictions
5. **First measurement** of dark matter strip rate variation with Rp using lensing

---

# Part 1: The Core Concept

## Why This Method is Clever

### The Problem

When a galaxy falls into a cluster, it becomes a **satellite** and its dark matter halo experiences:
1. **Tidal stripping**: Outer dark matter is removed by cluster tidal field
2. **Tidal heating**: Energy injection disrupts orbits
3. **Dynamical friction**: Satellite spirals inward
4. **Ram pressure stripping**: Gas removed

**Challenge**: How to measure the **remaining subhalo mass** around satellite galaxies?

### Traditional Methods

| Method | Pros | Cons |
|--------|------|------|
| **Strong lensing** | Individual subhalo masses | Rare, biased to central regions |
| **Satellite kinematics** | Statistical | Requires spectroscopy, modeling |
| **Abundance matching** | Simple | Model-dependent, indirect |
| **Simulations** | Full evolution | Needs calibration |

### The Galaxy-Galaxy Lensing Approach

**Key insight**: Measure **stacked weak lensing signal** around satellite galaxies binned by **projected cluster-centric distance Rp**.

**Why binning by Rp?**
- Satellites at **larger Rp** have fallen in **more recently**
- Satellites at **smaller Rp** have experienced **more tidal stripping**
- By measuring SHMR vs Rp, we can **directly observe mass loss evolution**!

**Observable**: Excess surface density ΔΣ(R) around satellites in each Rp bin

**Fit**: Three-component model:
1. **Subhalo contribution** (NFW profile): ΔΣ_sub(R)
2. **Host halo contribution** (cluster mass): ΔΣ_host(R, Rp)
3. **Stellar contribution** (satellite galaxy): ΔΣ_star(R)

---

# Part 2: Methodology in Detail

## Data Sources

### Lenses: Satellite Galaxies

**Cluster catalog**: redMaPPer v6.3 (SDSS DR8)
- **Selection criteria**:
  - Richness λ > 20
  - Redshift 0.1 < z < 0.5
  - Membership probability P_mem > 0.8
  - Stellar mass 10^10 < M*/M⊙ < 10^12

**Sample**: ~230,000 satellite galaxies in 26,111 clusters

### Sources: Background Galaxies

**Shear catalog**: DECaLS DR8
- **Area**: 9,500 deg²
- **Shape measurements**: Metacalibration
- **Photo-z**: From SED fitting (σ_z = 0.017)

---

## Binning Strategy

### Radial Bins (Main Analysis)

Divide satellites by **comoving projected cluster-centric distance Rp**:

| Rp Range | N_lenses | <Rp> (cMpc/h) | <R_pp> (Mpc/h) | <M*> (M⊙/h) |
|----------|----------|---------------|----------------|-------------|
| 0.1-0.25 | 82,501 | 0.17 | 0.13 | 4.9×10^10 |
| 0.25-0.47 | 90,250 | 0.35 | 0.26 | 5.1×10^10 |
| 0.47-0.70 | 41,047 | 0.57 | 0.44 | 5.9×10^10 |
| 0.70-0.80 | 8,071 | 0.75 | 0.59 | 6.2×10^10 |
| 0.80-1.00 | 7,997 | 0.88 | 0.71 | 6.5×10^10 |
| 1.00-2.00 | 3,191 | 1.12 | 0.89 | 6.8×10^10 |

**Key**: As Rp increases, satellites are less stripped → higher subhalo mass → higher SHMR

### Stellar Mass Bins (Secondary Analysis)

Divide by M* to study stellar mass dependence:

| log(M*/M⊙/h) | N_lenses | <M*> (M⊙/h) |
|--------------|----------|-------------|
| 10.0-10.3 | 42,186 | 1.5×10^10 |
| 10.3-10.5 | 51,329 | 2.6×10^10 |
| 10.5-10.7 | 51,736 | 4.0×10^10 |
| 10.7-11.0 | 57,828 | 6.9×10^10 |
| 11.0-11.5 | 26,241 | 1.5×10^11 |

---

## Lensing Model

### Observable: ΔΣ(R)

$$\Delta\Sigma(R) = \Delta\Sigma_{sub}(R) + \Delta\Sigma_{host}(R, R_p) + \Delta\Sigma_{star}(R)$$

where:
- R = projected distance from satellite (lensing radius)
- Rp = projected distance from cluster center (binning variable)

### Component 1: Subhalo (NFW Profile)

$$\rho(r) = \frac{\rho_{crit} \delta_c}{(r/r_s)(1 + r/r_s)^2}$$

**Free parameters**:
- M_200m = subhalo mass (within R_200m)
- C_200m = concentration

**Subhalo radius** r_sub:
- Defined where subhalo density equals cluster background density
- Accounts for tidal truncation

### Component 2: Host Halo (Cluster Contribution)

Cluster mass profile contributes to lensing signal at satellite position:
$$\Delta\Sigma_{host}(R, R_p) = \Sigma_{host}(<R) - \Sigma_{host}(R)$$

**Model**: NFW profile with M_200m,host and C_200m,host

**Normalization**: Free parameter α accounts for:
- Satellite spatial distribution within cluster
- Projection effects
- Model uncertainties

### Component 3: Stellar Mass

$$\Delta\Sigma_{star}(R) = \frac{M_*}{2\pi R^2}$$

**Assumption**: Point mass (stellar mass << subhalo mass)

---

## Fitting Procedure

1. **Stack tangential shear** around all satellites in each Rp bin
2. **Compute ΔΣ(R)** from R = 0.05 to 1.75 Mpc/h
3. **Fit 3-component model** via χ² minimization
4. **Free parameters**: M_200m,sub, C_200m,sub, α
5. **Covariance**: Jackknife resampling (100 regions)

**Key output**: M_enh = subhalo mass within r_sub ("enhanced" subhalo mass)

---

## Mass Loss Rate Calculation

**Definition**:
$$\tau_{strip} = 1 - \frac{M_{enh}}{M_{DM,field}}$$

where M_DM,field is the **expected dark matter mass** for a field galaxy of the same stellar mass.

**Field SHMR relation**: From abundance matching (Shan et al. 2017):
$$M_{DM,field} = f(M_*)$$

**Interpretation**:
- τ_strip = 0: No mass loss (field galaxy)
- τ_strip = 0.5: 50% dark matter stripped
- τ_strip = 1: 100% dark matter stripped (only stars remain)

---

# Part 3: Key Scientific Results

## 1. SHMR Increases with Rp

**Main result**: Stellar-to-halo mass ratio **increases dramatically** with projected cluster-centric distance:

| Rp (Mpc/h) | SHMR (M_enh/M*) | τ_strip |
|------------|-----------------|---------|
| 0.13 | 4.9 ± 1.1 | 0.94 ± 0.01 |
| 0.26 | 16.9 ± 2.9 | 0.78 ± 0.03 |
| 0.44 | 30.3 ± 7.1 | 0.66 ± 0.07 |
| 0.59 | 47.6 ± 15.3 | 0.57 ± 0.12 |
| 0.71 | 65.5 ± 18.4 | 0.42 ± 0.14 |
| 0.89 | 76.8 ± 36.5 | 0.24 ± 0.29 |

**Physical interpretation**:
- **Inner satellites** (Rp ~ 0.13 Mpc/h): Only 4.9 M_DM per M* → **94% of dark matter stripped!**
- **Outer satellites** (Rp ~ 0.89 Mpc/h): 77 M_DM per M* → Approaching field values
- **Trend**: Continuous mass loss as satellites sink toward cluster center

**Comparison to previous work**:
- Li et al. (2016a): Similar trend, lower S/N
- Niemiec et al. (2017): ~70-80% average strip rate (no Rp dependence measured)
- This work: **Higher S/N, first Rp-resolved measurement**

---

## 2. Mass Loss Depends on Satellite Stellar Mass

### High-Mass vs Low-Mass Satellites

**Split sample**: High-M* (M* ~ 1.5×10^11 M⊙) vs Low-M* (M* ~ 4×10^10 M⊙)

**Result at Rp = 0.13 Mpc/h**:
- **High-M***: SHMR = 6.9, τ_strip = 0.96
- **Low-M***: SHMR = 4.7, τ_strip = 0.85

**Key finding**: **High-mass satellites lose MORE dark matter** at the same Rp!

**At Rp = 0.5 R_200c**:
- **High-M***: 86% mass loss
- **Low-M***: ~60% mass loss

**Why?**
1. **Larger subhalos** experience stronger tidal forces
2. **More extended dark matter** is easier to strip
3. **Dynamical friction** causes faster orbital decay

### U-Shaped Dependence on M*

When **averaging over all Rp**, strip rate shows **U-shaped dependence** on stellar mass:

| log(M*/M⊙/h) | <τ_strip> |
|--------------|-----------|
| 10.2 | 0.76 ± 0.17 |
| 10.4 | 0.62 ± 0.13 |
| **10.6** | **0.59 ± 0.10** (minimum) |
| 10.8 | 0.77 ± 0.04 |
| 11.2 | 0.91 ± 0.02 |

**Minimum** at M* ~ 4×10^10 M⊙

**Interpretation**:
- **Low-M* satellites**: Already have low halo masses → less to lose
- **High-M* satellites**: Extended halos → easily stripped
- **Intermediate**: Sweet spot where subhalo is compact enough to resist stripping

---

## 3. Comparison to Simulations

### IllustrisTNG Discrepancy

**Comparison**: Observed SHMR vs TNG300 simulation

**Key findings**:
1. **Outskirts** (Rp > 0.8 Mpc/h):
   - Observation: SHMR ~ 70
   - TNG300 prediction: SHMR ~ 15
   - **Discrepancy: Factor of ~5!**

2. **Inner regions** (Rp < 0.3 Mpc/h):
   - Better agreement (both show low SHMR)

3. **M* dependence**:
   - Observation: Strong dependence on M*
   - TNG300: No clear dependence

**Possible explanations**:
- **Baryonic effects**: AGN feedback, stellar feedback in TNG may be too strong
- **Resolution**: TNG may not resolve stripped subhalos properly
- **Sample selection**: redMaPPer satellites vs TNG satellite definition
- **Cluster mass**: Different host mass distributions

### Phoenix Simulation Agreement

**Phoenix simulation** (Gao et al. 2012):
- Dark matter only
- High-resolution cluster resimulations

**Agreement**: Observed strip rate vs Rp **broadly consistent** with Phoenix predictions (Xie & Gao 2015)

**Implication**: **Dark matter physics is correct**, but baryonic effects in IllustrisTNG may be problematic

---

# Part 4: Technical Considerations

## Advantages of This Method

### 1. High Signal-to-Noise

**DECaLS DR8**: 9,500 deg², ~230,000 satellites
- **Previous work**: CS82 (Li et al. 2016a) had 165 deg²
- **Improvement**: ~60× more area!

**Result**: Factor of ~√60 ≈ 8× better S/N

### 2. Radial Resolution

**6 Rp bins** vs previous work with 2-3 bins
- Reveals **continuous evolution** of SHMR with Rp
- First measurement of **mass loss profile**

### 3. Clean Sample

**Membership probability P_mem > 0.8**:
- Removes foreground/background contamination
- Reduces systematic errors

---

## Systematics and Caveats

### 1. Projected vs 3D Cluster-Centric Distance

**Problem**: We measure **projected** Rp, but mass loss depends on **3D** R_3d

**Conversion**: Statistical deprojection assuming NFW satellite distribution

**Model**:
$$R_{3d} = \frac{\int_{-a}^{+a} r \rho(r) dz}{\int_{-a}^{+a} \rho(r) dz}$$

where a = √(3R_200m,host² - Rp²)

**Uncertainty**: ±30% in R_3d for individual satellites

### 2. Subhalo Mass Definition

**Challenge**: Subhalo boundary is ambiguous when outer parts are stripped

**Definition used**: r_sub = radius where ρ_sub(r_sub) = ρ_background

**Alternative definitions**:
- M_200m (within R_200m): Less physically meaningful for stripped halos
- M_bound: Mass of bound particles (requires simulation)

**Impact**: Different definitions change absolute SHMR values by factor ~2

### 3. Host Halo Contamination

**Problem**: Cluster's dark matter contributes to ΔΣ at satellite position

**Solution**: Include ΔΣ_host in model with free normalization α

**Residual uncertainty**: ~10-20% in inner bins

### 4. Miscentering

**Problem**: redMaPPer center galaxy may not be true cluster center

**Impact**: Affects Rp calculation, host halo model

**Mitigation**: Use brightest cluster galaxy (BCG) as center

---

# Part 5: Comparison to Related Work

## Summary of GGL Satellite Studies

| Study | Survey | Area | Method | Key Finding |
|-------|--------|------|--------|-------------|
| **Li et al. 2014** | CS82 | 165 deg² | GGL satellites in groups | First satellite GGL |
| **Li et al. 2016a** | CS82+redMaPPer | 165 deg² | GGL satellites in clusters | SHMR increases with Rp |
| **Sifón et al. 2015** | GAMA | 180 deg² | GGL satellites | Mass loss but no Rp dependence |
| **Niemiec et al. 2017** | CFHTLenS+CS82+DES-SV | 500 deg² | GGL redMaPPer satellites | 70-80% average strip rate |
| **Sifón et al. 2018** | MENeaCS | 80 deg² | GGL satellites | Discontinuity in SHMR vs Rp |
| **Dvornik et al. 2020** | KiDS+GAMA | 1000 deg² | GGL central+satellite | 20-50% SHMR shift |
| **This work** | DECaLS+redMaPPer | 9500 deg² | GGL satellites | **High S/N, Rp-resolved, M* dependence** |

**Key advance**: This work has **highest S/N** and **most detailed Rp resolution**

---

## Why Previous Results Disagreed

**Sifón et al. 2015, 2018**: No clear Rp dependence
- **Smaller sample**: Factor of 10-50 fewer satellites
- **Larger errors**: Cannot detect trend
- **Different cluster finder**: Group vs cluster samples

**Niemiec et al. 2017**: 70-80% average, no Rp binning
- **Stacked all Rp**: Averaged over trend
- **Lower S/N**: Cannot subdivide

**This work advantage**:
- **9500 deg²**: Large sample enables fine binning
- **DECaLS shear quality**: Good shape measurements
- **redMaPPer**: Clean cluster and membership catalog

---

# Part 6: Implications and Future Directions

## For Galaxy Formation Theory

### Tidal Stripping Physics

**Observation**: 94% mass loss in inner regions
**Implication**: Tidal stripping is **extremely efficient** in clusters

**Questions**:
- How does gas stripping correlate with DM stripping?
- What determines the "stripping radius"?
- How does star formation quenching relate to mass loss?

### Stellar Mass Dependence

**Observation**: U-shaped strip rate vs M*
**Implication**: **Not all satellites evolve the same way**

**Questions**:
- Why do intermediate-mass satellites resist stripping?
- Do high-M* satellites quench faster?
- What role does halo concentration play?

### Simulation Discrepancy

**Observation**: SHMR ~5× higher than TNG in outskirts
**Implication**: **Baryonic physics in simulations needs calibration**

**Possible issues**:
- **Stellar feedback**: Too strong in low-mass satellites?
- **AGN feedback**: Disrupts subhalos?
- **Resolution**: Cannot follow stripped particles?

---

## For MUST and Future Surveys

### What MUST Can Do

**MUST spectroscopic survey** can:

1. **3D distances**: Measure R_3d directly (not just Rp)
   - Eliminates projection uncertainty
   - Enables cleaner SHMR vs R_3d relation

2. **Redshift evolution**: Measure strip rate at z > 0.5
   - Test if tidal stripping efficiency evolves
   - Connect to cluster accretion history

3. **Group vs cluster**: Separate samples by host mass
   - Test environment dependence
   - Compare to SIDM predictions (Banerjee 2019)

4. **Central galaxy properties**: Correlate with satellite strip rate
   - BCG mass, AGN activity, cooling flow
   - Test for environmental effects

### Recommended MUST Analysis

**Target selection**:
- Use **optical cluster finder** (similar to redMaPPer)
- Select satellites with **secure membership** (spectroscopic z)
- Bin by **3D cluster-centric distance** (R_3d = √(Rp² + πΔz²))

**Analysis**:
1. Measure **g-g lensing** around satellites (similar to this paper)
2. Fit **3-component model** (subhalo + host + stars)
3. Derive **SHMR vs R_3d** at multiple redshifts
4. Compare to **hydro simulations** (EAGLE, IllustrisTNG, SIMBA)

**Expected precision**:
- **10× more clusters** than this work → √10 ≈ 3× better S/N
- **3D distances** → eliminate projection systematic
- **Redshift bins** → measure evolution

---

## Synergy with Other Methods

### Strong Lensing

**Comparison**: Strong lensing perturbers vs GGL satellites
- Strong lensing: Individual subhalos, high central densities
- GGL: Stacked subhalos, mean profile

**Test**: Do strong lensing perturbers come from stripped population?

### Satellite Kinematics

**Combination**: GGL + satellite velocity dispersion
- GGL: Total subhalo mass
- Kinematics: Subhalo velocity distribution

**Test**: Does mass-loss correlate with orbital energy?

### Hydrodynamic Simulations

**Calibration**: Use observations to improve feedback models
- Current TNG: Over-strips low-mass satellites?
- Need: Better agreement with observed SHMR

---

# Part 7: Summary and Takeaways

## The Method is Elegant Because:

1. **Bins by cluster-centric distance** → Maps mass loss evolution
2. **Uses weak lensing** → Direct mass measurement (no abundance matching)
3. **Stacks many satellites** → High S/N (9500 deg²)
4. **Fits physical model** → Separates subhalo, host, stellar contributions

## Key Results:

1. **SHMR increases from 4.9 to 77** from inner to outer cluster regions
2. **94% of dark matter stripped** in innermost satellites
3. **Mass loss depends on stellar mass** (U-shaped, minimum at 4×10^10 M⊙)
4. **IllustrisTNG underpredicts SHMR** by factor ~5 in outskirts
5. **Agreement with DMO simulations** (Phoenix)

## For Your Research:

**Connection to MUST**:
- MUST can measure 3D distances (not just projected)
- MUST can probe redshift evolution
- **Group-scale clusters** ideal for SIDM tests (Banerjee 2019 connection)

**Connection to SIDM**:
- Satellite mass loss profile tests tidal stripping physics
- Compare to SIDM simulations (SIDM Concerto)
- **If SIDM exists**, could modify strip rate vs Rp relation

---

## Follow-up Discussion

(Reserved for future questions)

**Your next steps**:
1. Design MUST cluster satellite sample selection
2. Plan g-g lensing analysis with 3D distance bins
3. Compare to SIDM Concerto satellite mass functions
4. Test for environment-dependent stripping
