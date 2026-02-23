---
date: 2026-02-19
repo: project1
branch: feat/output-dir-option
tags:
  - journal
  - project1
  - reliability
---

## Progress

- Completed `96473b4`: fixed `src/get_llm_score.py` threshold schema usage (`llm_scoring.tier_thresholds`) and updated digest naming behavior/tests.
- Completed `ff936d4`: added fast-path summary fallback when no LLM client is available, with test coverage.
- Completed `5fa3467`: hardened digest date discovery and dedup by scanning archive history across years; added filename/date tests.
- Completed `18c0b3e`: resolved medium-priority issues (provider-order consistency, timeout propagation in `check_llm_apis.py`, entrypoint cleanup, CI lint/test gates, lint debt cleanup).
- Completed `3bdd5b2`: closed governance/documentation gap by adding `docs/SPEC.md` and `docs/todo.md`, moved `PIPELINE_DESIGN.md` to `docs/pipeline-architecture.md`, deleted stale `CHANGELOG_3STAGE.md`, and updated references.
- Completed `679d684` (current branch): added `--output-dir` / `--dir` for custom output directory with default filename (`arxiv-YYYY-MM-DD.md`), updated docs, and added unit test coverage.
- Runtime confidence check executed successfully: `uv run python src/main.py --debug --use-llm-scoring --limit 3 --no-summary` (digest written for 2026-02-19).
- Verification milestones passed during the day: `uv run ruff check .` and `uv run pytest -q` (reported `30 passed` after governance closeout; `31 passed` after adding output-dir test).

## Lessons Learned

- Keep one canonical runtime entrypoint (`src/main.py`) and make root entrypoints thin wrappers to avoid behavior drift.
- Dedup logic must use full digest history, not only the latest file, to prevent replay in recovery windows.
- CLI timeout options are only trustworthy when propagated to real network call timeouts and covered by tests.
- For output controls, separate explicit file mode (`--output`) from directory mode (`--output-dir` / `--dir`) and enforce mutual exclusivity.
- Governance/docs tasks should be tracked as first-class work items (`docs/SPEC.md`, `docs/todo.md`) and verified with the same rigor as code changes.

## Key Issues

- `679d684` is on `feat/output-dir-option`; merge to `main` when ready.
- Untracked journal files remain in workspace: `docs/journal/handover-2026-02-19-1904.md`, `docs/journal/next-session-prompt-2026-02-19-1904.md`.
- Optional follow-up from prior handover: decide whether to add lightweight CLI smoke checks to CI (`src/main.py --help`, `src/get_llm_score.py --help`).
