---
date: "2026-04-05"
repo: maolan
branch: main
tags:
  - journal
  - development
---

## Progress

- Built complete Phase 0–5 of the Personal Research Cockpit ("maolan") from scratch: FastAPI backend + React/Vite frontend
- Implemented 6 modules with 17 API endpoints: project_monitor (git + GitHub API), draft_monitor, calendar (Google Calendar OAuth2), journal (Obsidian read/append/bookmark), arxiv_browser (digest parser for 919 papers from 35 digest notes), legacy_survey_cutout (multi-layer sky coordinate viewer)
- Built config system: YAML → Pydantic with `${ENV_VAR}` resolution, supporting multi-machine path flexibility
- Implemented multi-provider LLM client (Qwen/Kimi/GLM/OpenAI) with automatic failover
- Built arXiv digest parser with full-note modal — fixed `###` vs `####` boundary regex bug that truncated content
- Added "Remember this" button in arXiv panel that saves paper reference to journal's `### Astro:` section
- Added React ErrorBoundary so one broken panel doesn't crash the page
- All write endpoints return `{success, module, action, detail}` mutation result — agent-ready
- Obsidian journal notes use append-only atomic writes (temp file + os.rename) with section-aware insertion

## Lessons Learned

- `find('\n###', ...)` regex matches `####` sub-headings — must use `\n### (?!\.)` or equivalent to match only `### ` level-3 headings
- The local function name `fetch` shadows the global `fetch` API in React hooks — renamed to `fetchData` and used `window.fetch` to avoid infinite recursion
- Vite dev server proxies `/api/*` to backend, so both servers must run simultaneously; stale Vite processes on old ports cause silent failures
- Legacy Survey cutout images < 1KB indicate empty/out-of-footprint regions — useful heuristic for graceful degradation

## Key Issues

- Google Calendar OAuth2 not yet configured — needs `google_oauth.json` credentials file and one-time token flow
- No drafts configured in `config.yaml` yet — draft_monitor panel shows empty
- All code is in working tree but not committed to git (single initial commit) — should commit before next session
- arXiv index file (`arxiv_index.md`) not yet bootstrapped — `mark_read` creates it on first use
