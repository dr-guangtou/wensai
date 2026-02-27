---
date: 2026-02-26
repo: qingsong
branch: main
phase: Phase 5
tags:
  - journal
  - architecture
  - portability
  - cli
---

## Progress

- Completed Phase 5: Project Portability, transforming Qingsong from a single-repository script into a flexible, multi-vault engine.
- Refactored `tools/qingsong/__init__.py`, `core.py`, `load_meta.py`, and `doorstop_io.py` to eliminate hardcoded global paths, introducing dynamic path resolution based on the project root.
- Updated the `qingsong` CLI to accept a global `--root` option, which sets the `QINGSONG_ROOT` environment variable to ensure low-level Pydantic validation honors the specified vault context.
- Implemented the `qingsong init` command to scaffold complete, isolated vault structures with required `meta/` templates (hierarchy, people, vocabularies, glossary) and a `doorstop/` folder.
- Wrote `test_multi_vault.py` using `typer.testing.CliRunner` to verify end-to-end scaffolding, item creation, and validation within an isolated test directory.

## Lessons Learned

- **Global State in Validation**: Pydantic's `model_validator` functions cannot easily accept dynamic context (like a CLI `--root` argument) during instantiation without complex context-vars passing. Setting a temporary environment variable (`QINGSONG_ROOT`) at the CLI entry point provides a clean, robust way to pass contextual root paths down to deep validation layers.
- **Metadata Caching Gotchas**: When running integration tests that invoke the CLI multiple times in the same process, global module-level caches (like `_metadata_cache`) leak state between simulated runs. Explicit cache invalidation (`clear_meta_cache()`) is critical when context boundaries (like the project root) change dynamically.
- **Scaffolding Completeness**: A system with strict referential integrity (like Qingsong's Pydantic models) requires its scaffolding logic (`init`) to generate a perfectly self-consistent set of templates. Missing a seemingly minor file (like `glossary.yaml`) or list (`valid_system_paths`) will immediately break downstream item creation.

## Key Issues

- **Vault Discovery**: The current auto-discovery logic looks for `.git` or `pyproject.toml`. It was updated to look for `meta/` and `doorstop/`, but if users nest vaults deeply, the resolution hierarchy might need explicit boundary markers (e.g., a `.qingsong` file).
- **Next Action**: The engine is fully portable. The immediate next step is to test it in the wild (creating the demo project) and then move on to the Web UI (Streamlit) overhaul or CI/CD workflow automation.
