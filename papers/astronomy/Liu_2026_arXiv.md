---
title: Synthetic Spectral Library of Optically Thick Atmospheres for Little Red Dots
authors:
  - Hanpu Liu
  - Yan-Fei Jiang
  - Eliot Quataert
  - Jenny E. Greene
  - Yilun Ma
  - Xiaojing Lin
year: 2026
source: Paper Digest
tags:
  - paper
  - astro/photometry
topics:
  - Little Red Dots
  - AGN
  - optically thick atmospheres
  - radiative transfer
  - black hole accretion
  - LRD
  - H- opacity
  - CaT
  - super-Eddington accretion
  - non-AGN models
status: digest
first_author: Liu
journal: arXiv
arxiv_id: 2603.02317
doi: N/A
type: paper
---
## tl;dr

This paper presents the **first synthetic spectral library of optically thick atmospheres specifically designed for Little Red Dots (LRDs)** — a population of compact, red extragalactic objects discovered by JWST that challenge conventional AGN models. Using the radiative transfer code **tlusty**, the authors compute 1D atmosphere models spanning low photospheric densities ($\rho_{ph} \sim 10^{-12}-10^{-8}$ g cm$^{-3}$) and $T_{eff} \sim 4000-5000$ K, tailored for LRD conditions. 

The key innovation is identifying **three independent spectral diagnostics of photospheric density**: (1) optical-to-near-IR SED curvature, (2) the **1.6 μm H⁻ spectral kink**, and (3) Ca II triplet (CaT) absorption strength. Applied to the local LRD "the Egg" (z = 0.1), all three features consistently indicate **log g ≈ −3** ($\rho_{ph} \sim 10^{-11}$ g cm$^{-3}$), disfavoring hydrostatic equilibrium and implying a **central engine mass of $M_{tot} \lesssim 10^4 M_\odot$** with super-Eddington accretion ($\lambda_{Edd} \gtrsim 20$). This supports optically thick envelope models (quasi-stars, super-Eddington flows) over standard AGN.

---

## Key Question

**What is the physical nature of LRDs?** JWST has revealed a population of compact, red sources with:
- Blackbody-like SEDs at $T_{eff} \sim 4000-5000$ K
- Broad Balmer emission lines (suggesting BH accretion)
- Weak/absent X-rays and short-term variability (unlike AGN)
- No mid-to-far-IR dust emission (unlike dusty tori)

Previous work used blackbody approximations or stellar libraries, but these miss crucial spectral features. This paper asks: **Can we construct physically-motivated atmosphere models that reproduce the observed spectral details and constrain the central engine properties?**

---

## What's NEW in This Model

### 1. **Custom Spectral Library for LRD Conditions**
Unlike previous work using:
- **Blackbody approximations** (miss spectral features)
- **Stellar libraries** (e.g., Kurucz, PHOENIX; valid only for $\rho_{ph} \gtrsim 10^{-7}$ g cm$^{-3}$, log g $\gtrsim 0$)

This paper creates **the first synthetic library for low-density optically thick atmospheres**:
- **Parameter space**: $T_{eff}$ = 4000–6000 K, log g = −4 to +1 (cgs), [M/H] = −2.6 to +0.1
- **Photospheric densities**: $\rho_{ph} \sim 10^{-12}-10^{-8}$ g cm$^{-3}$ (10⁴–10⁸× lower than stars!)
- **Radiative transfer**: Full NLTE-iterative solution with tlusty
- **Opacity sources**: H⁻, metal lines, electron scattering, molecules (H₂, CO, etc.)
- **Wavelength coverage**: 900 Å – 11 μm

### 2. **Novel Interpretation of "Surface Gravity"**
The authors **reinterpret log g as a photospheric density proxy** rather than true gravitational acceleration:
$$\rho_{ph} \approx \frac{g}{g_{rad}} \cdot \frac{a_{rad}}{G} \sim 10^{-11} \text{ g cm}^{-3} \text{ for log g} = -3$$

This is physically meaningful because:
- Radiative transfer depends on **density and temperature**, not directly on gravity
- In LRDs, dynamical support likely comes from **turbulence/accretion** rather than hydrostatic equilibrium
- The "surface gravity" parameterizes the atmospheric structure independent of the dynamical state

### 3. **Identification of Three Independent Density Diagnostics**
The paper demonstrates that **spectral features scale systematically with photospheric density**:

| Feature | log g dependence | Physical cause |
|---------|------------------|----------------|
| **SED curvature** (B̃−R̃₁ vs R̃₂−Z̃) | Non-monotonic; SED narrows at low log g | H⁻ opacity dominates near-IR; metal lines dominate optical |
| **1.6 μm H⁻ kink** | Strength **increases** with log g | H⁻ bound-free absorption at λ < 1.6 μm |
| **CaT absorption** | EW **increases** with lower log g | Low density → larger H I fraction → stronger Ca II absorption |

