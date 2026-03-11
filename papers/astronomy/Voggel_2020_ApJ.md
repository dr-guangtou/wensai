---
title: A Gaia-based Catalog of Candidate Stripped Nuclei and Luminous Globular Clusters in the Halo of Centaurus A
authors:
  - Karina T. Voggel
  - Anil C. Seth
  - David J. Sand
  - Allison Hughes
  - Jay Strader
  - Denija Crnojevic
  - Nelson Caldwell
year: 2020
source: Paper Digest
tags:
  - paper
topics:
  - UCD
  - ultra-compact dwarfs
  - globular clusters
  - stripped nuclei
  - Centaurus A
  - Gaia
  - galaxy halos
  - UCD selection
  - Gaia astrometry
  - AEN
  - BP/RP excess
  - GC catalog
  - CenA
status: digest
first_author: Voggel
journal: ApJ
arxiv_id: 2001.02243
doi: 10.3847/1538-4357/ab6f69
type: paper
special_request: In-depth summary for research project - focus on UCD selection methodology and typical UCD properties
---
## tl;dr

This paper presents a **novel Gaia-based method** to identify ultra-compact dwarf (UCD) candidates and luminous globular clusters in the halo of Centaurus A. The key innovation is using **Gaia astrometric parameters** — specifically **Astrometric Excess Noise (AEN)** and **BP/RP Excess Factor** — to distinguish **partially resolved** star clusters from point sources (foreground stars) at the distance of CenA (~3.8 Mpc).

The method identified **632 new UCD candidates** out to 150 kpc from CenA, with spectroscopic follow-up confirming **5 new luminous GCs**, including the **7th and 10th most luminous GCs** in CenA and three beyond all previously known GC radii. The technique retains utility out to ~25 Mpc, making it a powerful tool for finding star clusters in galaxy outskirts.

---

## Key Question

**How can we efficiently identify UCDs and stripped nuclei in nearby galaxy halos without relying solely on deep, high-resolution imaging or extensive spectroscopic surveys?**

Traditional methods require:
- High-resolution imaging (HST) to resolve sizes
- Spectroscopy to measure radial velocities and confirm membership
- Multi-band photometry for color selection

This paper asks: **Can Gaia DR2 astrometric data alone identify extended sources (UCDs) against the stellar background?**

---

## UCD Selection Methodology: Detailed Breakdown

### The Core Principle

At the distance of Centaurus A (D ≈ 3.8 Mpc), UCDs and luminous GCs have:
- **Effective radii**: $r_h \sim 2-10$ pc → **angular sizes** of 0.1–0.6 arcsec
- **Gaia pixel scale**: 0.059 arcsec in scanning direction

**Key insight**: These clusters are **partially resolved** by Gaia, causing measurable deviations from the point-source model used in Gaia's astrometric pipeline.

---

### Two Gaia Astrometric Parameters for UCD Selection

#### 1. **Astrometric Excess Noise (AEN)**

**Definition**: Quantifies the quality of the astrometric fit. Expected to be **zero** when all observations fit the model of a single star perfectly.

**For extended sources**:
- The point-source model is inadequate
- Residuals in astrometric solution increase
- **AEN values become positive**

**Availability**: Nearly all objects in Gaia DR2

#### 2. **BP/RP Excess Factor ($BR_{excess}$)**

**Definition**: Ratio of total flux in BP + RP photometers to flux in G band:
$$BR_{excess} = \frac{F_{BP} + F_{RP}}{F_G}$$

**Why it works**:
- **G magnitude**: Derived from **profile fitting** (effective resolution ~0.4 arcsec)
- **BP/RP magnitudes**: Derived from **aperture photometry** (3.5 × 2.1 arcsec aperture)
- For **point sources**: $BR_{excess}$ is slightly > 1 (broader BP+RP wavelength coverage)
- For **extended sources**: $BR_{excess}$ increases significantly because the larger BP/RP aperture captures "extra" light beyond the point-source core

