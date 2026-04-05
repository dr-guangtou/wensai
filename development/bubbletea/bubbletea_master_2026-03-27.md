---
date: 2026-03-27
tags:
  - development
  - development/bubbletea
---

# bubbletea — master — 2026-03-27

## Progress
- Created formal directory structure for the BubbleTea project (scripts/, data/, figures/, docs/, reference/)
- Wrote core project files:
  - `README.md` — project overview with scientific context, phases, and structure
  - `CLAUDE.md` / `AGENTS.md` — project conventions and rules for AI-assisted development
  - `pyproject.toml` — Python 3.12+, dependencies (astropy, astroquery, pandas, numpy, matplotlib, scipy), ruff config
  - `.pre-commit-config.yaml` — ruff check + format hooks
  - `scripts/config.py` — central path configuration with environment variable support
  - `.gitignore` — updated for research project (gitignore FITS, DB, ucd_project/)
- Wrote development plan:
  - `docs/PLAN.md` — master plan with 6 phases (Literature UCDs → Galaxy Sample → Background → Search → Cross-match → Analysis)
  - `docs/plans/phase_1_literature_ucds.md` — detailed Phase I task tracking
- Migrated data from `ucd_project/`:
  - `ucd_collection.db` (756 KB, 1,542 UCDs from 6 sources)
  - Per-source CSV catalogs (9 files)
  - Source metadata JSONs (key_papers.json, vizier_inventory.json)
  - `galaxy_sample_ranked.csv` (2,155 galaxies, 446 KB)
- Migrated `LESSON.md` to `docs/lessons/LESSON.md`
- Added provenance README.md to `reference/voggel2020/` and `reference/wang2023/`

## Current State

### Key Numbers
- 1,542 known UCDs in database from 6 literature sources
- 59% Gaia DR3 match rate, 59.5% Legacy Survey DR10 match rate
- 2,155 target galaxies (D < 25 Mpc) in ranked sample
- 7 galaxies with high-contrast (>10x) UCD signal in pilot search
- Background density varies 10x with galactic latitude

### Key Issues
- Database integrity not yet verified after migration
- `scripts/utils/plotting.py` not yet written (needed for consistent figures)
- No scripts migrated yet — only infrastructure and data in place

### Next Steps
- Verify migrated database integrity (1,542 UCDs, 6 sources)
- Begin Phase I.3: rewrite core database scripts (`ucd_database.py`, `fetch_vizier_catalog.py`)
- Write `scripts/utils/plotting.py` for consistent figure generation
- Start Gaia cross-match verification (Phase I.4)

## Lessons Learned
- Demand-driven migration (rewrite per-phase, not bulk copy) keeps the repo clean and avoids carrying over legacy debt
- `scripts/` is more natural than `src/` for a research project that isn't a package
- Centralizing all paths in `scripts/config.py` with env var support (`BUBBLETEA_EXTERNAL_DATA`) prevents the hardcoded path drift seen in the legacy `ucd_project/` (30+ references to `/Users/shuang/data/`)
- Journal entries should go to both `docs/journal/` in the repo AND the Obsidian vault (`wensai`) for cross-project visibility

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