All three are **independent probes** that must agree for a consistent model.

### 4. **Public Data Release**
The spectral library is publicly available: https://github.com/hanpu-liu/LRD-synthetic-spectral-library

---

## The 1.6 μm H⁻ Kink: Detailed Physical Explanation

### What Causes the Kink?

The **H⁻ (negative hydrogen ion)** is the key player:

1. **Formation**: At $T \sim 4000-5000$ K, free electrons attach to neutral hydrogen:
   $$H^0 + e^- \rightarrow H^- + \gamma$$

2. **Opacity mechanism**: H⁻ provides **bound-free absorption** (photoionization):
   $$H^- + \gamma \rightarrow H^0 + e^-$$
   The binding energy of H⁻ is **0.754 eV**, corresponding to a wavelength of **1.64 μm**.

3. **Spectral signature**: 
   - At **λ < 1.6 μm**: H⁻ absorbs photons → **redder** continuum (steeper slope)
   - At **λ > 1.6 μm**: H⁻ cannot absorb (photon energy below binding energy) → **bluer** continuum
   - Result: A **"kink"** or turnover at λ ~ 1.6 μm

### Why Does the Kink Strength Depend on Density?

The H⁻ population follows **Saha equilibrium**:
$$n_{H^-} \propto n_e \cdot n_{H^0} \cdot T^{-3/2} \cdot e^{0.754 \text{ eV}/kT}$$

- **Higher density** (higher log g) → more electrons → **more H⁻** → **stronger kink**
- **Lower density** (lower log g) → fewer electrons → **less H⁻** → **weaker kink**

### Quantitative Measure: The Kink Index

The authors define a spectral index (Equation 7):
$$m_{kink} = \frac{F_{J̃} - F_{H̃}}{F_{H̃} - F_{K̃}}$$

Where:
- **J̃** = 1.17–1.23 μm
- **H̃** = 1.56–1.64 μm  
- **K̃** = 2.08–2.19 μm

**Interpretation**:
- $m_{kink} > 0.2$: Strong kink → high density (log g ≳ 0)
- $m_{kink} \sim 0$: Weak kink → low density (log g ≈ −3)
- **The Egg**: $m_{kink} = -0.062^{+0.005}_{-0.004}$ ("total") or $-0.006^{+0.065}_{-0.007}$ (dust-subtracted) → **very weak kink** → **low density**

### Comparison to Stellar Atmospheres

Giant stars (log g ≳ 0–1) show **strong H⁻ kinks** ($m_{kink} > 0.2$). The Egg's weak kink requires densities **10⁴–10⁵× lower** than stellar photospheres, ruling out stellar-like configurations.

---

## Main Results

### Application to "The Egg" (SDSS J1025+1402)

The authors perform MCMC fitting with a composite model (atmosphere + young galaxy + warm dust). The three diagnostics **converge on the same solution**:

| Diagnostic | Observation | Model constraint | Implication |
|------------|-------------|------------------|-------------|
| **SED width** (B̃−R̃₁ vs R̃₂−Z̃) | Narrower than blackbody | log g < −2.0 | Low density |
| **H⁻ kink** | Very weak ($m_{kink} \approx 0$) | log g ≈ −3 | $\rho_{ph} \sim 10^{-11}$ g cm$^{-3}$ |
| **CaT absorption** | Strong (EW ~ 10 Å) | log g ≈ −3 | Consistent with low density |

**Best-fit parameters for the Egg**:
- $T_{eff} = 4500$ K
- log g = −3.25 ($\rho_{ph} = 4 \times 10^{-12}$ g cm$^{-3}$)
- [M/H] = −1
- $\xi_{mtb} = 2$ km s$^{-1}$

### Mass Constraints

Assuming **turbulent support** traced by CaT line width:

1. **Spherical symmetry**: $M_{tot} \lesssim 10^4 M_\odot$ (including BH + gas)
   - $\lambda_{Edd} = L_{atm}/L_{Edd} \gtrsim 20$ (super-Eddington)

2. **Face-on disk geometry**: $M_{tot} \lesssim 10^6 M_\odot$
   - $\lambda_{Edd} \gtrsim 0.2$

These are **lower limits** if CaT forms exterior to the photosphere.

---

## Key Figures

