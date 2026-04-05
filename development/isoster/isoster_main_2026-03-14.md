---
date: 2026-03-14
tags:
  - development
  - development/isoster
---

# isoster — main — 2026-03-14

## Progress

### Docs reorganization (Codex review issue #7)
- Reorganized public docs into numbered files: `docs/00-index.md` through `docs/06-qa-functions.md`
- Moved agent-internal docs to `docs/agent/` (untracked via `.gitignore`)
- Untracked `site/` build output and Dropbox conflicted copies
- Updated `CLAUDE.md` with complete documentation index table
- Updated CITATION.cff

### FITS config HDU + ASDF support
- Moved config storage to a dedicated FITS HDU
- Added ASDF serialization support for config

### Test suite hardening (Codex review issue #9)
- Added 18 new tests across 7 files, bringing total from 292 to 310
- **Stop code coverage** (`test_fitting.py`): dedicated `TestStopCodes` class testing all 4 stop codes (0=converged, 2=maxit, 3=too-few-points, -1=gradient error)
- **OOB center** (`test_edge_cases.py`): `fit_image()` with x0=500 on 100x100 image returns gracefully with non-zero stop codes
- **Sampling** (`test_sampling.py`): EA sampling distribution, mask exclusion, linear vs geometric step modes, large SMA safety, SMA=0 behavior
- **Convergence** (`test_convergence.py`): conver threshold effect on iterations, maxgerr behavior at outer radii, maxit exhaustion → stop_code=2, geometry_convergence + convergence_scaling interaction
- **Public API** (`test_public_api.py`): fit_image return keys, FITS round-trip, optimize facade importability
- **Tightened assertions**: model accuracy `places=1` → `places=2`, PA axis difference >10% magnitude check, sampling count check instead of `> 0`, uniform → heteroscedastic variance in WLS test
- Added magic number comments explaining numerical thresholds
- Added docstrings distinguishing unit-level (Pydantic) vs integration-level (driver) config validation

## Current State

### Key Issues
- All 310 tests passing, 5 deselected, 4 warnings (expected: FutureWarning from deprecated API test, Pydantic validation warning, RuntimeWarning from degenerate input)
- Ruff clean
- Codex review issues #1-4, #7, #9 addressed; remaining branches: `main` only, plus `origin/leyao` (someone else's)

### Next Steps
- Push changes to remote
- Address any remaining Codex/Gemini review items if needed
- Consider performance/stress tests (out of scope for current release-readiness pass)

## Lessons Learned
- `extract_isophote_data` at SMA=0 still produces 64 samples (all at center) — it does not return empty. Central pixel is handled separately by `fit_central_pixel` in the driver.
- The `isoster.optimize` module is a pure facade with no re-exports — testing importability is the right check, not function existence.
- FITS I/O functions live in `isoster.utils`, not `isoster.io` — caught during test run.
- Heteroscedastic variance matters for WLS tests: uniform variance is mathematically equivalent to OLS with a constant scaling factor, so it does not actually exercise the WLS weighting logic.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
