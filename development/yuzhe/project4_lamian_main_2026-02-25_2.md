---
date: 2026-02-25
repo: yuzhe
branch: main
tags:
  - journal
  - phase-2-1
  - phase-2-2
  - lamian
---

## Progress

- Closed Phase 2.1 GUI mutation expansion (`P4-511`..`P4-518`) in `project4/lamian/src/gui.rs` and synchronized trackers in `project4/` and `project4/lamian/docs/`.
- Design-locked Phase 2.1 mutation UX/state flow (`P4-511`) with deterministic post-delete selection and shared-service validation mapping.
- Implemented GUI tag add/remove via shared services (`P4-512`) with lifecycle/error handling and deterministic detail refresh.
- Implemented GUI link add/remove via shared services (`P4-513`) with lifecycle/error handling and deterministic detail refresh.
- Implemented GUI figure delete confirmation flow (`P4-514`) with deterministic next/previous/clear selection behavior after delete.
- Added Phase 2.1 GUI regression coverage (`P4-515`) for mutation state transitions, failure recovery, and deterministic list/detail behavior.
- Passed full Rust gate for Phase 2.1 (`P4-516`): `cargo fmt --all && cargo clippy --all-targets -- -D warnings && cargo test`.
- Design-locked Phase 2.2 drag-and-drop ingest UX/state flow (`P4-517`) in both SPEC mirrors with strict provenance prompts, deterministic ordering, shared ingest-core reuse, and Rust 2021 constraints.
- Completed Phase 2.1 closure tracker/spec synchronization (`P4-518`) across `project4/SPEC.md`, `project4/lamian/docs/SPEC.md`, `project4/TODO.md`, `project4/lamian/docs/TODO.md`, and `docs/todo.md`.
- Implemented drop-session ingest state machine (`P4-519`) with lifecycle `idle -> drop_received -> metadata_required -> ready_to_commit -> committing -> committed|commit_failed` and deterministic normalized-path ordering.
- Wired drop-session commits to shared ingest core `inject_figure` (`P4-520`) with one-or-many deterministic processing, duplicate-aware outcomes, and partial-failure retention.
- Implemented batch provenance defaults and per-item overrides (`P4-521`) with commit gating until all pending items have required metadata (`source_type`, `source_key`).
- Extended drop-ingest regression coverage (`P4-522`) for deterministic commit-result ordering, stable per-item status mapping, and commit-failure recovery retry behavior.
- Passed full Rust gate for Phase 2.2 (`P4-523`): `cargo fmt --all && cargo clippy --all-targets -- -D warnings && cargo test`.
- Finalized and merged branch work to `main` with commit `acd5799` (`Complete Phase 2.2 drop-ingest defaults, regression coverage, and full gate`) via fast-forward.
- Verified branch history milestones for this phase window: `cc40fa9` (Phase 2.1 closure/docs sync), `891e27c` (Phase 2.2 design lock), `6f1b636` (`P4-519`), `27e32c3` (`P4-520`), `acd5799` (`P4-521`..`P4-523` closure).

## Lessons Learned

- Reusing shared ingest services (`inject_figure`) for GUI drop ingest reduced semantic drift and preserved CLI/domain validation parity.
- Deterministic normalized-path ordering should be asserted directly in tests for multi-file ingest and partial-failure scenarios.
- Drop ingest needs explicit batch defaults + per-item overrides to keep UX practical while maintaining strict provenance completeness rules.
- Commit gating should be driven by resolved effective metadata (override first, then default), not by raw per-item inputs.
- Partial failures should preserve stable result ordering and complete per-item diagnostics to support reliable operator recovery.
- Tracker parity between `project4/` and `project4/lamian/docs/` is easiest to maintain when updates are performed in the same change set.
- Rust 2021 compatibility and `clippy -D warnings` constraints should be treated as design constraints during implementation, not as late cleanup.
- Full-gate sequencing worked better by keeping targeted verification during implementation slices and reserving full-gate closure for the final slice.

## Key Issues

- No active Phase 2.1/2.2 blockers remain; both phases are closed in trackers with full-gate evidence recorded.
- Phase 2.3 planning/tracker definition is the next open item after Phase 2.2 closure.
- Open action: decide Phase 2.3 scope boundaries for GUI parity-polish versus CLI-first workflows before implementation.
- Open action: create Phase 2.3 TODO slice IDs and acceptance checks in both tracker mirrors (`project4/` and `project4/lamian/docs/`).
