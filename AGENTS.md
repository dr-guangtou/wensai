---
date: 2026-02-17
tags:
  - vibe
---
# Wensai - Song Huang's Personal Knowledge Management System

### System Purpose

- Manage daily research project, code development, scientific literature study, and project development.
- Current focus:
	- Research project: image analysis of low-redshift massive galaxies and building a more comprehensive galaxy-dark matter halo physical connection model.
	- Telescope project: Multiplexed Survey Telescope (MUST), a 6.5-m telescope designed for next-gen multi-object spectroscopic survey. As the project scientist, I am guiding the development of its focal plane and spectrograph system.

### Non-Negotiable Rules

- Every new note must include a valid Obsidian note property list. The minimum collection should at least include the date and the tags. If a note is found without any properties, it should be added.
	- Following the Tag System section below to assign tags.

### Directory Structure

- `AGENTS.md`: Vault-wise guideline for agents. `CLAUDE.md` is a symlink to this file.
- `templates`: Template files for different notes.
- `clippings`: Saved from the Obsidian web clipper.
- `journal`: Daily research journal
	- `[YYYY]`
		- `[YYYY-MM-DD].md` - including `Journal`, `Idea`, and `TIL` (Today I learned) sections.
- `projects`: Notes about individual research projects
	- `massive`: For projects related to massive galaxies
	- `hsc`: For analyzing and using HSC data
	- `desi`: For analyzing and using DESI data
	- `photometry`: For developing galaxy photometry and modeling tools
- `must`: Notes related to the science collaboration and instrumentation of MUST
	- `science`: Notes related to the scientific organization of MUST
	- `focalplane`: Notes related to the focal plane system of MUST
	- `spectrograph`: Notes related to the spectrograph system of MUST
- `cards`: Searchable card-based knowledge collection
	- `astro`: Cards related to astronomy-related topics.
	- `vibe`: Cards related to AI or agentic development.
- `papers`: Notes about individual publications.
	- `arxiv`: daily arXiv summary
	- `extragalactic`: a collection of extragalactic papers.
- `development`: Metadata and tracking for code repositories.
	- `repo.yaml`: Registry of all active repos. Each entry records `intro`, `github` URL, `local` paths (keyed by machine name), `related` vault paths, `status`, and optionally `resume` session IDs per coding agent. Read this file to resolve local paths for any repo before performing file operations on it.
- `papers/arxiv/sync_arxiv.sh`: Bash script to sync arXiv digest notes from `yuzhe/project1/arxiv_digest/archive/` into `papers/arxiv/`. Run it manually to pull in new digests; existing files are skipped.

## Tag System

- Location in the directory:
	- e.g., `journal`, `projects/hsc`, `projects/desi`, `must/science`, `must/focalplane`, `must/spectrograph`, `papers`.
	- Always check the most recent directory structure before assigning location tags.
- Status of the project:
	- For each Markdown note in the `projects` folder, include a tag indicating the project status: `under_design`, `early_development`, `finishing`, `published`, or `archived`.
- If the title or section title contains a term from the `cards` folder, treat that term as a tag.
- Note type — add a `documentation` tag for vault-level or cross-cutting reference notes (e.g., `README.md`, `AGENTS.md`, config guides). Use `vault` as the location tag for files at the vault root.

## Vault-Root Documentation Notes

Files like `README.md` live at the vault root and use the following minimum front matter:

```yaml
---
date: YYYY-MM-DD
tags:
  - vault
  - documentation
---
```

- `vault`: location tag for root-level files.
- `documentation`: note-type tag for reference/config documentation (as opposed to `journal`, `project`, or `paper` notes).

## Obsidian CLI

The official Obsidian CLI is available at `/Applications/Obsidian.app/Contents/MacOS/obsidian` (v1.12.1). Always target this vault with `vault=wensai`.

**Canonical alias** (add to shell profile for convenience):
```sh
alias obsidian="/Applications/Obsidian.app/Contents/MacOS/obsidian vault=wensai"
```

### Key Commands for Daily Workflows

| Task | Command |
|------|---------|
| Read today's journal | `obsidian vault=wensai daily:read` |
| Append to daily note | `obsidian vault=wensai daily:append content="<text>"` |
| Open daily note | `obsidian vault=wensai daily` |
| Create a new note | `obsidian vault=wensai create name="<name>" path="<folder>" template="<template>"` |
| Read a note | `obsidian vault=wensai read path="<path>"` |
| Append to a note | `obsidian vault=wensai append path="<path>" content="<text>"` |
| Search vault | `obsidian vault=wensai search query="<text>" format=json` |
| List tags | `obsidian vault=wensai tags all counts sort=count` |
| List files in folder | `obsidian vault=wensai files folder="<path>"` |
| Set a property | `obsidian vault=wensai property:set name="<key>" value="<value>" path="<path>"` |
| Read a property | `obsidian vault=wensai property:read name="<key>" path="<path>"` |
| List orphan notes | `obsidian vault=wensai orphans` |
| List unresolved links | `obsidian vault=wensai unresolved` |
| Run any command | `obsidian vault=wensai command id=<command-id>` |

### Notes for Agents

- Obsidian must be running for the CLI to work.
- The `daily` commands target today's date automatically; the daily note folder is `journal/[YYYY]/`.
- Use `obsidian vault=wensai commands` to see all available command IDs.
- Use `obsidian vault=wensai files folder="papers/arxiv"` to audit paper notes.
- Use `obsidian vault=wensai properties all` to audit front-matter compliance across the vault.
