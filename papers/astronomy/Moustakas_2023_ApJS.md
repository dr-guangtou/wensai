---
title: Siena Galaxy Atlas 2020
authors:
  - J. Moustakas
  - D. Lang
  - A. Dey
  - S. Juneau
  - A. Meisner
  - A. D. Myers
  - E. F. Schlafly
  - D. J. Schlegel
  - F. Valdes
  - B. A. Weaver
  - R. Zhou
year: 2023
source: Paper Digest
tags:
  - paper
  - astro/galaxy
  - astro/photometry
topics:
  - galaxy atlas
  - nearby galaxies
  - photometry
  - DESI
  - imaging surveys
  - SGA-2020
status: digest
first_author: Moustakas
journal: ApJS (submitted)
arxiv_id: 2307.04888
doi: N/A
type: paper
---
## tl;dr

The Siena Galaxy Atlas 2020 (SGA-2020) is a massive, multi-wavelength repository of **383,620 nearby galaxies** covering approximately **20,000 deg²** of the sky (nearly half the sky). By leveraging deep optical *grz* imaging from DESI Legacy Imaging Surveys DR9 and mid-infrared data from six-year unWISE coadds, the atlas provides a standardized, high-quality reference for the local universe. It delivers not just a catalog, but a full suite of data products including surface brightness profiles, multi-band mosaics, and model-based photometry, making it a foundational resource for studies ranging from galaxy evolution to host-galaxy identification for gravitational wave events.

## Key Question

How can we create a uniform, multi-wavelength characterization of the nearby galaxy population that overcomes the limitations of previous all-sky catalogs? Standard automated pipelines often "shred" large, resolved galaxies or fail at low surface brightness limits. The SGA-2020 aims to be the definitive digital reference for large galaxies by providing precise coordinates, morphology-consistent photometry across optical and IR bands, and detailed structural information ($D_{25}$, PA, ellipticity), filling a critical gap in our census of the local universe.

## Methodology

**Data Sources:**
- **Optical:** *grz* imaging from DESI Legacy Imaging Surveys DR9 (BASS, MzLS, DECaLS)
- **Infrared:** $W1-W4$ (3.4–22 $\mu$m) from six-year unWISE coadds

**Sample Selection:**
- Master parent sample from HyperLeda and WISE Extended Source Catalog (WXSC)
- **>95% complete** for galaxies with $R(26) \gtrsim 25''$ and $r < 18$ (at 26 mag/arcsec² isophote)

**Processing Pipeline:**
- Custom pipeline generates multi-wavelength mosaics centered on each galaxy
- Azimuthally averaged surface brightness profiling for structural parameters
- "The Tractor" forward-modeling photometry for consistent optical/IR flux measurements
- Group association for environmental context

## Main Results

- **Inventory:** 383,620 nearby galaxies over ~20,000 deg²
- **Completeness:** >95% for large/bright systems, significant improvement over SDSS/2MASS for resolved sources
- **Multi-wavelength:** Optical ($grz$) + infrared ($W1-W4$) for stellar mass and SFR estimates
- **Structural precision:** Refined coordinates, $D_{25}$, position angles, ellipticities
- **Public access:** [SGA Portal](https://sga.legacysurvey.org) + NOIRLab Astro Data Lab + Legacy Survey Viewer layer

## Key Figures

- **Figure 1:** 42 sample galaxy mosaics sorted by diameter (3.2′ to 13.4′) — showcases morphological diversity
- **Figure 3:** Sky distribution across northern/southern hemispheres
- **Figure 10-11:** Comparison with HyperLeda and WXSC-100 — demonstrates coordinate and $D_{25}$ improvements
- **Figure 13:** Azimuthally averaged surface brightness profiles — shows depth and low-SB sensitivity

## Critical Notes

**Strengths:**
- Uniform processing across ~400k galaxies
- Multi-wavelength synergy (optical + IR)
- Integration with DESI spectroscopy

**Known Issues:**
- **Mosaic-3 $z$-band pattern noise:** Affects BASS/MzLS footprint — caution for low-SB analysis
- **WISE background over-subtraction:** Impacts galaxies >5′ — may underestimate mid-IR flux in outskirts
- **Elliptical aperture photometry bug:** **Use surface brightness profiles instead** until patched
- Bright star contamination in some mosaics (mitigated by masking)

## Open Questions

- How will full DESI spectroscopy refine Tully-Fisher and Fundamental Plane relations from SGA imaging?
- What low-SB features (streams, halos, dwarfs) remain to be discovered in SGA mosaics?
- How effectively will SGA-2020 serve as host-galaxy catalog for Rubin/LSST transients?
- How does group membership influence morphological transformations in this uniform sample?

---
## Follow-up Discussion

(To be appended during follow-up questions)
