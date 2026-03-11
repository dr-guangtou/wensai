---
date: 2026-03-05
tags:
  - development
  - dev/sga_isoster
---
# sga_isoster — feature/component-qa-plot — 2026-03-05

## Progress

- **2×4 component QA plot** (`sep_mask_plots.py`): added `plot_sep_component_qa()` — a per-galaxy 8-panel breakdown showing each mask component separately:
  - Row 1 (infrastructure, not SEP-tunable): r-band | bad pixel (maskbits) | bright star halos | Tractor model
  - Row 2 (SEP-tunable): hot | cold | SEP combined | color-coded overlay
  - Each mask panel shows fraction masked in the title; overlay uses additive color tints (yellow=bad pixel, magenta=bright star, cyan=Tractor, orange=hot, blue=cold)
  - Output: `output/qa/sep_components/{group_name}.png`, generated automatically alongside existing 5-panel plots
- **Fixed `backffrac` → `backfilt`**: the old code computed `fw = int(backsize * backffrac)` which was wrong — `fw`/`fh` are in units of mesh cells (integer), not pixels. Renamed to `backfilt` (int); defaults: 1 (hot), 3 (cold)
- **`use_err_map` toggle** (global config): when `false`, the inverse-variance map is not loaded; instead, a global RMS is estimated via SEP (detect sources at 2.5σ, mask them, re-estimate background on masked image, return `bkg.globalrms`). Threshold becomes `thresh * global_rms`
- **`subtract_bkg` toggle** (per-pass): when `false`, detection runs on the raw image without background subtraction — useful for diagnosing whether background modeling interferes with detection
- **`kern_sig` default → `None`**: SEP's built-in 3×3 matched filter is now the default; set `kern_sig` to a float for a custom Gaussian kernel
- **`use_obj_mask` toggle** (per-pass): object-catalog elliptical masks are now optional (off by default); segmentation mask alone is the primary mask
- **`use_relative_size` toggle** (global config): when `true`, `backsize`, `seg_rmin`, and `obj_rmin` are interpreted as fractions of image width — critical for handling the SGA-2020 dataset where image sizes range from ~200 to ~4000 pixels

## Current State

### Key Configuration (latest tuning round)
- `use_relative_size: true`, `use_err_map: true`
- Hot: `thresh=5.5`, `backsize=0.05`, `kern_sig=3`, `seg_rmin=0.05`
- Cold: `thresh=1.5`, `backsize=0.1`, `subtract_bkg=false`, `seg_rmin=0.2`
- All 96 demo galaxies process with 0 errors

### Key Issues
- SEP detection still being tuned — the component QA plot now makes it much easier to isolate which mask layer is responsible for under/over-masking
- Not yet committed — all changes are on `feature/component-qa-plot` branch as uncommitted work

### Next Steps
- Finalize SEP mask parameter tuning using the new component QA plots
- Commit and merge `feature/component-qa-plot`
- Rename `GROUP_NAME` → PGC ID (deferred from previous session)
- Step 4: isoster integration

## Lessons Learned
- SEP's `fw`/`fh` parameters are filter widths in units of background mesh cells, not pixels — the previous `backffrac` (fraction-of-backsize) approach was semantically wrong and produced unexpected filter sizes
- For datasets with widely varying image sizes, relative/fractional parameters are essential — a single pixel value for `backsize` or `seg_rmin` cannot work across 200px and 4000px images
- The inverse-variance map is not always the best noise estimate; the SEP-based global RMS (detect→mask→re-estimate) provides a more robust alternative
- Component-level QA plots are far more useful for parameter tuning than a single combined overlay — you need to see which layer is doing what

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
