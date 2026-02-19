---
date: 2026-02-19
tags:
  - development
  - development/wensai
---

# wensai — main — 2026-02-19 (session 2)

## Progress
- Created `journal/new_daily.sh`: safe daily-note scaffolding script that reads `templates/template_journal.md`, substitutes `{{date}}`, and exits without writing if the note already exists
- Created `README.md` at vault root: documents the full directory structure in a 20-row table, and provides reference documentation (purpose, fields, usage examples) for `development/repo.yaml`, `journal/new_daily.sh`, and `papers/arxiv/sync_arxiv.sh`
- Updated `AGENTS.md` Tag System section: added `documentation` note-type tag and `vault` location tag, plus a new "Vault-Root Documentation Notes" subsection with a canonical front-matter template for root-level reference files
- Created `.gitignore` at vault root to exclude `.obsidian/` from version control
- Committed and pushed 5 commits to `origin/main`:
  - `d4a9dfc` — README.md + new_daily.sh
  - `b4ca2e3` — AGENTS.md tag rules, template Focus section, today's daily note
  - `97844dd` — .gitignore
  - `847668f` — track papers/arxiv/ folder

## Current State

### Key Issues
- `papers/` directory was added to tracking (`847668f`) but content policy (whether to commit all arXiv digests) is not yet decided
- `$CLAUDE_CODE_SESSION_ID` is not injected into the shell environment; session ID footers in dev journals must be filled in manually

### Next Steps
- Decide whether `papers/arxiv/` digests should be committed or added to `.gitignore`
- Consider adding a `.gitignore` entry for `journal/` if daily notes should stay local
- Test `/journal` from a non-`wensai` repo to exercise the `mkdir` + `repo.yaml` warning path

## Lessons Learned
- The collision-safe suffix logic (`_2`, `_3`, …) in the `/journal` command works correctly — confirmed by this very entry
- Vault-root files (`README.md`, `AGENTS.md`) need explicit front-matter conventions documented in `AGENTS.md` so agents don't have to guess; the `vault` + `documentation` tag pair is now the canonical rule
- `git status <path>` can report "clean" for a subdirectory even when a new file in it has already been committed — `git ls-files` is the reliable way to confirm tracking status

---
*Agent: Claude Code (claude-sonnet-4-6) · Session: [paste session ID here]*
