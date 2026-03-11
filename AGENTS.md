---
date: 2026-02-17
tags:
  - documentation
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
  - `[YYYY]/[MM]`
    - `[YYYY-MM-DD].md` - including `Journal`, `Idea`, and `TIL` (Today I learned) sections.
  - `agentic_daily/[YYYY]/[MM]`
    - `agentic-daily-[YYYY-MM-DD].md` - daily digest of Agentic AI and LLM related news.
- `projects`: Notes about individual research projects
  - `massive`: For projects related to massive galaxies
  - `hsc`: For analyzing and using HSC data
  - `desi`: For analyzing and using DESI data
  - `photometry`: For developing galaxy photometry and modeling tools
- `must`: Notes related to the science collaboration and instrumentation of MUST
  - `science`: Notes related to the scientific organization of MUST
  - `focalplane`: Notes related to the focal plane system of MUST
  - `spectrograph`: Notes related to the spectrograph system of MUST
- `investigation`: Searchable card-based knowledge collection (deep-dive research cards)
  - `astro`: Cards related to astronomy-related topics.
  - `agentic`: Cards related to AI or agentic development.
- `papers`: Notes about individual publications.
  - `arxiv/[YYYY]/[MM]`: daily arXiv summary
  - `extragalactic`: a collection of extragalactic papers.
- `development`: Metadata and tracking for code repositories.
  - `repo.yaml`: Registry of all active repos. Each entry records `intro`, `github` URL, `local` paths (keyed by machine name), `related` vault paths, `status`, and optionally `resume` session IDs per coding agent. Read this file to resolve local paths for any repo before performing file operations on it.
- `papers/arxiv/sync_arxiv.sh`: Bash script to sync arXiv digest notes from `yuzhe/project1/arxiv_digest/archive/` into `papers/arxiv/`. Run it manually to pull in new digests; existing files are skipped.

## Tag System

Every note gets **exactly one location tag** (first in the list) plus **zero or more topic tags**. Tags use Obsidian's `/` separator for hierarchy. All tags must be from the approved taxonomy below — do not invent new tags.

### Location Tags (exactly one per note)

| Tag | Used for |
|-----|----------|
| `journal` | `journal/YYYY/MM/` daily notes |
| `digest` | `journal/agentic_daily/` and `papers/arxiv/` auto-generated digests |
| `development` | `development/*/` dev journals |
| `paper` | `papers/ai/`, `papers/extragalactic/`, etc. (curated paper notes) |
| `investigation` | `investigation/` deep-dive knowledge cards |
| `clippings` | `clippings/` web saves |
| `project` | `projects/*/` and `must/*/` research project notes |
| `documentation` | vault-root reference docs (`README.md`, `AGENTS.md`, config guides) |
| `teaching` | `teaching/` lectures and curriculum |
| `personal` | `personal/` setup and workflow notes |
| `referee` | `work/referee/` referee reports |

### Topic Tags (zero or more per note, nested with `/`)

**astro/** — Astronomy

| Tag | Covers |
|-----|--------|
| `astro/galaxy` | structure, morphology, massive/dwarf galaxies, evolution |
| `astro/lensing` | weak lensing, strong lensing, cluster lensing |
| `astro/spectroscopy` | spectroscopic methods, IFU, emission/absorption |
| `astro/photometry` | photometric methods, photo-z, template fitting |
| `astro/agn` | AGN, black holes, accretion, feedback |
| `astro/cosmology` | large-scale structure, dark matter, halo models |
| `astro/stellar` | stellar populations, SFH, CMD |
| `astro/survey` | HSC, DESI, SPHEREx, LSST, JWST |
| `astro/instrumentation` | telescope hardware, detectors, fiber systems |
| `astro/teaching` | astronomy teaching, lectures, curriculum |
| `astro/writing` | astronomy writing, proposals, referee reports |

**ai/** — AI and Machine Learning

| Tag | Covers |
|-----|--------|
| `ai/agent` | agentic AI, Claude Code, coding agents, multi-agent, MCP |
| `ai/llm` | language models, training, scaling laws, decoding |
| `ai/rl` | reinforcement learning: PPO, DPO, GRPO |
| `ai/deep-learning` | neural nets, architectures, optimization |
| `ai/vision` | computer vision, OCR, image analysis |
| `ai/science` | AI for science, astro-ML crossover |

**dev/** — Software Projects (as topic tags)

| Tag | Covers |
|-----|--------|
| `dev/isoster` | isoster project |
| `dev/frankenz` | frankenz project |
| `dev/sga_isoster` | SGA isoster variant |
| `dev/hsc_photoz` | HSC photo-z pipeline |
| `dev/hsc_sandbox` | HSC sandbox experiments |
| `dev/wensai` | this vault's tooling |
| `dev/yuzhe` | yuzhe project |
| `dev/qingsong` | qingsong project |
| `dev/tool` | CLI tools, utilities, general infra |

**must/** — MUST Telescope

- `must/science`, `must/focalplane`, `must/spectrograph`

**project/** — Research Projects

- `project/hsc`, `project/desi`, `project/massive`, `project/photometry`, `project/dwarf`

### Status Tags (project notes only)

`under_design`, `early_development`, `finishing`, `published`, `archived`

### Paper-Specific Keywords

Paper-specific terms (e.g., "CaT", "H- opacity", "SGA-2020") go in a `topics:` front-matter list, **not** in tags. This keeps the tag namespace clean while preserving searchability.

```yaml
tags:
  - paper
  - astro/photometry
topics:
  - LRD
  - H- opacity
  - CaT
```

### Vault-Root Documentation Notes

Root-level files use `documentation` as their location tag:

```yaml
---
date: YYYY-MM-DD
tags:
  - documentation
---
```

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
- The `daily` commands target today's date automatically; the daily note folder is `journal/[YYYY]/[MM]/`.
- Use `obsidian vault=wensai commands` to see all available command IDs.
- Use `obsidian vault=wensai files folder="papers/arxiv"` to audit paper notes.
- Use `obsidian vault=wensai properties all` to audit front-matter compliance across the vault.
