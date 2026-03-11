---
title: The Star Formation History of WLM from Asymptotic Giant Branch Stars and The Discovery of a Possible Accreted System in its Outer Disk
authors:
  - Abigail J. Lee
  - Daniel R. Weisz
  - Andrew E. Dolphin
  - Alessandro Savino
year: 2025
source: Paper Digest
tags:
  - paper
  - astro/stellar
  - astro/agn
topics:
  - star formation history
  - AGB stars
  - resolved stellar populations
  - dwarf galaxies
  - WLM
  - NIR photometry
  - AGB
  - SFH recovery
  - COLIBRI models
  - NIR CMD
status: digest
first_author: Lee
journal: arXiv
arxiv_id: 2603.00243
doi: N/A
type: paper
special_request: Focus on AGB population physics and SFH recovery methodology - pros/cons
---
## tl;dr

This paper validates a **new method for measuring galaxy star formation histories using only AGB stars in NIR color-magnitude diagrams**. Using ground-based NIR imaging (J, K bands) of the Local Group dwarf galaxy WLM, the authors show that SFHs recovered from ~825 AGB/bright RGB stars agree excellently with SFHs from deep JWST imaging that reaches the oldest main sequence turnoff (oMSTO). Key metrics (τ₅₀, τ₉₀) agree within uncertainties, though AGB-based SFHs have coarser time resolution due to low star counts. The method also discovered a stellar overdensity (M ~ 2×10⁶ M⊙) in WLM's outer disk with an ~8 Gyr star formation burst, suggesting a possible accreted dwarf galaxy. This work demonstrates that **AGB star SFHs are accurate enough for galaxies beyond the Local Group where oMSTO observations are impossible**.

---

## Educational Background: AGB Stars for SFH Recovery

### Why AGB Stars? The Challenge of Measuring SFHs Beyond the Local Group

Traditional SFH measurements rely on the **oldest main sequence turnoff (oMSTO)**:
- **Gold standard**: Provides age resolution across cosmic time
- **Problem**: Faint! $M_V \sim +4$ at the oMSTO
- **Distance limit**: HST can only reach oMSTO in Local Group (~1 Mpc); JWST extends to ~2-3 Mpc

**Alternative CMD features** (progressively brighter):
| Feature | $M_V$ | Age sensitivity | Limitations |
|---------|-------|-----------------|-------------|
| **Subgiant branch (SGB)** | ~+3.5 | Good | Almost as faint as oMSTO |
| **Horizontal branch (HB)** | ~+0.5 | Highly age-sensitive | Small numbers, model-dependent |
| **Red clump (RC)** | ~+0.5 | 1-10 Gyr ages | Skews young/metal-rich, complex physics |
| **RGB tip (TRGB)** | ~-4 | Distance indicator | Not age-sensitive |
| **AGB stars** | ~-4 to -7 | Age-sensitive, BRIGHT | Complex physics, NIR required |

**AGB advantage**: **100-1000× brighter** than oMSTO, observable to ~25 Mpc with ground-based NIR or JWST!

---

## Advanced Knowledge: AGB Population Physics

### What Are AGB Stars?

**Asymptotic Giant Branch stars** are evolved low- and intermediate-mass stars (0.5-8 M⊙) near the end of their lifetimes:
- **Core**: Inert C-O core (or O-Ne for more massive)
- **Shell burning**: Double shell burning (H shell + He shell)
- **Structure**: Extended envelope, large radius
- **Evolutionary timescale**: Very short (~10⁶ years)

### AGB Subtypes

| Type | Characteristics | Mass range | Age tracer |
|------|-----------------|------------|------------|
| **Early AGB (E-AGB)** | Before thermal pulses | All AGB progenitors | Less age-specific |
| **Thermally-pulsing AGB (TP-AGB)** | He shell flashes (thermal pulses) | 0.5-8 M⊙ | **Age-sensitive** |
| **M-type AGB** | Oxygen-rich (C/O < 1) | Lower mass | Older populations |
| **C-type AGB** | Carbon-rich (C/O > 1) | dredge-up enriched | Intermediate ages |
| **Extreme AGB (x-AGB)** | Very red, high mass loss | Highest mass AGB | Young populations |