**Availability**: Most bright sources (G < 19)

**Caveat**: High $BR_{excess}$ can also indicate:
- Contamination from nearby sources (crowding)
- Background galaxies
- Double stars

---

### Selection Criteria (Section 2.1)

The authors derived **empirical boundaries** to separate UCDs from the stellar locus:

#### AEN Boundary:
$$AEN > 0.12 + 2.66 \times 10^{-6} \cdot e^{0.7 \cdot G}$$

#### BR_excess Boundary:
$$BR_{excess} > 1.39 + 2.18 \times 10^{-7} \cdot e^{0.76 \cdot G}$$

**Method**: Boundaries set at the **98th percentile** of the stellar distribution in AEN and $BR_{excess}$ vs. G magnitude.

**Result**: 
- No confirmed literature GCs removed
- Minimizes stellar contamination
- **Effective at separating extended sources from point sources**

---

### Photometric Considerations (Section 2.2)

#### Gaia G vs. Ground-based g Magnitudes

**Key finding**: Gaia G magnitudes of CenA GCs are **0.5–0.6 mag fainter** than expected for point sources of the same g magnitude.

**Why?** UCDs are **resolved**, so Gaia's point-source photometry misses some flux.

**Correction**:
- Observed G − g = +0.19 mag (median)
- Expected G − g = −0.32 mag (from stellar color relations)
- **Offset**: Δ(G − g) ≈ +0.52 mag

**Implications**:
- G < 19 limit → $M_G \sim -9.7$ after corrections
- Corresponds to $M_V \sim -9.5$ (luminosity ~5 × 10⁵ L⊙)
- Assuming M/L ~ 2 → **mass limit ~10⁶ M⊙**

This is roughly where **stripped nuclei become common** among UCDs.

---

### Additional Selection Criteria

#### 1. **Proper Motion Filtering**
- Objects with significant proper motion (S/N > 4) are **foreground stars**
- **4 literature "GCs" identified as misclassified stars** via this check

#### 2. **Broadband Color Selection (u−r vs. r−z)**
- Uses SCABS survey photometry (Taylor et al. 2017)
- GCs well-separated from stellar locus, especially at **metal-rich end**
- Some overlap at metal-poor end
- **Quality of separation increases with wavelength baseline**

#### 3. **Visual Examination**
- High-resolution imaging from PISCeS survey (Crnojević et al. 2016)
- **Rank A**: Clearly extended, no nearby contaminants
- **Rank B**: Extended but with issues (nearby source, image artifact)
- **Rank C-E**: Progressively lower confidence

---

### Complete Selection Workflow

```
1. Start with all Gaia sources within search area (2.3° of CenA)

2. Apply magnitude cut: G < 19 (completeness limit for BR_excess)

3. Apply AEN boundary (Equation 1)
   → Removes most point sources

4. Apply BR_excess boundary (Equation 2)
   → Further purification

5. Cross-match with existing photometry (Taylor et al. 2017)
   → Add u−r vs. r−z color cut

6. Visual examination (if high-resolution imaging available)
   → Assign Rank A-E

7. Spectroscopic follow-up
   → Measure radial velocity
   → Confirm CenA membership (v_helio ≈ 275–800 km/s)
```

---

### Size Estimation from Gaia Data (Section 2.3)

The authors derived an **empirical relation** to estimate half-light radii from Gaia parameters:

$$r_h (\text{arcsec}) = (0.222 - 0.095(G - 18))(BR_{excess} - 2.5) + 0.308(G - 18) - 0.074$$

**Accuracy**: ~30% scatter (rms = 0.081 arcsec) over $r_h$ ~ 0.1–0.5 arcsec

**Usefulness**: 
- Not as precise as HST imaging
- **Superior to ground-based seeing-limited sizes**
- Provides **first-pass size estimates** for candidate selection

---

## Typical Properties of UCDs in This Study

