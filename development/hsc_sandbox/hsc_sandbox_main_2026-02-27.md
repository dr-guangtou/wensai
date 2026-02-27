---
date: 2026-02-27
tags:
  - development
  - development/hsc_sandbox
---

# hsc_sandbox — main — 2026-02-27

## Progress

- Onboarded project structure: read `ROADMAP.md`, `CLAUDE.md`, and `README.md`; compressed `CLAUDE.md` from 41 to 28 lines, removing verbose context that duplicated the README while keeping all actionable rules
- Initialized auto-memory at `~/.claude/projects/.../memory/MEMORY.md` with key project facts, rules, and HSC API notes
- Set up required `step1` folder structure: created `docs/`, `docs/journal/`, `docs/LESSONS.md`
- Improved `step1/python/sql_query.py` (modernized rewrite of official NAOJ `hscSspQuery3.py`):
  - Added `resolve_username()` to read `$HSC_SSP_USER` from environment; made `--user` optional
  - Changed default `--password-env` from `HSC_SSP_CAS_PASSWORD` → `HSC_SSP_PASS`
  - Added `pathlib`-based output directory auto-creation
  - Added `Accept: application/json` header for structured error responses
  - Fixed HTTP error handling to parse JSON bodies cleanly instead of dumping raw HTML
  - **Critical bug fixed**: `CLIENT_VERSION` was a string `"20251230.1"` — server returns HTTP 500 for string type; must be a float `20251230.1`
- Diagnosed the `clientVersion` bug via systematic isolation testing (string vs float, with/without `Accept` header) — confirmed float is required by the HSC API
- Added `step1/sql/fetch_s23b_wide_mosaic.sql` and ran a full download of `s23b_wide.mosaic`: **~292K rows, 162 MB CSV**, per-band per-patch coadd metadata (WCS, seeing, zero-point, depth)
- Added `step1/sql/query_table_schema.sql` using `information_schema.columns` to inspect any table's schema via the API; confirmed `pg_catalog` system tables are not accessible through the API
- Updated `.gitignore`: fixed `__pycache__/` → `**/__pycache__/` (all directory levels); added `step1/data/*.csv` and `step1/data/*.fits` to exclude large data files
- Wrote `step1/README.md` from scratch covering database config, `sql_query.py` usage reference, schema inspection workflow, full S23B table index, and `mosaic` table details
- Fixed a second bug in `_post_json`: empty HTTP error response bodies caused `JSONDecodeError` crash; now handled gracefully with `"(empty response body)"` message

## Current State

### Key Issues
- `pg_catalog.pg_description` (column comments / documentation strings) is inaccessible via the SQL API — must use the schema browser at `https://hscdata.mtk.nao.ac.jp/schema_browser3/` for column-level docs
- No `step1/CLAUDE.md` yet — step-level agent config not written (deferred; lower priority until actual catalog queries begin)

### Next Steps
- Design and run the main source catalog query (`s23b_wide.forced` + joins) for the wide survey footprint
- Determine the basic selection cuts (primary source, depth, pixel flags) for the massive galaxy sample
- Fetch `s23b_wide.patch_qa` for survey depth and seeing maps
- Write `step1/CLAUDE.md` once the query workflow is more settled

## Lessons Learned

- **HSC API `clientVersion` must be a float**: The server silently returns HTTP 500 if `clientVersion` is a JSON string. The official NAOJ script used `20190924.1` as a Python float literal, serializing to a JSON number. A modernized script that stored it as `"20251230.1"` (string) broke the entire API. Documented in `step1/docs/LESSONS.md`.
- **Python urllib vs curl differences**: When the server returned HTTP 401 for curl but HTTP 500 for Python, the root cause was NOT the HTTP client — it was the `clientVersion` type causing a server-side crash before auth. The 401 from curl was because the shell-expanded password was slightly different in that test. Lesson: isolate payload differences systematically before blaming the HTTP library.
- **`information_schema` is accessible, `pg_catalog` is not**: The HSC API wraps a PostgreSQL database but restricts access to system catalogs. `SELECT * FROM information_schema.columns WHERE ...` works; `SELECT ... FROM pg_catalog.pg_attribute ...` returns an empty error body (HTTP error with 0-byte body) — hence the need for the empty-body error handling fix.
- **gitignore `__pycache__/` only matches the root level**: the correct pattern for all subdirectories is `**/__pycache__/`.

---
*Agent: Claude Code (claude-sonnet-4-6) · Session: [paste session ID here]*