### AGB Luminosity and Age

**Key insight**: AGB tip luminosity correlates with progenitor mass:
- **Low-mass AGB** (M < 1.5 M⊙): Faint tip, ages > 5 Gyr
- **Intermediate-mass AGB** (1.5-3 M⊙): Brighter tip, ages 0.5-5 Gyr
- **High-mass AGB** (3-8 M⊙): Very bright, ages < 0.5 Gyr

**But**: Complex physics makes simple age-luminosity relations unreliable:
- **Mass loss**: Strong mass loss truncates AGB evolution
- **Thermal pulses**: Luminosity varies during He shell flashes
- **Dredge-up**: Changes surface composition (C/O ratio)
- **Third dredge-up**: Brings C to surface, creates C-type AGB
- **Hot bottom burning**: Occurs in massive AGB, alters surface abundances

---

## Why NIR is Essential for AGB-Based SFHs

### The Problem with Optical Wavelengths

1. **~40% of AGB stars are undetected in optical** (Zijlstra et al. 1996; Boyer et al. 2009, 2019)
   - Metal-rich, cool AGB stars are highly dust-enshrouded
   - Self-extinction from circumstellar dust

2. **Poor age separation** in optical CMDs (Javadi et al. 2011b; Lee et al. 2025)
   - M-type and C-type AGB overlap
   - AGB and RGB not cleanly separated

### NIR Advantages

At near-infrared wavelengths (J, H, K bands):

1. **Clean separation** of stellar populations:
   - **C-type AGB**: Redder in (J-K), distinct sequence
   - **M-type AGB**: Bluer in (J-K), separate sequence
   - **RGB**: Bluer still, distinct from both AGB types

2. **Reduced extinction**: Dust effects minimized

3. **Better age sensitivity**: AGB luminosity function more age-sensitive in NIR

4. **TRGB calibration**: JAGB (J-band AGB) method for distance

### Why AGB Physics Matters for SFH Recovery

The COLIBRI models used in this paper include:
- **Mass loss prescriptions**: Reimers + Blöcker for pre-AGB; custom for AGB
- **Thermal pulse cycles**: Periodic He shell flashes
- **Third dredge-up**: C enrichment, transition M→C type
- **Hot bottom burning**: For M > 4 M⊙, C→N cycling
- **Molecular opacities**: Temperature-dependent, C/O-dependent

**Crucially**: These models were **calibrated to Magellanic Cloud AGB stars** with known SFHs (Rubiele et al. 2018; Mazzi et al. 2021), placing AGB ages on the same scale as MSTO-derived ages.

---

## Methodology: How to Use AGB Stars for SFH Recovery

### The Complete Workflow

```
1. OBTAIN NIR IMAGING
   - J, K bands (or JH, HK)
   - Reach ~1 mag below TRGB
   - Need ~1000 stars on CMD for robust SFH

2. PHOTOMETRY & QUALITY CUTS
   - PSF photometry (DAOPHOT)
   - Signal-to-noise > 7
   - Remove artifacts, crowded sources

3. REMOVE FOREGROUND CONTAMINATION
   - Cross-match with Gaia
   - Cut on parallax + proper motion
   - Use color cuts (J-K > 0.85 for WLM)

4. CREATE CMD (J vs J-K)
   - Bin into Hess diagram
   - 0.05 × 0.05 mag bins

5. GENERATE SSP MODELS
   - COLIBRI AGB isochrones
   - Age range: log(t) = 6.7 - 10.15
   - Metallicity: [M/H] = -2.0 to -0.5
   - Kroupa IMF (0.03-120 M⊙)

6. MODEL OBSERVATIONAL EFFECTS
   - Artificial star tests (30,000+)
   - Completeness, photometric errors
   - Spatial variation

7. FIT CMD WITH MATCH
   - Find linear combination of SSPs
   - Maximize likelihood
   - Apply priors (monotonic AMR)

8. EXTRACT SFH
   - SFR(t), cumulative SFH
   - Age-metallicity relation
   - Uncertainties from hybrid MC
```

### Key Requirements

