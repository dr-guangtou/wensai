---
date: 2026-03-31
tags:
  - development
  - development/star_forming_clusters
---

# star_forming_clusters — feature/galex-query-test — 2026-03-31

## Progress

- Fixed machine-dependent paths across all GALEX scripts (`redmapper_galex_xmatch.py`, `plot_richness_vs_nuv_r.py`, `plot_cutout_triplet.py`). Scripts now auto-detect the Dropbox root based on `Path.home()` (`/Users/shuang/Dropbox` on M1 Max MacBook Pro, `/Users/mac/Dropbox` on the other machine).
- Built an interactive browser-based visual classifier (`galex/visual_classifier.py`) for the 1,366 GALEX-matched BCGs:
  - Single-file Flask server serving embedded HTML/JS.
  - Three-panel cutout display (LS DR10 / GALEX / VLASS) fetched live from the LegacySurvey API, with FOV = 300 kpc at each object's redshift (Planck 2015 cosmology, rounded up to nearest arcsec).
  - Six classification categories: significant, detected, marginal, too-faint, contamination (mutually exclusive radio-button group), plus radio-detection (independent toggle).
  - Keyboard shortcuts (arrow keys, 1-6 for categories, Enter to jump).
  - Optional one-line note per object.
  - Auto-saves to `classifications.json` on every change; resumes at last-viewed object on restart.
  - Export button appends boolean classification columns and notes to the FITS catalog.
  - Graceful fallback for missing cutouts (e.g., VLASS or GALEX coverage gaps show "No coverage" instead of broken image).
- Created `galex/download_cutouts.py` for bulk downloading cutout images locally (sequential, one request at a time to be polite to the LS server). Supports `--resume` to skip already-downloaded files.
- Added `--local` flag to the classifier to serve from pre-downloaded images instead of live API, for faster classification sessions.
- Updated `.gitignore` to exclude `galex/cutouts/`.

## Current State

### Key Issues
- No commits made yet on this branch for today's work — all changes are uncommitted.
- The classification categories were iterated on multiple times during development (solid/too-faint/star/nearby-galaxy/radio-detection -> added missing-galex -> final: significant/detected/marginal/too-faint/contamination/radio-detection). Any test `classifications.json` files from earlier iterations should be deleted before starting real classification work.
- GALEX imaging coverage gaps exist: some catalog-matched BCGs show no GALEX image in the LS viewer, motivating the "No coverage" fallback.

### Next Steps
- Download all 1,366 x 3 cutouts using `download_cutouts.py`.
- Begin systematic visual classification of the matched sample.
- Apply quality cuts after classification (S/N >= 3, artifact flags).
- Investigate redshift-dependent UV color thresholds (current NUV-r < 4 cut is observed-frame).
- Cross-check BCG centering probabilities for the matched sample.

## Lessons Learned
- The LegacySurvey cutout API is convenient but slow for interactive classification of large samples — pre-downloading images locally makes a significant difference in usability.
- GALEX GUVcat catalog entries do not always have corresponding imaging in the LS viewer database, creating a mismatch that users need to flag during visual inspection.
- Classification category design benefits from hands-on testing before finalizing — the initial categories were too focused on failure modes rather than UV detection quality levels.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
