---
date: 2026-03-14
tags:
  - development
  - development/isoster
---

# isoster — fix/variance-map-template-forced — 2026-03-14

## Progress

- Cleaned up 40 stale local branches (all merged into main), deleted `origin/benchmarks/sersic-comparison` from GitHub, removed 2 worktrees (`dr-guangtou/belgrade`, `feat/legacysurvey-harmonics-example`), and purged untracked gradient-free-fallback code/test files while keeping the issue report as a roadmap
- Reviewed `docs/review_codex_20260313.md` — a thorough external code review identifying 9 issues across critical bugs, release readiness, and test blind spots
- Fixed **Issue 1** (critical): `variance_map` was silently ignored in template/forced photometry mode — threaded it through `_fit_image_template_forced()` to `extract_forced_photometry()`
- Fixed **Issue 2** (critical): sigma clipping in `extract_forced_photometry()` clipped `phi` and `intens` but not `variances`, causing misaligned arrays — now uses `extra_arrays=[variances]` for lockstep clipping
- Upgraded forced photometry to use **weighted mean** when variance map is present: `I = sum(w_i * I_i) / sum(w_i)` with propagated error `sigma_I = 1/sqrt(sum(w_i))`, consistent with WLS covariance in the regular fitting path
- Added 4 regression tests covering: variance threading, weighted mean behavior, sigma-clip alignment, and byte-identity without variance
- Full test suite: 270 passed, 5 deselected, 166 warnings (unchanged baseline)

## Current State

### Branch
`fix/variance-map-template-forced` — 3 files changed, 156 insertions, 10 deletions (uncommitted)

### Key Issues
- Remaining codex review issues (3-9) not yet addressed:
  - Issue 3: `build_isoster_model()` harmonic auto-detection uses only first row
  - Issue 4: out-of-bounds center crash in `fit_central_pixel()`
  - Issues 5-8: release readiness (FITS warnings, install docs, tracked artifacts, CITATION.cff)
  - Issue 9: test blind spots around template+variance, OOB centers, mixed harmonics

### Next Steps
- Commit and decide on merge strategy for this fix branch
- Address issue 3 (harmonic auto-detection) and issue 4 (bounds check) as separate branches
- Consider release-readiness sweep for issues 5-8

## Lessons Learned
- Template/forced mode is the exact workflow where users care most about variance propagation (multiband error budgets), so silently dropping it was a high-impact bug despite being trivially fixable
- The `sigma_clip` function already supported `extra_arrays` — the infrastructure was there, just not wired up in `extract_forced_photometry`
- Weighted mean in forced mode is mathematically clean because geometry is fixed — no ambiguity about whether variance should influence convergence or geometry updates

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
