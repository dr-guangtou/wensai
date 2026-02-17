---
Date: 2026-02-17
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

- `AGENTS.md`: Vault-wise guideline for agent. Also has a link to the `CLAUDE.md` file.
- `templates`: Template files for different notes.
- `journal.  - Daily research journal
	- `[YYYY]`
		- `[YYYY-MM-DD].md` - including  `Journal`, `Idea`, and `TIL` (Today I learned) sections.
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

## Tag System

- Location in the directory: 
	- e.g., `journal`, `projects/hsc`, `projects/hsc`, `projects/desi`, `must/science`, `must/focalplane`, `must/spectrograph`, `papers`.
	- You should check the most recent version of the directory structure. 
- Status of the project: 
	- For each Markdown note in the `projects` folder, include a tag indicating the project status, from under_design, early_development, finishing, published, or `archived`. 
- If the title or session title contains a term in the `cards` folder, that term should be treated as a tag. 


