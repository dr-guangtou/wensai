---
date: 2026-03-18
tags:
  - development
  - development/star_forming_clusters
---

# star_forming_clusters — feature/galex-query-test — 2026-03-18

## Progress

- Built and tested three GALEX catalog query methods (MAST Catalogs, Vizier GUVcat_AIS, CDS XMatch) using red4522 as a validation target in `galex/galex_query_test.py`. Confirmed CDS XMatch is best for bulk work.
- Ran full cross-match of 25,325 SDSS DR8 redMaPPer BCGs against GUVcat_AIS (Bianchi+2017) using CDS XMatch with 5 arcsec radius. Found **1,653 unique BCGs** (6.5%) with GALEX detections; 301 with FUV. Results saved to `galex/redmapper_galex_matched.fits`.
- Created three exploratory scatter plots (richness vs NUV-r, NUV-i, FUV-r) to examine UV-optical colors of GALEX-detected BCGs. red4522 highlighted on all plots.
- Applied NUV-r < 4.0 cut to isolate potentially star-forming BCGs: **635 candidates**. Saved as `galex/redmapper_galex_matched_nuv_r_4.fits`.
- Built a three-panel cutout generator (`galex/plot_cutout_triplet.py`) using the Legacy Survey viewer API: LS DR10 optical (native 0.262"/pix) | GALEX NUV+FUV | VLASS 1.2 GHz, with cluster metadata annotations (ID, name, RA/Dec, z, richness, NUV-r, FUV-r) and a 30" scale bar.
- Generated all 635 triplet cutout figures (685 MB) for visual inspection, saved to `/Users/mac/Dropbox/work/data/cluster/redmapper/galex_matched_nuv_r_4/`.

## Current State

### Key Files Created
- `galex/galex_query_test.py` — GALEX query method comparison script
- `galex/redmapper_galex_xmatch.py` — bulk cross-match script
- `galex/redmapper_galex_matched.fits` / `.csv` — full matched catalog (1,682 rows, 1,653 unique BCGs)
- `galex/redmapper_galex_matched_nuv_r_4.fits` / `.csv` — NUV-r < 4.0 subsample (635 BCGs)
- `galex/plot_richness_vs_nuv_r.py` — richness vs UV-optical color plots (NUV-r, NUV-i, FUV-r)
- `galex/plot_cutout_triplet.py` — three-panel cutout figure generator
- `notes/galex_query_methods.md` — research notes on query methods and cross-match results

### Key Issues
- GUVcat pipeline FUV magnitude for red4522 (22.05) differs from NED integrated value (21.14) by ~0.9 mag — aperture effect for extended merger system. Pipeline mags may underestimate total UV flux for resolved BCGs.
- No commits yet on this branch — all work is uncommitted.

### Next Steps
- Visual inspection of the 635 cutout triplets to identify the most interesting star-forming BCG candidates (mergers, tidal features, radio+UV coincidence).
- Consider quality cuts on GUVcat artifact flags (Fafl, Nafl) to clean the sample.
- Decide on a redshift-dependent UV color threshold (current NUV-r < 4.0 is observed-frame, not k-corrected).
- Investigate GALEX coverage fraction of the redMaPPer footprint to distinguish non-detections from non-coverage.

## Lessons Learned
- CDS XMatch service handles 25k-row uploads without issues when chunked in batches of 5,000. Server-side matching is far more efficient than looping cone searches.
- Legacy Survey viewer API supports GALEX and VLASS layers at arbitrary pixscale — requesting at the optical native resolution (0.262"/pix) and letting the API oversample the lower-resolution layers produces clean, matched-FOV panels.
- MAST GALEX catalog returns source positions in `ra`/`dec` columns, not `ra_cent`/`dec_cent` (which are tile centers) — easy source of confusion.
- The 6.5% GALEX detection rate for redMaPPer BCGs was higher than expected. The NUV-r < 4.0 cut yields 635 candidates — a substantial sample for systematic study of star-forming BCGs.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
