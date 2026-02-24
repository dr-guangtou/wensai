---
date: 2026-02-24
repo: yuzhe
branch: main
tags:
  - journal
  - lamian
  - cli-expansion
  - hardening
---

## Progress

- Finalized and merged the feature branch into `main` with commit `cc2a8c6` (`Finalize LaMian CLI expansion and hardening through P4-430`).
- Completed bundle import hardening backlog items `P4-401` to `P4-405`.
- Added bundle import portability validation for non-portable reference paths (absolute/UNC/drive/parent traversal) with CLI coverage.
- Reused domain validation rules in bundle import for sources/tags/links with normalization and CLI coverage.
- Added bundle link-loss counters and strict failure mode (`bundle import --fail-on-link-loss`).
- Converted bundle managed-file export/import paths to streaming IO.
- Hardened archive preflight to reject duplicate manifest/metadata, unexpected entries, and non-regular tar members.
- Completed query/collection disambiguation (`P4-406`) with explicit `--reference-mode auto|id|name` support and tests.
- Added read-only vault integrity command (`verify`) for missing-file/hash-drift/size-drift checks (`P4-407`).
- Added bundle preflight commands (`bundle inspect`, `bundle import --dry-run`) with deterministic JSON summaries (`P4-408`).
- Added bundle conflict policy controls (`--on-conflict skip|error|replace`) with coverage for error/replace behavior (`P4-409`).
- Completed documentation alignment pass for implemented hardening/features (`P4-410`).
- Completed additional hardening items `P4-411` to `P4-420` (tag rename safety, self-link cleanup in remove path, Rust 2021 compatibility, shared DB connection helper rollout, query/export batching, caption clear semantics, link uniqueness migration, shared tag validation module, bundle import crash consistency, doctor file-path integrity checks).
- Completed CLI expansion items `P4-421` to `P4-430`.
- Added `show`/`info` figure detail command with full metadata output (`P4-421`).
- Added `list`/`ls` figure command with deterministic sort/order/limit behavior (`P4-422`).
- Added figure `delete` command with transactional cleanup and managed-file policy (`P4-423`).
- Added figure `open` command with OS launcher semantics (`P4-424`).
- Added hierarchical `search --tag-prefix` behavior (`P4-425`).
- Added `source update` command for set/clear source metadata fields (`P4-426`).
- Allowed filterless saved queries (`P4-427`) so sort/order/limit-only templates are valid.
- Added global `--json` output mode for Phase 1 command families (`inject`, `update`, `tag`, `link`, `search`, `export`) (`P4-428`).
- Added `tag list` command with deterministic tag ordering and per-tag figure counts (`P4-429`).
- Added `collection update` command with rename/query binding updates (`--name`, `--query-id`, `--clear-query-id`) (`P4-430`).
- Expanded integration test coverage with new CLI suites, including `cli_delete`, `cli_list`, `cli_open`, `cli_show`, `cli_source`, `cli_verify`, `cli_json`, and `cli_tag_list`, plus extended `cli_collection` and `cli_query` tests.
- Re-ran the full gate repeatedly after implementation slices and doc sync (`cargo fmt --all && cargo clippy --all-targets -- -D warnings && cargo test`).

## Lessons Learned

- For strict `clippy -D warnings`, rewrite nested `else { if ... }` branches into `else if` directly to avoid `collapsible_else_if` failures.
- For strict `clippy -D warnings`, avoid adding unused error enum variants because dead-code warnings fail the gate.
- Extract row structs when query tuple parsing becomes complex to avoid `clippy::type_complexity` failures and keep service code readable.
- Keep full-gate checks mandatory after each slice to catch style/lint regressions early rather than batching fixes late.

## Key Issues

- CLI expansion phase (`P4-421` to `P4-430`) is complete; the next major roadmap items are GUI-focused (`L-201`, `L-202`).
- The last 24-hour history is represented by one consolidated commit on `main`; future work may benefit from smaller logical commits if per-slice traceability is required.
- Immediate next action: define the next phase scope (GUI stack decision and first deliverable) before coding.