### Confirmed UCDs (Table 3)

| Property | Value |
|----------|-------|
| **Sample size** | 5 newly confirmed UCDs + 1 from PISCeS |
| **g magnitudes** | 17.59 – 18.30 mag |
| **Absolute G magnitudes** | $M_G$ = −9.6 to −10.3 |
| **Radial velocities** | 485 – 719 km/s (CenA systemic: 541 km/s) |
| **Galactocentric distances** | 13 – 85 kpc (projected) |

### Notable Discoveries

1. **KV19-442**: 7th most luminous GC in CenA ($M_g = -10.32$)
2. **KV19-271**: 10th most luminous GC in CenA ($M_g = -10.25$)
3. **KV19-212, KV19-442, Fluffy**: More distant than **any previously known GC** in CenA

---

### Candidate Sample Statistics (632 objects)

| Property | Value |
|----------|-------|
| **Magnitude limit** | G < 19 |
| **Projected radius coverage** | Out to 150 kpc from CenA center |
| **Fraction at large radii** | **91%** are at larger radii than any previously velocity-confirmed UCD |
| **Rank A candidates** | 11 (highest confidence) |
| **Spectroscopic confirmation rate** | **100%** for Rank A objects observed (4/4) |
| **Foreground contamination** | 9/14 candidates with low velocities (foreground stars) |

---

### UCD Mass and Luminosity Ranges

| Category | $M_G$ | $M_V$ | Mass (M⊙) | Notes |
|----------|-------|-------|-----------|-------|
| **Selection limit** | −9.7 | −9.5 | ~10⁶ | Where stripped nuclei become common |
| **Typical confirmed** | −10.0 to −10.3 | −9.8 to −10.1 | ~1–2 × 10⁶ | Luminous GC / low-mass UCD |
| **High-confidence stripped nuclei** | < −12.2 | < −12.0 | > 10⁷ | Majority appear to be stripped nuclei |

---

### Comparison to Literature

| Study | Method | Limitation |
|-------|--------|------------|
| **Ground-based imaging** (Peng et al. 2004) | Resolution-limited | Can't resolve small UCDs |
| **HST imaging** (Harris et al. 2006) | High resolution | Limited area coverage |
| **Spectroscopic surveys** (Woodley et al. 2010) | Velocity confirmation | Expensive, limited targets |
| **This work (Gaia)** | Astrometric excess | **Wide-area, efficient, works to ~25 Mpc** |

---

## Main Results

### 1. Gaia Can Identify UCDs at CenA Distance

- **All 57 confirmed literature UCDs** with G < 19 have elevated AEN and $BR_{excess}$
- These parameters clearly separate extended sources from the stellar locus
- **4 previously "confirmed" GCs revealed as misclassified stars** via proper motion

### 2. Size Predictions from Gaia

- Empirical relation between $r_h$, G magnitude, and $BR_{excess}$
- Accuracy ~30% for $r_h$ ~ 0.1–0.5 arcsec
- Useful for **first-pass size estimates** without high-resolution imaging

### 3. New UCD Catalog

- **632 candidates** out to 150 kpc
- **91%** beyond all previously confirmed UCD radii
- **Complete** at G < 19 except for rare, highly extended objects

### 4. Spectroscopic Confirmation

- **5 new luminous GCs confirmed** (100% success rate for Rank A)
- Includes **7th and 10th most luminous GCs** in CenA
- **3 GCs** more distant than any previously known

### 5. Method Applicability to Other Galaxies

**Distance limits**:
- **Lower limit**: ~3 Mpc (M31 UCDs too resolved → not in Gaia)
- **Upper limit**: ~20-25 Mpc (too faint for Gaia completeness)

**Best targets** (Figure 11):
- **NGC 5128 (CenA)**: D = 3.8 Mpc ✓
- **M81**: D = 3.6 Mpc ✓
- **NGC 253**: D = 3.5 Mpc ✓
- **M87**: D = 16.4 Mpc ✓ (only brightest UCDs)
- **NGC 1316 (Fornax)**: D = 17.8 Mpc ✓

