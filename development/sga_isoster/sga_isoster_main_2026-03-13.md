---
date: 2026-03-13
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — main — 2026-03-13

## Progress

- **Tuned SEP parameters via interactive mask tuner**: Applied user-optimized detection parameters from the Panel-based mask tuner to both hot and cold passes in `config/mask.yaml`
  - Hot: thresh=4.5, backsize=0.02, backfilt=5, kern_sig=1, deblend_cont=0.001, grow_sig=1.0, mask_thresh=0.001
  - Cold: thresh=4, backsize=0.05, backfilt=2, kern_sig=3, deblend_cont=0.020, grow_sig=2.5, mask_thresh=0.01
  - Global: `use_err_map=false`
- **Implemented SEP hot fallback to Tractor masks**: When the SEP hot pass produces >15% mask fraction in the inner zone (r_ell < 0.5 * MAJORAXIS), it falls back to Tractor-based masks with a 40px avoidance radius
  - Configurable via `fallback_inner_thresh` and `fallback_tractor_avoidance` in `config/mask.yaml`
  - Demo run: 15/96 galaxies triggered fallback
- **Added three QA flags on the final combined mask**:
  - `flag_cen_pix_mask`: central 3x3 pixels contain a masked pixel (0/96)
  - `flag_inner_mask_high`: inner zone mask fraction >15% (1/96 — PGC2082566)
  - `flag_full_mask_high`: full image mask fraction >20% (1/96)
  - Flags propagated to FITS headers, inventory table, markdown report, and CLI summary
- **Reorganized data layout**:
  - Renamed `data/fits/` to `data/demo/` for clarity
  - Moved mask FITS into per-galaxy folders (co-located with images, invvar, PSF, etc.)
  - Moved demo summary files (inventory, report, QA plots) to `data/demo/`
  - Cleaned up `output/` — removed obsolete SEP-only outputs
- **Removed obsolete files from git**:
  - `config/sep_mask.yaml` (superseded by unified `config/mask.yaml`)
  - `scripts/build_sep_masks.py`, `scripts/sep_mask_plots.py` (superseded by `build_masks.py`)
  - `scripts/diagnose_maskbits.py`, `scripts/diagnose_pa.py` (one-off diagnostics, served their purpose)
  - Note: `scripts/sep_mask_builder.py` kept — still imported by the unified pipeline

## Current State

- **Branch**: `main` (clean, 2 commits ahead of origin)
- **Demo run results** (96 galaxies, 0 errors):
  - Combined mask mean: 5.4%, median inner: 0.0%, max inner: 15.2%
  - 15/96 SEP hot fallback to Tractor
  - Each galaxy folder in `data/demo/` now has 13 files: 12 FITS products + 1 mask

### Masking Strategy (finalized)

1. Bad pixel (DR9 maskbits): always on
2. Bright star halos: off by default
3. SEP cold pass: always on (tuned for extended sources)
4. SEP hot pass: on by default; falls back to Tractor when inner >15%
5. Tractor-only masks: fallback-only

### Key Issues

- 1 galaxy (PGC2082566) still flagged with inner >15% after all masking — may need manual inspection
- Production sample (1,998 galaxies) not yet downloaded or processed

### Next Steps

- Update `docs/todo.md` to reflect step 3f completion and current focus
- Proceed to Step 4: isoster integration — connect the mask pipeline to `../isoster` for 1-D surface brightness profile extraction
- Download production sample when ready (~2.4 GB)

## Lessons Learned

- The interactive mask tuner (Panel/Bokeh) was effective for parameter optimization — visual comparison across multiple galaxies quickly revealed that the original cold pass (thresh=1.5, 14% masking) was far too aggressive
- Fallback mechanism is important: 15/96 demo galaxies needed it, suggesting the hot pass parameters are tuned for the majority but not universally safe
- Co-locating masks with image data simplifies downstream analysis — one folder per galaxy with all products

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
