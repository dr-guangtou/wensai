---
date: 2026-03-14
tags:
  - development
  - development/isoster
---

# isoster — fix/fits-config-asdf — 2026-03-14

## Progress

- Addressed Codex review issue #5: `isophote_results_to_fits()` was writing all 49 `IsosterConfig` fields as raw FITS header keywords, with 30 exceeding the 8-character limit and triggering 166 `VerifyWarning` messages about HIERARCH promotion.
- Replaced the header-keyword approach with a 3-HDU FITS layout:
  - HDU 0: `PRIMARY` (empty, unchanged)
  - HDU 1: `ISOPHOTES` BinTableHDU (isophote data columns — unchanged)
  - HDU 2: `CONFIG` BinTableHDU (two columns: `PARAM`, `VALUE` with JSON-serialized config)
- Result: **zero VerifyWarnings**, **zero HIERARCH keywords** in output FITS files.
- Added full config recovery on read — `isophote_results_from_fits()` now reconstructs an `IsosterConfig` object from the CONFIG HDU. Legacy files (without CONFIG HDU) still return `config=None` for backward compatibility.
- Implemented ASDF support as an optional alternative format:
  - `isophote_results_to_asdf()` / `isophote_results_from_asdf()` with lazy `import asdf` and helpful `ImportError` messages.
  - ASDF handles nested config natively (no JSON serialization needed in the tree).
- Wired ASDF into all file-consuming code paths:
  - `isoster/cli.py` — `.asdf` extension detection for `--output`
  - `isoster/driver.py` — `_resolve_template()` dispatches on `.asdf` vs `.fits` extension for template-based forced photometry
  - `isoster/__init__.py` — exports both ASDF functions
- Added `asdf>=3.0` as an optional dependency (`[asdf]` extra group, also in `[dev]`).
- Wrote `_NumpyEncoder` (JSON encoder for numpy scalars) to handle `model_dump()` output safely.
- Updated `docs/spec.md` (new FITS HDU layout section) and `docs/user-guide.md` (FITS + ASDF usage examples).
- Created 15 tests in `tests/unit/test_io.py`:
  - FITS: no HIERARCH warnings, 3-HDU structure, round-trip with config recovery, data fidelity, complex values (lists/dicts), None values, overwrite, empty isophotes
  - Legacy backward compat: old-format FITS returns `config=None`
  - ASDF: round-trip, config recovery, import guard (monkeypatched)
  - `_resolve_template` with ASDF file path
  - Internal helpers: numpy scalar encoding, empty config
- Created `examples/example_io_validation/validate_fits_asdf.py` — end-to-end validation on real NGC3610 r-band (256x256):
  - Fit with EA + simultaneous harmonics [3,4,5,6,7] → 60 isophotes, 59 converged
  - Saved to both FITS (40,320 bytes) and ASDF (62,972 bytes)
  - Reloaded from both formats — **PERFECT match** on all 60 isophotes and all 49 config fields
  - Generated 3 QA figures (from original, FITS-reloaded, ASDF-reloaded) — visually identical
- Updated one existing test assertion in `test_template_forced.py` (`config is None` → `isinstance(config, IsosterConfig)`) since the reader now recovers config.

## Current State

- **Branch**: `fix/fits-config-asdf` — all changes uncommitted (9 files, +430/-71 lines)
- **292 tests passing** (291 base + 1 new `_resolve_template` ASDF test), 5 deselected, 4 warnings (all pre-existing, zero VerifyWarning)
- Full test suite runs in ~62 seconds

### Key Issues

- None — all validation passed cleanly.

### Next Steps

- Commit and merge (pending approval).
- Remaining Codex review items from `docs/review_codex_20260313.md` (issues 3-4 were already fixed in prior sessions: harmonic auto-detection in `model.py` and bounds check in `fit_central_pixel`). Issue 5 (this session) was the last one.
- Untracked docs to decide on: `docs/gradient-free-fallback-issue-report.md`, `docs/review_codex_20260313.md`, `docs/review_gemini_20260312.md`.

## Lessons Learned

- FITS header keywords are limited to 8 characters by the standard; longer names get HIERARCH promotion which produces warnings. Storing config in a dedicated binary table extension is cleaner and eliminates the noise entirely.
- JSON serialization of config values handles the full type spectrum (None, bool, lists, dicts, numpy scalars) with a single encoder, whereas FITS headers need per-type handling and can't represent None or nested structures.
- ASDF is heavier on disk (~1.6x for this dataset) but handles nested Python objects natively — good for archival but not necessary for simple workflows.
- When changing a writer's output format, grep for all readers (including indirect consumers like `_resolve_template`) to ensure ASDF support is wired through all code paths.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
