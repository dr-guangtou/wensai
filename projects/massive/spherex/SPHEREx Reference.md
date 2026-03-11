---
date: 2026-03-06
tags:
  - project
  - astro/survey
  - astro/galaxy
  - astro/spectroscopy
  - project/massive
---
## General Information

- SPHEREx is a NASA Astrophysics Medium Explorer mission that launched in March 2025. During its planned two-year mission, SPHEREx will obtain 0.75-5 micron spectroscopy over the entire sky, with deeper data in the SPHEREx Deep Fields.
 - SPHEREx at IRSA: https://irsa.ipac.caltech.edu/Missions/spherex.html
 - Online webtools for accessing data: 
	- Spectrophotometry tool: https://irsa.ipac.caltech.edu/applications/spherex/tool-spectrophotometry
		- Document: https://irsa.ipac.caltech.edu/onlinehelp/spherex/spherex/sp.html
 - SPHEREx explanatory supplement: https://irsa.ipac.caltech.edu/data/SPHEREx/docs/SPHEREx_Expsupp_QR.pdf
 - SPHEREx data explorer: https://irsa.ipac.caltech.edu/applications/spherex/
## Data Access

- SPHEREx archive user guide: https://caltech-ipac.github.io/spherex-archive-documentation/
- SPHEREx data products: https://caltech-ipac.github.io/spherex-archive-documentation/spherex-data-products/
- SPHEREx data access: https://caltech-ipac.github.io/spherex-archive-documentation/spherex-data-access/
	- IRSA provides program-friendly Application Programming Interfaces (APIs) to access SPHEREx Spectral Image data. The on-prem and cloud-hosted Quick Release 2 Spectral Images that have been released thus far are accessible via the [Simple Image Access V2 protocol](https://ivoa.net/documents/SIA/20151223/) defined by the International Virtual Observatory Alliance ([IVOA](https://ivoa.net/)). Cutouts of the Spectral Image data held on-prem are available via IRSA’s Cutout Service.
	- SPHEREx data at IRSA are accessible via the Python packages [pyvo](https://pyvo.readthedocs.io/en/latest/) and [astroquery](https://astroquery.readthedocs.io/en/latest/ipac/irsa/irsa.html)
		- About `pyvo`: https://github.com/astropy/pyvo
	- IRSA provides API access to SPHEREx Spectral Image Multi-Extension FITS files (MEFs) and associated calibration files through [version 2 of the VO Simple Image Access (SIA2) protocol](https://ivoa.net/documents/SIA/20151223/). SIA2 allows users to query for a list of images that satisfy constraints based on position(s) on the sky, band, time, ID, and instrument.
- About IRSA's Simple Image Access v2 Queries: https://irsa.ipac.caltech.edu/ibe/sia.html
	- IRSA's SIA v2 service can also be accessed from Python via [astroquery](https://astroquery.readthedocs.io/en/latest/ipac/irsa/irsa.html#image-and-spectra-searches).
- About IRSA Image Server Cutouts: https://irsa.ipac.caltech.edu/ibe/cutouts.html
## Tutorials: 

- Introduction to SPHEREx Spectral Images: https://caltech-ipac.github.io/irsa-tutorials/spherex-intro/
- Download a collection of SPHEREx Spectral Image cutouts as a multi-extension FITS file: https://caltech-ipac.github.io/irsa-tutorials/spherex-cutouts/ 
- Understanding and Extracting the PSF Extension in a SPHEREx Cutout: https://caltech-ipac.github.io/irsa-tutorials/spherex-psf/
- SPHEREx Source Discovery Tool IRSA Demo: https://caltech-ipac.github.io/irsa-tutorials/spherex-source-discovery-tool-demo/
## Other Tools

- `spherex-tools` : https://github.com/banados/spherex-tools 
	- A complete Python toolkit for downloading and analyzing SPHEREx (Spectro-Photometer for the History of the Universe, Epoch of Reionization and Ices Explorer) data from IRSA.
- `xcavation`: https://github.com/huntbrooks85/xcavation
	- `Xcavation` is a Python package for rapid forced-photometry calculations of SPHEREx QR2 spectral data. It uses the `astroquery.irsa` package to access SPHEREx images through the IRSA API. Aperture photometry is supported and includes multi-threading for improved, deeper analysis.
## Data Reduction 

- The SPHEREx Image and Spectrophotometry Processing Pipeline: https://arxiv.org/html/2511.15823v1