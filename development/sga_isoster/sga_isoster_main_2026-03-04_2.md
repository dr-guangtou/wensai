---
date: 2026-03-04
tags:
  - development
  - dev/sga_isoster
---
# sga_isoster — Step 3e: YAML Config for SEP Masks — 2026-03-04

## Progress

- Implemented **Step 3e**: YAML configuration system for the SEP mask pipeline
- Restructured `SepDetectParams` dataclass to include dilation/exclusion parameters (`seg_rmin`, `obj_rmin`, `grow_sig`, `mask_thresh`, `grow_obj`) — each pass (hot/cold) now owns its full parameter set for independent tuning
- Added `load_sep_mask_config()` and `dump_sep_mask_config()` for YAML I/O using `pyyaml`
- Updated CLI with `--config` flag; precedence chain: dataclass defaults → YAML → CLI flags
- Pipeline now writes `output/sep_mask_config_used.yaml` sidecar after every run for reproducibility
- Per-pass detection/dilation params written to FITS HDU headers (`H_THRESH`, `C_KERSIG`, etc.)
- Created `config/sep_mask.yaml` (default config with inline docs) and `docs/sep_mask_parameters.md` (parameter reference)
- Added `pyyaml>=6.0` to `pyproject.toml`
- All 96 demo galaxies processed with 0 errors in all three test modes (no config, with config, config + CLI override)
- Merged `feature/sep-mask-yaml-config` into `main`

## Current State

### Config file has been manually tuned from defaults

The user edited `config/sep_mask.yaml` with new parameter values (not yet tested with pipeline run):

| Parameter | Original default | Current YAML |
|-----------|:---:|:---:|
| **Hot** thresh | 2.0 | **5.0** |
| **Hot** backsize | 50 | **10** |
| **Hot** min_area | 5 | **4** |
| **Hot** deblend_cont | 0.001 | **0.0001** |
| **Hot** grow_sig | 6.0 | **2.0** |
| **Cold** thresh | 1.5 | **3.0** |
| **Cold** backffrac | 0.5 | **0.2** |
| **Cold** min_area | 10 | **20** |
| **Cold** deblend_cont | 0.005 | **0.001** |
| **Cold** grow_sig | 6.0 | **4.0** |
| **Cold** mask_thresh | 0.02 | **0.01** |

These changes are uncommitted in the working tree.

### Key Issues

- 20/96 demo galaxies had >5% inner-zone masking with the old defaults — the tuned config above hasn't been evaluated yet
- Parameter tuning needs QA plot inspection to judge improvement
- `config/sep_mask.yaml` edits not yet committed

### Next Steps

- **Run pipeline with tuned YAML**: `uv run python scripts/build_sep_masks.py --input output/demo_sample.fits --config config/sep_mask.yaml`
- **Inspect QA plots** at `output/qa/sep_masks/` — focus on the 20 galaxies with high inner masking
- **Iterate on parameters** — the tuned config goes in a more aggressive direction (higher thresholds, tighter dilation); check if faint companions are still caught
- **Commit** the tuned config once parameters are satisfactory
- After tuning: rename GROUP_NAME → PGC ID, then proceed to Step 4 (isoster integration)

## Key Files

| File | Role |
|------|------|
| `config/sep_mask.yaml` | YAML config (currently manually tuned, uncommitted) |
| `docs/sep_mask_parameters.md` | Parameter reference with tuning guidelines |
| `scripts/sep_mask_builder.py` | Core mask builder (dataclasses, YAML I/O, FITS headers) |
| `scripts/build_sep_masks.py` | CLI entry point (`--config`, `--hot-thresh`, etc.) |
| `output/sep_mask_config_used.yaml` | Last-run effective config sidecar |

## How to Run

```bash
# With YAML config
uv run python scripts/build_sep_masks.py --input output/demo_sample.fits --config config/sep_mask.yaml

# With CLI override on top of YAML
uv run python scripts/build_sep_masks.py --input output/demo_sample.fits --config config/sep_mask.yaml --hot-thresh 3.0

# Skip plots for faster iteration
uv run python scripts/build_sep_masks.py --input output/demo_sample.fits --config config/sep_mask.yaml --skip-plots
```

## Lessons Learned

- Moving dilation/exclusion params into the per-pass dataclass was the right call — the cold pass needs wider dilation (`grow_sig=4.0`) while hot works better with tighter masks (`grow_sig=2.0`)
- YAML sidecar (`sep_mask_config_used.yaml`) is essential for reproducibility — without it, CLI overrides are lost
- CLI dilation flags applying to both passes preserves backward compatibility while YAML enables per-pass control

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
