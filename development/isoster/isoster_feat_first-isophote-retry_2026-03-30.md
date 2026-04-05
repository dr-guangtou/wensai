---
date: 2026-03-30
tags:
  - development
  - development/isoster
---

# isoster — feat/first-isophote-retry — 2026-03-30

## Progress

- Reviewed all 9 Codex review issues (2026-03-13) — confirmed all were already resolved in prior sessions. Updated `docs/agent/todo.md` with fix commit hashes and final test/warning counts (310 passed, 5 warnings).
- Implemented **first isophote failure detection**: when the first N isophotes (default N=3) all fail, `fit_image()` now emits a `FIRST_FEW_ISOPHOTE_FAILURE` RuntimeWarning and sets `result["first_isophote_failure"] = True`.
- Implemented **optional retry mechanism** (`max_retry_first_isophote`, default 0 = disabled): retries the first isophote with perturbed `sma0` and initial geometry (`eps`, `pa`) using a fixed perturbation schedule (shrink/grow sma0, try near-circular, rotate PA).
- Refactored the first-isophote growth-gate in `driver.py` from a simple `first_iso` check to an `anchor_iso` pattern that also probes subsequent growth steps before declaring failure.
- Added `_first_isophote_perturbations()` helper with a 10-entry perturbation schedule.
- Added 2 new config fields to `IsosterConfig`: `max_retry_first_isophote` (int, 0-20) and `first_isophote_fail_count` (int, 1-10).
- Wrote 13 new integration tests covering failure detection, retry success/exhaustion, backward compatibility, and config validation.
- Updated 1 existing unit test (`test_fit_image_skips_inward_growth_when_first_isophote_fails`) to account for the new probe behavior.
- Ran performance benchmark on IC3370_mock2 (1133x1133) and ngc3610 (256x256): **+0.25%** and **+0.61%** overhead respectively — within noise, well under 1% threshold.
- Documented new config fields and result dict keys in `docs/01-user-guide.md`.

## Current State

### Key Numbers
- 323 tests passed, 5 deselected, 0 failures
- Performance overhead: <1% on both test images
- Branch is uncommitted — all changes are staged and verified

### Key Issues
- None — feature is complete and tested

### Next Steps
- Commit and merge `feat/first-isophote-retry` after user approval
- Consider whether the Huang2013 external retry wrapper (`examples/example_huang2013/run_huang2013_profile_extraction.py`) should be updated to use the new built-in retry
- Gradient-free fallback (future.md item #4) remains the last major roadmap item

## Lessons Learned
- Testing retry logic with real images is unreliable because exponential profiles have gradient everywhere. Monkeypatching `fit_isophote` to force `stop_code=-1` above a threshold SMA is the cleanest approach for controlled retry tests.
- The "anchor iso" pattern (decouple anchor discovery from growth gating) is cleaner than the original `first_iso` gate — it naturally supports both retry and probe-ahead without duplicating the growth loop logic.
- Step-function mock images (sharp cutoff) cause gradient discontinuities that trigger stop_code=-1 for unexpected reasons — smooth exponentials are more reliable test fixtures.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
