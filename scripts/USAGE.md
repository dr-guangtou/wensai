---
date: 2026-04-05
tags:
  - documentation
  - dev/wensai
---
# Scripts

Utility scripts for maintaining the wensai Obsidian vault.

---

## `new_daily.sh` — Daily Journal Creator

Creates today's daily journal note from `templates/template_journal.md`. Safe to run any time — exits immediately if the note already exists.

**Usage:**

```bash
bash scripts/new_daily.sh
```

**What it does:**
1. Resolves today's date (`YYYY-MM-DD`) and the matching year folder (`journal/YYYY/`).
2. Checks if `journal/YYYY/YYYY-MM-DD.md` already exists — if so, prints `Already exists:` and exits cleanly.
3. Creates the year directory if needed, then copies the template with `{{date}}` substituted.

---

## `organize_arxiv.sh` — arXiv Digest Organizer

Finds all arXiv digest notes under `papers/arxiv/` and moves any that are not in the correct `YYYY/MM/arxiv-YYYY-MM-DD.md` path. Handles files with or without the `arxiv-` prefix.

**Usage:**

```bash
bash scripts/organize_arxiv.sh           # dry-run (preview only)
bash scripts/organize_arxiv.sh --apply   # actually move files
```

**What it does:**
1. Scans all `.md` files under `papers/arxiv/` for filenames containing a `YYYY-MM-DD` date.
2. Non-date files (e.g., `arxiv_index.md`) are ignored.
3. For each date file, checks if it lives at `YYYY/MM/arxiv-YYYY-MM-DD.md`.
4. Misplaced files are moved (or previewed in dry-run mode). Files missing the `arxiv-` prefix are renamed.
5. If the destination already exists, the file is flagged as a conflict and skipped.
6. Prints a summary of moved, correct, and conflicting files.

---

## `migrate_tags.py` — Tag Migration Tool (one-time)

One-time migration script that converts the vault's flat tag system to a nested taxonomy. Can be re-run safely.

**Usage:**

```bash
python scripts/migrate_tags.py --dry-run   # preview changes
python scripts/migrate_tags.py             # apply changes
```

**What it does:**
1. Fixes YAML syntax (inline arrays, quotes, commas, wiki-links in tags).
2. Maps flat tags to nested taxonomy (e.g., `photo-z` → `astro/photometry`).
3. Extracts paper-specific keywords to a `topics:` front-matter field.
4. Adds front matter to files missing it (infers location tag from path).