---

## Key Figures

- **Figure 1**: AEN and $BR_{excess}$ vs. G magnitude — shows clear separation between GCs and stellar locus
- **Figure 2**: Correlation between $BR_{excess}$ and angular size — demonstrates size estimation capability
- **Figure 3**: u−r vs. r−z color-color diagram — GCs separated from stars, especially at metal-rich end
- **Figure 7**: Ranking distribution of candidates — shows high purity of Rank A sample
- **Figure 8**: Spatial distribution of candidates — 91% beyond previous GC radii
- **Figure 9**: PISCeS imaging cutouts of confirmed UCDs — visual confirmation of extended nature
- **Figure 11**: Applicability to other galaxies — shows magnitude limits vs. distance

---

## Critical Notes

### Strengths

1. **Novel approach**: First use of Gaia astrometry to identify extragalactic star clusters
2. **Wide area coverage**: 2.3° radius (~150 kpc at CenA distance)
3. **High completeness**: All confirmed literature UCDs recovered
4. **Efficient**: No need for deep imaging or extensive spectroscopy for initial selection
5. **Scalable**: Applicable to many galaxies within ~25 Mpc

### Limitations & Caveats

1. **Magnitude-limited**: G < 19 misses fainter GCs (majority of GC population)
2. **Central regions excluded**: Within 5 arcmin (5.5 kpc) of CenA center → crowding/extinction
3. **Resolution-dependent**: Very extended UCDs may be missed (resolved out of Gaia)
4. **Contamination**: High $BR_{excess}$ can also come from crowded regions, background galaxies, double stars
5. **Requires spectroscopy**: Gaia selection alone cannot confirm membership (need radial velocities)
6. **Distance-limited**: Not useful for very nearby galaxies (M31, MW) where UCDs too resolved, or very distant (>25 Mpc) where too faint

---

## Open Questions

1. **What fraction of candidates are true UCDs?** — Spectroscopic follow-up of full sample needed
2. **How many stripped nuclei vs. massive GCs?** — Need velocity dispersions, metallicities, detailed populations
3. **Spatial distribution and kinematics** — Do outer halo UCDs trace accreted satellites?
4. **Extension to other galaxies** — What is the full potential of this method?
5. **Gaia DR3/DR4 improvements** — Better astrometry will improve selection and size measurements

---

## Practical Takeaways for Your Research

### If You Want to Apply This Method:

1. **Download Gaia DR2/DR3 data** for your target galaxy region
2. **Apply the AEN and $BR_{excess}$ cuts** (Equations 1 & 2)
3. **Cross-match with ground-based photometry** for color selection
4. **Visually inspect candidates** if high-resolution imaging available
5. **Obtain spectroscopy** for radial velocity confirmation

### Key Equations to Use:

**AEN cut**:
```python
AEN_limit = 0.12 + 2.66e-6 * np.exp(0.7 * G)
selected = AEN > AEN_limit
```

**BR_excess cut**:
```python
BR_limit = 1.39 + 2.18e-7 * np.exp(0.76 * G)
selected = BR_excess > BR_limit
```

**Size estimate**:
```python
r_h = (0.222 - 0.095*(G - 18)) * (BR_excess - 2.5) + 0.308*(G - 18) - 0.074
```

### Sample Properties to Expect:

- **Mass range**: ~10⁶–10⁷ M⊙ (luminous GCs, UCDs, stripped nuclei candidates)
- **Sizes**: $r_h$ ~ 2–10 pc (0.1–0.6 arcsec at CenA distance)
- **Spatial distribution**: Can probe to very large radii (>100 kpc)
- **Contamination**: Foreground stars removed by proper motion; background galaxies rare at these magnitudes

---

## Follow-up Discussion

(Reserved for future questions and analysis)
