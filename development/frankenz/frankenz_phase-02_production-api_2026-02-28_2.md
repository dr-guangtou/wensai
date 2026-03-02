---
date: 2026-02-28
tags:
  - development
  - development/frankenz
---

# frankenz — phase-02/production-api — 2026-02-28 (Session 4: User Manual)

## Progress
- Wrote a comprehensive user manual (`docs/frankenz_manual.md`) for frankenz v0.4.0
- Manual covers the full v0.4.0 API: direct API, config-driven pipeline, PhotoData I/O, YAML configs
- 9 sections: overview, installation, input data (mock + real), pipeline (4 approaches), configuration reference (all 8 dataclasses), complete worked example, hierarchical inference, pitfalls, module reference
- All code examples tested and verified against the actual codebase — direct API, config pipeline, and I/O roundtrips all pass
- Manual specifically addresses the user's request: written as if the reader knows nothing about frankenz

## Current State
- Branch `phase-02/production-api`: all Phase 02 code complete, 142 tests pass
- **Still uncommitted**: 9 modified files + 16 untracked files (4 new modules, 6 test files, docs, uv.lock)
- New this session: `docs/frankenz_manual.md` (untracked)

### Key Issues
- All changes remain uncommitted — do not switch branches before committing
- The `knn.py:882` RuntimeWarning (`invalid value in divide`) occurs when a target has zero total PDF weight (edge case in small mock data); not a bug in the manual

### Next Steps
- Update the demo notebooks in `demos/` to use the v0.4.0 API (config system, PhotoData, factories, run_pipeline)
- Record Phase 02 lessons in `docs/LESSONS.md`
- Update `docs/frankenz_review.md` with Phase 02 status
- Commit all Phase 02 changes on `phase-02/production-api`

## Lessons Learned
- Testing manual code examples against the live codebase is essential — caught the correct parameter names (`model_labels` vs `train_redshifts`) early
- The `free_scale` distinction is the single most important concept for new users; deserves prominent placement
- Mock data with small N (< 100) can produce degenerate PDFs; manual examples use N=500 for realistic behavior

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