| Requirement | Reason | Minimum |
|-------------|--------|---------|
| **NIR bands** | Separate AGB subtypes | J + K (or JHK) |
| **Depth** | Reach below TRGB | >1 mag below TRGB |
| **Star counts** | Reduce shot noise | ~1000 stars on CMD |
| **Calibrated models** | Accurate ages | COLIBRI (MC-calibrated) |
| **ASTs** | Model completeness | >10,000 stars |

---

## Pros and Cons of AGB-Based SFH Recovery

### Advantages ✅

| Pro | Details |
|-----|---------|
| **Distance reach** | Works to ~25 Mpc (ground-based NIR) or beyond (JWST) |
| **Bright targets** | $M_J < -4.9$, 100-1000× brighter than oMSTO |
| **Wide area** | Ground-based imaging covers large fields |
| **Efficient** | No need for ultra-deep exposures |
| **Age coverage** | Full cosmic time (0-13 Gyr) |
| **Metallicity** | AMR recovered simultaneously |
| **Validated** | Agrees with oMSTO SFHs (this paper) |
| **Substructure detection** | Wide-field → identify accretion events |

### Limitations ❌

| Con | Details | Mitigation |
|-----|---------|------------|
| **Coarse time resolution** | Shot noise from low star counts | Need ~1000+ stars |
| **AGB physics complexity** | Mass loss, thermal pulses, dredge-up | Use calibrated COLIBRI models |
| **Model dependence** | AGB models less mature than MSTO | Validation against oMSTO when possible |
| **Age-metallicity degeneracy** | Similar AGB luminosities for different age/Z | Use NIR colors + AMR prior |
| **Foreground contamination** | MW stars in CMD | Gaia cross-match, color cuts |
| **Requires NIR** | Optical misses ~40% of AGB | JHK imaging essential |
| **Young ages uncertain** | Few high-mass AGB | Combine with other indicators |
| **Systematic uncertainties** | Different AGB models give different results | Model comparison (PARSEC vs BaSTI) |

### Quantitative Comparison: AGB vs oMSTO (from this paper)

| Metric | AGB-based | JWST oMSTO | Difference |
|--------|-----------|------------|------------|
| **τ₅₀** (50% mass formed) | 5.16⁺²·⁰⁷₋₀.₅₀ Gyr ago | 5.29⁺⁰·³⁴₋₀.₂₈ Gyr ago | 0.13 Gyr |
| **τ₉₀** (90% mass formed) | 1.33⁺⁰·¹¹₋₀.₀₉ Gyr ago | 1.42⁺⁰·¹⁶₋₀.₀₁ Gyr ago | 0.09 Gyr |
| **Time resolution** | Coarse (large errors) | Fine (small errors) | Factor ~3-5 |
| **Stars used** | 825 | ~10⁵+ | Factor ~100 |
| **Observing time** | Hours (ground-based) | Days (JWST) | Factor ~10-50 |

**Bottom line**: AGB SFHs are **accurate** (agree with oMSTO) but **less precise** (larger uncertainties).

---

## Main Results from WLM

### Validation Against JWST oMSTO SFH

**Key finding**: AGB-based SFH agrees with oMSTO SFH within uncertainties:
- Same qualitative shape: low early SF, bursts at ~8, 5, 3, 1.5 Gyr
- Same enrichment history: [M/H] rises from -1.5 to -0.9 over 13 Gyr
- Same age gradient: outer regions older than inner regions

### Discovered Accretion Candidate

**Overdensity "Region A"** in northwestern outer disk:
| Property | Value |
|----------|-------|
| **Mass** | ~2×10⁶ M⊙ |
| **Half-light radius** | ~340 pc |
| **SFH** | Burst ~8 Gyr ago |
| **Location** | Near H I warp in outer disk |
| **Interpretation** | Possible accreted dwarf galaxy |

**Evidence for accretion**:
1. **Spatial concentration** not seen in field stars
2. **Distinct SFH** (burst at 8 Gyr not seen elsewhere)
3. **Mass/size consistent** with dwarf galaxy
4. **Location near H I warp** → interaction signature

### Implications

