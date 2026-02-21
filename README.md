---
date: 2026-02-19
tags:
  - vault
  - documentation
---

# Wensai — Personal Knowledge Management Vault

Song Huang's Obsidian vault for daily research journaling, scientific literature, code-project tracking, and instrumentation notes. Managed with the [Obsidian CLI](https://obsidian.md) (`vault=wensai`).

---

## Directory Structure

| Path                             | Type      | Purpose                                                                                |
| -------------------------------- | --------- | -------------------------------------------------------------------------------------- |
| `AGENTS.md`                      | Config    | Vault-wide guidelines for AI agents. `CLAUDE.md` is a symlink to this file.            |
| `README.md`                      | Config    | This file — vault overview and tooling reference.                                      |
| `templates/`                     | Config    | Obsidian note templates (front-matter + section scaffolds).                            |
| `development/`                   | Tracking  | Metadata and dev journals for all active code repositories.                            |
| `development/repo.yaml`          | Config    | Central registry of every active repo (paths, GitHub URLs, status, agent session IDs). |
| `development/[REPO]/`            | Journal   | Per-repo development journals written by AI coding agents.                             |
| `journal/`                       | Journal   | Daily research journal.                                                                |
| `journal/[YYYY]/[YYYY-MM-DD].md` | Journal   | One file per day with Focus, Journal, Idea, and TIL sections.                          |
| `journal/agentic_daily`          | Journal   | Daily digest of Agentic AI and LLM related news                                        |
| `papers/`                        | Reference | Notes on individual publications.                                                      |
| `papers/arxiv/`                  | Reference | Daily arXiv digest notes synced from `yuzhe`.                                          |
| `papers/extragalactic/`          | Reference | Curated extragalactic paper notes.                                                     |
| `projects/`                      | Project   | Research project notes, organised by topic.                                            |
| `projects/massive/`              | Project   | Low-redshift massive galaxy analysis.                                                  |
| `projects/hsc/`                  | Project   | HSC survey data analysis.                                                              |
| `projects/desi/`                 | Project   | DESI data analysis.                                                                    |
| `projects/photometry/`           | Project   | Galaxy photometry and modelling tools.                                                 |
| `must/`                          | Project   | MUST telescope science and instrumentation.                                            |
| `must/science/`                  | Project   | MUST scientific organisation notes.                                                    |
| `must/focalplane/`               | Project   | Focal plane system notes.                                                              |
| `must/spectrograph/`             | Project   | Spectrograph system notes.                                                             |
| `cards/`                         | Card      | Searchable atomic-knowledge cards.                                                     |
| `cards/astro/`                   | Card      | Astronomy concepts and references.                                                     |
| `cards/vibe/`                    | Card      | AI and agentic development notes.                                                      |
| `clippings/`                     | Clipping  | Web pages saved via the Obsidian web clipper.                                          |

---

## Configuration Files and Scripts

### `development/repo.yaml` — Repository Registry

Central registry of every active code repository. AI agents read this file to resolve local paths before performing any file operations on a repo.

**Fields per entry:**

| Field | Required | Description |
|-------|----------|-------------|
| `intro` | Yes | One-line description of the repo. |
| `github` | Yes | Full GitHub URL. |
| `local` | Yes | List of `machine_name: /absolute/path` mappings. |
| `related` | Yes | Vault paths of related project or topic notes. |
| `status` | Yes | `being_planned` · `just_beginning` · `under_development` · `implemented` · `published` |
| `resume` | No | Per-agent session IDs to resume coding sessions (e.g., `claude: <uuid>`). |

**Example entry:**

```yaml
isoster:
  intro: "ISOphote on STERoid - A Faster Version of Elliptical Isophote Fitting"
  github: "https://github.com/MassiveSeaOtters/isoster"
  local:
    - macbook_air: "/Users/mac/Dropbox/work/project/otters/isoster"
  related:
    - "projects/photometry"
    - "projects/massive"
  status: under_development
```

**Usage:** agents run `cat development/repo.yaml` or `obsidian vault=wensai read path="development/repo.yaml"` to resolve a repo's local path before editing files.

---

### `journal/new_daily.sh` — Daily Journal Creator

Creates today's daily journal note from `templates/template_journal.md`. Safe to run any time — exits immediately if the note already exists.

```
journal/
└── new_daily.sh
```

**Usage:**

```bash
bash journal/new_daily.sh
```

**What it does:**
1. Resolves today's date (`YYYY-MM-DD`) and the matching year folder (`journal/YYYY/`).
2. Checks if `journal/YYYY/YYYY-MM-DD.md` already exists — if so, prints `Already exists:` and exits cleanly.
3. Creates the year directory if needed, then copies the template with `{{date}}` substituted.

**Output:**

```
Created: /path/to/wensai/journal/2026/2026-02-19.md
```

---

### `papers/arxiv/sync_arxiv.sh` — arXiv Digest Sync

One-way sync of daily arXiv digest notes produced by the `yuzhe` research assistant into `papers/arxiv/`. Existing files are never overwritten.

```
papers/arxiv/
└── sync_arxiv.sh
```

**Source → Destination:**

```
yuzhe/project1/arxiv_digest/archive/YYYY/YYYY-MM-DD.md
  →  wensai/papers/arxiv/YYYY/YYYY-MM-DD.md
```

**Usage:**

```bash
bash papers/arxiv/sync_arxiv.sh
```

**What it does:**
1. Scans all `YYYY/YYYY-MM-DD.md` files under the source archive.
2. Skips any file whose destination already exists.
3. Creates the year subfolder as needed and copies new files.
4. Prints a summary: `Done: N synced, M skipped.`

**Note:** requires Dropbox to be running and the `yuzhe` project to be available at its configured path. If the source directory is missing the script exits with an error.
