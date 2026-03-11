---
date: 2026-03-04
tags:
  - development
  - dev/sga_isoster
---
# sga_isoster — Step 3d: SEP-based object masks — 2026-03-04

## Progress

- Implemented SEP-based (Source Extractor as Python library) object mask builder as a complement to the existing Tractor-based masks
- Added `sep-pjw>=1.3.3` dependency to `pyproject.toml`
- Created three new modules:
  - `scripts/sep_mask_builder.py` (~350 lines) — core detection, exclusion, dilation, and orchestration logic
  - `scripts/build_sep_masks.py` (~160 lines) — CLI with configurable pass selection and parameter overrides
  - `scripts/sep_mask_plots.py` (~150 lines) — 5-panel per-galaxy QA plots (r-band | hot | cold | combined | overlay) and summary scatter
- Hot/cold two-pass detection strategy: hot pass (thresh=2.0, backsize=50) catches faint small sources; cold pass (thresh=1.5, backsize=110) catches extended diffuse features
- Central galaxy exclusion uses elliptical distance (seg_rmin=100 px, obj_rmin=15 px), properly accounting for galaxy shape and PA
- Added central avoidance zone feature (radius=8 px): flags when any detection touches the zone (`central_contaminated`), optionally removes those detections (`--no-avoid-central` to keep them for cases like bright star contamination)
- Multi-HDU FITS output: HDU 0 = combined, HDU 1 = hot, HDU 2 = cold — enables QA comparison of individual passes
- Created `.claude/skills/object-mask.md` documenting masking patterns, parameter tuning guide, and gotchas
- Full demo run: 96/96 galaxies, 0 errors, ~25 seconds
- Merged `feature/sep-masks` into `main`

## Current State

### Key Metrics
- Inner zone mask fraction: median 0.0%, max 57.4% (ESO484-017)
- 20/96 galaxies have >5% inner masking (vs 8 with Tractor masks — SEP is more aggressive at detecting faint sources)
- Total detections: 1,566 hot + 953 cold across 96 galaxies
- Central avoidance: 7/96 galaxies flagged, 12 detections removed

### Key Issues
- SEP masks are more aggressive than Tractor masks — 20 galaxies with >5% inner masking vs 8 with Tractor. Parameter tuning (seg_rmin, obj_rmin) may help, but visual QA comparison is the real judge
- ESO484-017 has 57.4% inner masking — likely a genuine bright star contamination case where the mask is appropriate

### Next Steps
- Rename files/folders from GROUP_NAME to PGC catalog ID (GROUP_NAME contains `+`, `-` characters)
- Step 4: isoster integration — connect to `../isoster` for 1-D surface brightness profile extraction
- Visual comparison of SEP vs Tractor masks on the 8 galaxies that had issues with Tractor masks
- Production sample download (1,998 galaxies, ~2.4 GB)

## Lessons Learned
- SEP requires native byte order (little-endian on x86); FITS data is big-endian — always `byteswap().newbyteorder()`
- SEP `filter_kernel` must be float64 and C-contiguous (`np.ascontiguousarray`)
- SEP segmap labels are 1-indexed (0 = background) — important when mapping catalog indices to segment labels
- Central avoidance zone should be optional, not mandatory: bright stars genuinely contaminating the center should produce a mask that warns the user no useful data exists
- Reusing dataclasses and functions from the Tractor mask builder (`mask_builder.py`) kept the codebase DRY and consistent

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
