---
date: 2026-03-01
repo: isophote_test
branch: main
tags:
  - journal
  - huang2013
  - hsc
  - production
  - testing
---

## Progress

- Merged the repo-cleanup work to `main` as `e197a77 Reorganize inputs and consolidate repo documentation`.
- Merged the HSC sky-calibration work to `main` as `b0bcc12 Add HSC sky calibration workflow and validation assets`.
- Added `scripts/hsc_sky_calibration.py`, canonical `inputs/data/cosmos_wide_sky.csv` and `inputs/data/cosmos_dud_sky.csv`, and `tests/test_hsc_sky_calibration.py`.
- Ran the full 30-region HSC `i`-band calibration for `wide` and `dud` and wrote outputs under `output/hsc_sky_calibration_full_run/`.
- Reworked the Huang2013 production workflow to be manifest-driven in `inputs/huang2013/scripts/generate_huang2013_mocks.py`.
- Added canonical Huang2013 production manifests in `inputs/huang2013/runs/` for baseline, HSC `i`-band `wide`, and HSC `i`-band `dud`.
- Added Huang2013 workflow docs in `inputs/huang2013/README.md` and updated active repo docs in `README.md`, `inputs/README.md`, `docs/QUICK_REFERENCE.md`, `docs/LESSON.md`, and `docs/todo.md`.
- Added `re_overall` to `inputs/huang2013/models/huang2013_models.yaml` and updated sizing in `mockgal.py` to anchor Huang2013 image size on that galaxy-level radius.
- Added focused manifest tests in `tests/test_generate_huang2013_mocks.py` and extended `tests/test_mockgal.py` for `re_overall` and engine fallback behavior.
- Fixed the remaining focused test failures by restoring the missing `load_model_file` import, making `engine="auto"` ignore unusable `profit-cli` binaries, and making the visualization colorbar label valid under LaTeX-backed matplotlib.
- Merged the Huang2013 production refactor to `main` as `1ddcf56 Refactor Huang2013 production workflow and harden focused tests`.
- Added copy-paste production commands for the first Huang2013 galaxy and the full baseline run to `inputs/huang2013/README.md`.
- Verified the final focused scope with `75 passed, 5 skipped`.

## Lessons Learned

- Huang2013 production runs are easier to maintain as explicit YAML manifests than as hardcoded `mock1/2/3/4` script logic.
- Huang2013 image sizing should use `re_overall` instead of the single largest component radius to avoid oversized images.
- The baseline reference row should stay low-noise rather than perfectly noise-free because downstream fitting behaves unrealistically on zero-noise images.
- `size_factor` should stay explicit on every manifest row because different redshift and noise regimes may need different image extents.
- HSC `i`-band `wide` and `dud` calibration values should remain Huang2013-scoped references and be copied into manifests directly, not resolved from named runtime profiles.
- In this environment, `engine="auto"` must treat `profit-cli` as unavailable if the binary exists but fails its dynamic-library health check.
- Matplotlib labels used in tests need to be valid when `text.usetex=True`; plain `arcsec^2` text was enough to break the visualization tests here.
- `LIBPROFIT_PATH` still has to be exported manually as `/Users/shuang/Dropbox/work/project/otters/isophote_test/libprofit/mbp` before libprofit-backed runs in this shell.

## Key Issues

- The canonical Huang2013 baseline production run is ready to execute manually, but the operator still needs to export a working `LIBPROFIT_PATH` in the run shell.
- The local `main` branch is ahead of `origin/main` by one commit after merging `1ddcf56`; push is still pending.
- The local `profit-cli` binary is no longer a test blocker in `auto` mode, but its dylib linkage is still broken if true libprofit execution is required in this shell.
