---
date: 2026-02-25
repo: yuzhe
branch: main
tags:
  - journal
  - gui
  - phase-2
  - lamian
---

## Progress

- Locked the Phase 2.0 GUI stack to `egui/eframe` and documented architecture boundaries that require CLI and GUI to reuse the same shared Rust core services.
- Updated planning trackers first in `project4/SPEC.md`, `project4/TODO.md`, `project4/lamian/docs/SPEC.md`, `project4/lamian/docs/TODO.md`, and `docs/todo.md`.
- Implemented the shared library boundary in `project4/lamian/src/lib.rs` and migrated CLI main to import from library modules.
- Added GUI baseline files `project4/lamian/src/gui.rs` and `project4/lamian/src/bin/lamian_gui.rs` with read-only vault open, list/search, and `show`-equivalent detail rendering.
- Verified Phase 2.0-S1 with `cargo fmt --all && cargo clippy --all-targets -- -D warnings && cargo test` and merged to `main` as commit `0277eb8`.

## Lessons Learned

- `eframe` integration adds a large dependency graph, so first compile/setup is materially heavier than current CLI-only workflows.
- For `eframe = 0.27.x`, `run_native` app creation must return `Box<dyn App>` directly; returning `Result` caused a hard compile failure under the warning-deny gate.
- Keeping deterministic behavior simple in GUI is easier when rendering rows exactly in the order returned by existing core services.

## Key Issues

- Mutation workflows are not implemented in GUI yet; metadata editing, tag/link actions, delete, and ingest drag-and-drop remain out of Phase 2.0-S1 scope.
- Next action: execute Phase 2.0-S2 to add safe metadata mutation flows by reusing `update` and `source update` service paths with no duplicated GUI business rules.
- Open question: whether to prioritize metadata editing first (recommended) or drag-and-drop ingest for the next GUI slice.
