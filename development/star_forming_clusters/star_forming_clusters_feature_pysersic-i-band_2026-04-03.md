---
date: 2026-04-03
tags:
  - development
  - development/star_forming_clusters
---

# star_forming_clusters — feature/pysersic-i-band — 2026-04-03

## Progress

- **Iterative interloper fitting pipeline** (`fit_interlopers.py`): built and ran a 3-round progressive detection+fitting pipeline on the BCG residual (5sigma -> 3.5sigma -> 3sigma). Fitted 12 sources total. Central fractional residual improved from 12.7% (BCG-only) to 5.5% (BCG+interlopers) within 50 kpc. RMS improvement of 79%.
- **2-component decomposition attempt for Source 1** (brightest interloper at 323, 348): tried FitMulti, doublesersic, and sequential approaches. All failed — FitMulti/doublesersic diverge with shared centroids; sequential suffers from parameter coupling (over-subtraction). Concluded the single Sersic n=3.0 is the practical best for this source within the n<=3 constraint.
- **Pre-fitting QA figure** (`qa_pre_fitting.py`): built a diagnostic figure with three-color composite, BCG residual with source peaks, segmentation map (top row), and per-group cutouts with color-coded mask layers (bottom rows). Iteratively refined: larger FOV (adaptive to farthest source), source grouping by segment proximity, three mask layers shown as red/blue/green overlays.
- **Source grouping algorithm**: implemented connected-component grouping based on dilated segment overlap or centroid proximity (default 10px). At 5sigma: G1=[1,5], G3=[3,6] are natural pairs; 5 singletons.
- **Object mask bug fix — three iterations**:
  1. First fix: replaced per-source protection (disk(10) dilation) with clean ellipse cut (`& ~inside_ellipse`). Eliminated thin filament artifacts but introduced hard-edge truncation.
  2. Identified the real problem: the ellipse cut "carves a hole" rather than deciding per-source. Tested two proper approaches.
  3. Final fix: per-source exclusion BEFORE dilation. Two modes: "centroid" (exclude if centroid inside ellipse) and "segment" (exclude if segment touches ellipse, more aggressive). Chose "segment" as default.
- **Bad pixel mask**: removed SENSOR_EDGE (bit 15) — too aggressive, was masking large swaths near chip boundaries including a prominent vertical bar through the fitting region.
- **Regenerated all masks and QA figures** for all 5 bands (g/r/i/z/y) after each fix.

## Current State

### Key Files Modified/Created
- `hsc/pysersic/fit_interlopers.py` — iterative interloper fitting (committed earlier session)
- `hsc/pysersic/qa_pre_fitting.py` — pre-fitting diagnostic figure
- `hsc/step3_object_mask.py` — per-source exclusion logic
- `hsc/config_image_prep.yaml` — removed SENSOR_EDGE, added `exclusion_mode: segment`

### Pipeline Output (i-band)
- BCG 2+2 model: central frac_resid = 5.7% (50 kpc)
- BCG + 12 interlopers: central frac_resid = 5.5% (50 kpc)
- Residual/noise ratio at 50 kpc: 1.61 (approaching noise-dominated)
- 10/12 sources at noise level; Source 1 (n=3 boundary) and Source 2 (barely resolved) elevated

### Key Issues
- Source 1 (323, 348): brightest companion, Sersic hits n=3.0 cap. Residual ratio 2.3. Joint multi-component fitting not feasible with pysersic due to shared-centroid divergence.
- The interloper fitting results from the earlier session need to be re-run with the updated object masks (SENSOR_EDGE removal + per-source exclusion changed the masks).
- BCG model itself may need re-fitting with the updated masks for full consistency.

### Next Steps
- Re-run the full fitting pipeline (BCG + interlopers) with the corrected masks
- Use the source grouping to fit grouped sources simultaneously (FitMulti with separated centroids)
- Assess whether the remaining central residual structure represents real asymmetric merger features
- Extend to other bands (g, r, z, y) for multi-band photometry

## Lessons Learned
- **Sequential multi-component fitting fails for galaxies** due to parameter coupling — each component absorbs the other's flux. Joint fitting (FitMulti) is required, but pysersic diverges when sources share identical initial positions.
- **Object mask exclusion must be per-source, not geometric**: cutting a hole in the combined mask either leaves artifacts (if protection is too small) or truncates real structure (if using a clean cut). The correct approach is to decide which sources contribute to the mask before any dilation.
- **"Segment touches ellipse" is more aggressive but cleaner** than centroid-based exclusion: it catches boundary-straddling sources whose dilated halos would otherwise leak into the analysis region.
- **SENSOR_EDGE flag** in HSC pipeline data is overly aggressive for coadded images — it masks large contiguous regions near sensor boundaries that are actually usable in coadds.
- **Pre-fitting QA is essential**: the color-coded mask decomposition (red=badpix, blue=objmask, green=neighbors) immediately revealed the object mask problem that was invisible in the combined mask view.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
