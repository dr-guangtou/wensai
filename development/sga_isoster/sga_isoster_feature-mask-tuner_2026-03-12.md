---
date: 2026-03-12
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — feature/mask-tuner — 2026-03-12

## Progress

- Built an interactive browser-based mask tuner using Panel (Bokeh backend) for comparing Tractor vs SEP masks side-by-side
- Created 4 new modules under `interactive/mask_tuner/`:
  - `data_cache.py` — galaxy FITS data loading with `lru_cache(maxsize=3)` to avoid re-reading on parameter changes; handles optional invvar/error map gracefully (falls back to global RMS estimation)
  - `image_display.py` — asinh stretch (matching existing `mask_plots._scale_image`), RGBA overlay compositing with color-coded layers (yellow=bad_pixel, magenta=bright_star, cyan=tractor, blue=SEP), Bokeh `image_rgba` figure helpers
  - `mask_compute.py` — thin wrappers around `mask_builder` and `sep_mask_builder` functions (no duplicated logic)
  - `app.py` — main Panel app with galaxy dropdown (96 demo galaxies), two-column image display with linked pan/zoom, full SEP parameter controls (detection, deblending, exclusion, dilation), Tractor avoidance radius slider, bad_pixel/bright_star toggle checkboxes
- Added `panel>=1.4.0` dependency to `pyproject.toml`
- Layout: images aligned horizontally at top for direct comparison, controls grouped below with a divider
- Zone statistics displayed below each image (inner/annulus/full masked fractions + source counts)
- Wrote `README.md` documenting all controls, color legend, architecture, and data requirements
- End-to-end verified: module imports, synthetic data rendering, real galaxy data (PGC1552910: Tractor 13 contaminants at 2.2%, SEP 4 detected at 7.8%), and full Panel app loading

## Current State

### Branch
- `feature/mask-tuner` — all files created, not yet committed
- Modified: `pyproject.toml`, `uv.lock`
- New: `interactive/mask_tuner/` (5 files: app.py, data_cache.py, image_display.py, mask_compute.py, README.md)

### Key Issues
- Default SEP cold parameters (thresh=1.5, grow_sig=3.0) still produce ~14% mean masking on the demo sample — the whole point of this tool is to find better parameters interactively
- No preset save/load mechanism yet — good parameter sets must be manually transferred to `config/mask.yaml`

### Next Steps
- Commit and merge the mask tuner feature branch
- Use the tuner to systematically compare Tractor vs SEP masking across multiple galaxies
- Find optimal SEP parameters that balance contamination removal vs over-masking
- Transfer tuned parameters back to `config/mask.yaml` for batch pipeline runs
- Consider adding a "Save config" button that writes current SEP params to YAML

## Lessons Learned
- Panel/Bokeh `image_rgba` expects uint32 packed as R|G<<8|B<<16|A<<24 (little-endian) — got this right on first try by reading Bokeh docs carefully
- Linking Bokeh figure ranges (`sep_fig.x_range = tractor_fig.x_range`) is the simplest way to sync pan/zoom — no callbacks needed
- Data path was `data/fits/` not `data/` — caught by end-to-end test before serving
- The invvar (error map) file is optional: when absent, SEP estimates global RMS internally via `_estimate_global_rms()`, so the pipeline degrades gracefully
- `functools.lru_cache` needs hashable args — used a `galaxy_tuple` (name, ra_dir, sga_id) instead of the Galaxy dataclass directly

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
