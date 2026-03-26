---
date: 2026-03-15
tags:
  - astro/galaxy
  - astro/survey
  - astro/photometry
  - development/star_forming_bcg
---
# GALEX in General

- Getting started with GALEX: https://galex.stsci.edu/GR6/default.aspx?page=start 
- GALEX GR6/7 data release: https://galex.stsci.edu/gr6/
- GALEX SQL search form: https://galex.stsci.edu/GR6/default.aspx?page=sqlform 
- Schema browser: https://galex.stsci.edu/GR6/default.aspx?page=dbinfo

# GALEX Catalogs 

- There are many different versions of GALEX catalogs 

### Accessing the GALEX catalog

- `Astroquery`
	- Using the catalog query: https://astroquery.readthedocs.io/en/stable/mast/mast_catalog.html
	- Using the `TAP/TAP+` service: https://astroquery.readthedocs.io/en/stable/utils/tap.html

### GALEX UV Unique Source Catalogs (`GUVcat`)  and Cross-Matches With Gaia and SDSS  (`GUVmatch`)

- STScI Website: https://archive.stsci.edu/hlsp/guvcat 
- This is the revised version of Bianchi et al. 2017
- GUVcat is composed of tiles from the AIS (All-Sky Imaging Survey), with a depth of about 19.9/20.8 in FUV/NUV AB mag.
- The catalogs are available in CasJobs for searching and cross-matching with SQL access, and as CSV files for bulk downloads.

### `GUVcat_AIS`: Revised Catalog of GALEX Ultraviolet Sources. I. The All-Sky Survey:

- Short: Bianchi+2017
- ADS link: https://ui.adsabs.harvard.edu/abs/2017ApJS..230...24B/abstract 
- CDS/Vizier: https://cdsarc.cds.unistra.fr/viz-bin/cat/II/335
- The author's website: http://dolomiti.pha.jhu.edu/uvsky/uvsky_GUVcat.html 
- The GALEX database contains FUV and NUV images, ∼500 million source measurements, and over 100,000 low-resolution UV spectra.
- We present science-enhanced, “clean” catalogs of GALEX UV sources, with useful tags to facilitate scientific investigations.

## Older version of the GALEX catalog

- From NASA's HEASARC Website: https://heasarc.gsfc.nasa.gov/docs/heasarc/biblio/pubs/galex_ycat.html

### Improved GALEX UV Photometry for 700,000 SDSS Galaxies 

- Publication: https://iopscience.iop.org/article/10.3847/1538-4365/ace9de 
- 

## GALEX Images 

### Accessing GALEX Image Cutouts

- The NASA's HEASARC SkyView service: https://skyview.gsfc.nasa.gov/current/cgi/titlepage.pl
	- `astroquery.skyview` interface: https://astroquery.readthedocs.io/en/latest/skyview/skyview.html
- Using Yao-Yuan Mao's ImageList Cutout tool using the LegacySurvey API: https://yymao.github.io/decals-image-list-tool/

## Misc: 

- Empirical PSFs of GALEX, SDSS, and 2MASS: https://github.com/aabdurrouf/empPSFs_GALEXSDSS2MASS
	- Reference: https://ui.adsabs.harvard.edu/abs/2021ApJS..254...15A/abstract

- HostPhot: global and local photometry of galaxies hosting supernovae or other transients: https://github.com/temuller/hostphot
	- Documentation: https://hostphot.readthedocs.io/en/latest/
	- Including the mechanism to download GALEX images