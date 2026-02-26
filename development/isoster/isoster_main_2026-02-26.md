---
date: 2026-02-26
tags:
  - development
  - development/isoster
---

# isoster — main — 2026-02-26

## Progress

- Executed full production-readiness cleanup plan to prepare the repository for public release
- Untracked 97 files from git index via `git rm --cached` (kept on disk):
  - Build artifacts: `isoster.egg-info/`, `__pycache__/` dirs (19 files)
  - Editor/agent configs: `.claude/`, `.vscode/`, `.github/agents/`, `AGENTS.md` (5 files)
  - Internal dev docs: `docs/journal/` (68 files), `docs/review/` (2), `docs/plans/` (2), `docs/todo.md`, `docs/lessons.md`, `docs/todo-archive-phase7-22.md` (74 files)
  - QA reference figures: `qa/reference_figures/` (9 files, ~6.8MB binary PNGs)
  - Misc: `reference/optimize_backup.py`, `config.yaml`
- Rewrote `.gitignore` with organized, categorized patterns covering all untracked file types
- Created two new documentation files extracted from CLAUDE.md:
  - `docs/testing.md` — testing and benchmark directives (mock rules, radial ranges, metrics)
  - `docs/qa-figures.md` — QA figure layout conventions and style baseline
- Copied `mockgal.py` (1884 lines, libprofit-based mock generator) from external path into `examples/huang2013/mockgal.py`, removing absolute path reference from CLAUDE.md
- Created `CONTRIBUTING.md` — development setup, code style, branch workflow, PR process, testing, issue reporting
- Created `CITATION.cff` — CFF v1.2.0 template with metadata from pyproject.toml, placeholder author fields
- Compressed `CLAUDE.md` from 310 to 111 lines by replacing detailed sections with cross-references to dedicated docs
- Rewrote `README.md` from developer-centric (204 lines) to user-centric (112 lines): logo, badges, quick start, multiband example with updated `template=` API, key features, doc links, contributing/citation sections
- Updated `docs/index.md` with new docs and reorganized stable vs. internal sections
- Updated `mkdocs.yml` nav to include configuration-reference, testing, qa-figures pages
- All 224 tests pass, mkdocs builds cleanly
- Merged `chore/production-ready` into `main` via fast-forward (commit `31915d0`)

## Current State

### Key Issues
- `CITATION.cff` has placeholder author name/ORCID — needs manual fill-in before publishing
- ~6.8MB of QA PNG files remain in git history pack files; use `git filter-repo` if repo size matters
- `docs/journal/` directory was emptied by git merge (files existed only in tracking); recreated empty for future use
- Commit `31915d0` is ahead of `origin/main` — not yet pushed

### Next Steps
- Fill in `CITATION.cff` author fields (name, ORCID)
- Push to origin when ready to go public
- Consider `git filter-repo` to strip binary QA images from history if pack size is a concern
- Add `site/` to `.gitignore` (mkdocs build output, currently untracked but not ignored)

## Lessons Learned
- `git rm --cached -r` on a directory removes all files from the index but also deletes the working directory if all files become untracked — need to `mkdir -p` afterward if the directory is still needed for local use
- Compressing agent instruction files (CLAUDE.md) via cross-references to dedicated docs is effective — preserves all content for agents while keeping the main file scannable
- For production cleanup, a single well-planned commit touching 127 files is cleaner than incremental commits — the fast-forward merge keeps history linear

---
*Agent: Claude Code (claude-opus-4-6) · Session: 5139ca9d-4271-453f-876e-100cba5bdbbd*