- **Figure 1**: Model parameter grid (T_eff vs log g) — shows coverage of low-density regime inaccessible to stellar libraries
- **Figure 2**: Photospheric density $\rho_{ph}$ vs log g — demonstrates conversion between "gravity" and physical density
- **Figure 3**: Overview spectra — shows how SED shape, Balmer break, CaT, and H⁻ kink vary with log g
- **Figure 4-5**: Color-color diagrams — SED curvature as function of log g; Egg lies in low-log g region
- **Figure 6**: **H⁻ kink strength** — shows $m_{kink}$ vs log g; Egg's weak kink implies log g ≈ −3
- **Figure 8**: CaT equivalent width — increases at low log g; Egg's strong CaT consistent with low density

---

## Critical Notes

### Strengths
1. **First-principles modeling**: Radiative transfer from scratch, not empirical templates
2. **Multiple independent diagnostics**: SED + kink + CaT all agree → robust conclusion
3. **Physical insight**: Connects spectral features to photospheric conditions
4. **Public release**: Enables community to test against other LRDs

### Limitations & Caveats
1. **1D plane-parallel geometry**: May break down for extended atmospheres; real LRDs may be 3D
2. **LTE assumption**: Non-LTE effects could modify H⁻ population (though tests suggest <12% changes)
3. **No broad emission lines**: Models don't reproduce observed Balmer emission (may require photoionization/shocks)
4. **Limited parameter space**: Coverage sparse at $T_{eff} < 4000$ K; no models with log g < −4
5. **Dust extinction**: Egg may have some dust; requires careful decomposition
6. **Cocoon scenario**: Alternative "cocoon" models (partially optically thick) not mutually exclusive with this framework

---

## Open Questions

1. **Non-LTE effects on H⁻**: Could strengthen/weakens the kink; needs detailed calculation
2. **Origin of broad emission lines**: Photoionization by massive stars? Shock heating from accretion?
3. **Higher-redshift LRDs**: Can rest-near-IR spectroscopy constrain their densities?
4. **Connection to cocoon models**: At what column density does optically thick atmosphere → cocoon transition occur?
5. **Other LRDs**: Does the Egg represent the full population, or is there diversity in photospheric densities?
6. **Formation mechanism**: How do such low-density, super-Eddington envelopes form around BHs?

---

## Implications: AGN vs Non-AGN?

This work **supports non-standard accretion scenarios**:

| Feature | Standard AGN | This Work (Optically Thick Atmosphere) |
|---------|-------------|----------------------------------------|
| Central mass | $10^6-10^9 M_\odot$ | $\lesssim 10^4-10^6 M_\odot$ |
| Eddington ratio | $\lambda_{Edd} \sim 0.01-1$ | $\lambda_{Edd} \gtrsim 20$ (super-Eddington) |
| Geometry | Thin disk + dusty torus | Spherical/disk-like dense envelope |
| X-rays | Strong | Suppressed by optically thick gas |
| Variability | Fast (days–weeks) | Slow (decades+) due to large photospheric radius |
| Dust | Required for red color | Not required; gas photosphere produces color |

**Favored scenarios**: Quasi-stars, super-Eddington accretion flows, supermassive stars, or gravitationally unstable disks — all predict log g < 0 and optically thick envelopes.

**Key insight**: The Egg's properties (weak H⁻ kink, narrow SED, strong CaT) are **simultaneously explained** by a single parameter (log g ≈ −3), strongly favoring the optically thick atmosphere interpretation over stellar+AGN composites or dusty tori.

---
## Follow-up Discussion

**Your question**: "What's new in the model?"

**Answer**: The key innovation is creating **the first synthetic spectral library specifically for LRD-like conditions** — low photospheric densities ($\rho_{ph} \sim 10^{-11}$ g cm$^{-3}$) that are 10⁴–10⁵× lower than stellar atmospheres. Previous work used blackbodies (too simple) or stellar libraries (wrong density regime). The authors use full radiative transfer (tlusty) to compute spectra from first principles, identifying three independent density diagnostics (SED curvature, H⁻ kink, CaT) that consistently constrain log g ≈ −3 for the Egg.

**Your question**: "Explain the H⁻ kink at 1.6 μm"

**Answer**: The kink arises from **H⁻ (negative hydrogen ion) bound-free absorption**. At $T \sim 4000-5000$ K, free electrons attach to H⁰ forming H⁻. The H⁻ ion has a binding energy of 0.754 eV, corresponding to 1.64 μm. At wavelengths shorter than this, H⁻ absorbs photons via photoionization (H⁻ + γ → H⁰ + e⁻), making the continuum redder. At longer wavelengths, H⁻ cannot absorb, so the continuum is bluer. This creates a "kink" at ~1.6 μm. The **strength of the kink increases with density** (more H⁻ at higher log g). The Egg's very weak kink ($m_{kink} \approx 0$) requires log g ≈ −3, i.e., $\rho_{ph} \sim 10^{-11}$ g cm$^{-3}$ — much lower than stars.
