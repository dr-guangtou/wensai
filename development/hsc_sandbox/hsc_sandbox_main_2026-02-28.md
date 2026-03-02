---
date: 2026-02-28
repo: hsc_sandbox
branch: main
tags:
  - journal
  - hsc_sandbox
  - side1
  - development
---

## Progress

- Created the `side1` implementation for unified HSC DR4 cutout and PSF downloads with CLI entry point `side1/python/hsc_image_psf_downloader.py`.
- Added shared downloader modules for auth loading, input parsing, retry handling, tar extraction, manifest writing, cutout requests, and PSF requests.
- Added `side1` project docs: `docs/plan/PLAN_SIDE1_IMAGE_PSF_DOWNLOADER.md`, `docs/TODO.md`, `docs/LESSON.md`, and `docs/command/SIDE1_USAGE.md`.
- Added automated tests for parsing, request validation, tar-member parsing, offline functional behavior, and opt-in live service validation under `side1/tests`.
- Ran offline validation successfully with Ruff and `uv run pytest side1/tests -k 'not live'`.
- Ran authenticated live tests successfully with `SIDE1_ENABLE_LIVE_TESTS=1 uv run pytest side1/tests/test_hsc_live_integration.py`; the corrected live suite passed `7` cases.
- Ran a real cutout smoke test with `--type coadd/bg` and saved the FITS output plus manifest under `side1/tests/live_smoke_output` during validation; generated files were later removed from the committed tree.
- Updated cutout defaults so `mask=true` and `variance=true` by default.
- Implemented explicit local rejection for cutout `warp` requests because the service returns a tar archive of warped exposures and that workflow is out of scope for `side1`.
- Committed the feature work on branch `feature/side1-image-psf-downloader` as `4400bfe` and merged it back into `main` as merge commit `be15c1f`.

## Lessons Learned

- The NAOJ cutout and PSF reference scripts duplicate substantial logic; a shared client layer was necessary to avoid maintaining parallel parsers and HTTP code.
- The HSC cutout service supports `coadd`, `coadd/bg`, and `warp`, but `warp` is a special archive-returning case and should not be treated like a normal FITS cutout workflow.
- The DR4 PSF service does not support older `dud` reruns; live probes returned `404` for PSF requests on `s19a_dud`, `s20a_dud2`, and `s21a_dud2`.
- Positive live validation is asymmetric: cutout positive cases succeeded on `s23b_wide` and `s21a_dud2`, while PSF positive cases succeeded on `s23b_wide`.
- The negative coordinate at `RA=151.356722`, `Dec=7.56403` was handled gracefully without crashing.
- The cutout request body now includes `image`, `mask`, and `variance` flags explicitly, and the manual needed to document those defaults because they were easy to miss from the initial usage examples.

## Key Issues

- `main` still has unrelated local changes outside `side1`: `roadmap/ROADMAP.md`, untracked `roadmap/SIDE1.md`, and untracked `step1/docs/journal/2026-02-28_handover.md`.
- No known functional blockers remain for `side1` after the merge to `main`.
- If future `side1` work expands to warped exposures, the current local `NotImplementedError` for cutout `warp` should be replaced with an archive-aware workflow and tests.