This demonstrates that **AGB-based SFH methods can**:
1. Recover accurate SFHs in galaxies beyond the Local Group
2. Identify substructure and accretion events
3. Provide metallicity/enrichment history
4. Enable wide-area surveys of SFH diversity

---

## Future Prospects

### Upcoming Facilities

| Facility | Advantage for AGB SFH |
|----------|----------------------|
| **JWST NIRCam** | Ultra-deep NIR, resolve to ~10 Mpc |
| **Roman Space Telescope** | Wide-field NIR, thousands of galaxies |
| **Euclid** | All-sky NIR surveys |
| **Rubin Observatory** | Optical + NIR, wide area |
| **ELTs (GMT, TMT, E-ELT)** | Ground-based NIR, superb resolution |

### Target Galaxies

- **Local Volume** (1-5 Mpc): Complete SFH validation sample
- **Nearby groups** (5-15 Mpc): Environmental studies
- **Virgo/Fornax clusters** (15-20 Mpc): Cluster vs field SFH
- **Field galaxies** (to ~25 Mpc): Representative Universe

---

## Practical Recommendations

### When to Use AGB-Based SFH

**Best suited for:**
- Galaxies beyond Local Group (>3 Mpc)
- Wide-area surveys requiring efficiency
- Identifying accretion/substructure
- Complementary to other methods

**Avoid for:**
- Precise young SFH (<1 Gyr)
- Small galaxies (<10⁶ M⊙)
- Heavily dust-obscured systems (without NIR)
- When oMSTO data available

### Minimum Observing Requirements

| Requirement | Specification |
|-------------|---------------|
| **Telescope** | 4m+ (ground) or JWST/Roman (space) |
| **Filters** | J + K (or JHK) |
| **Depth** | >1 mag below TRGB |
| **Area** | >1 half-light radius |
| **Seeing** | <1 arcsec (ground) |
| **Photometry** | SNR > 7 for target stars |

---

## Key Figures

- **Figure 1**: WLM optical image with NIR field footprints
- **Figure 2**: NIR CMD (J vs J-K) showing AGB, RHeB, RGB populations
- **Figure 3**: Spatial distribution of stellar populations
- **Figure 4**: Hess diagrams showing observed vs model CMDs (excellent fit!)
- **Figure 5**: SFH comparison: inner vs outer regions
- **Figure 6**: **Key validation**: AGB SFH vs JWST oMSTO SFH (agreement!)
- **Figure 8**: Region A overdensity SFH (distinct 8 Gyr burst)
- **Figure 9**: Age gradient comparison (AGB vs JWST, agree)

---

## Critical Notes

### Strengths

1. **Rigorous validation** against gold-standard oMSTO SFH
2. **Uses calibrated COLIBRI models** (anchored to MC AGB)
3. **Wide-area coverage** → substructure detection
4. **Practical methodology** → reproducible

### Limitations

1. **No systematic uncertainties** calculated (only random errors)
2. **Model dependence** on COLIBRI (though calibrated)
3. **Shot noise** limits time resolution
4. **Single galaxy** validation (WLM only)

### Open Questions

1. How well does this work for different galaxy types (starbursts, quiescent, early-type)?
2. Metallicity effects on AGB physics at low [M/H]?
3. Can AGB SFHs constrain very recent SF (<500 Myr)?
4. How to combine AGB + MSTO data optimally?

---

## Summary for Your Research

### Key Takeaways

1. **AGB stars are viable SFH tracers** when NIR data available
2. **COLIBRI models are state-of-the-art** for AGB physics
3. **Method validated** against oMSTO in WLM
4. **Works to ~25 Mpc** with ground-based NIR, further with JWST/Roman
5. **Coarser time resolution** than oMSTO, but accurate
6. **Wide-field advantage** → accretion discovery potential

### For Your Work

If you're interested in resolved stellar populations and SFH recovery:
- **AGB method extends reach** beyond Local Group
- **NIR imaging is essential** (JHK bands)
- **Use COLIBRI models** for AGB physics
- **Combine with other indicators** (HB, RC, TRGB) when possible
- **Expect factor ~3-5 larger uncertainties** than oMSTO
- **Great for environmental studies** of galaxy populations

---
## Follow-up Discussion

(Reserved for future questions and analysis)
