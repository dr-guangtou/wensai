---
date: 2026-03-15
tags:
  - development
  - development/hsc_sandbox
---

# hsc_sandbox — main — 2026-03-15

## Progress
- Implemented S2T0: S23B Wide footprint filter foundation — the prerequisite for all Step 2 spec-z source work.
- Parsed tract-patch corner geometry from 4 wide-field files (W-spring, W-autumn, W-hectomap, W-AEGIS) totaling 91,449 patches.
- Inner-joined geometry to `s23b_wide_patch_qa.csv` to produce `s23b_wide_patch_footprint.csv` with 59,597 rows (56,713 five-band). 47 QA rows with NULL tracts were correctly excluded.
- Aggregated patch footprint into `s23b_wide_tract_envelope.csv` (871 tracts) for coarse prefiltering.
- Built `footprint_filter.py` with public API: `load_s23b_wide_footprint_products()`, `build_hsc_footprint_mask()`, `filter_catalog_through_hsc_footprint()`. Supports per-band and five-band selection, field restriction, and optional exact patch-polygon containment via ray-casting.
- Created `plot_s23b_wide_footprint.py` sky map visualization — all 4 fields contiguous and color-coded.
- Wrote command doc `STEP2_0_s23b_footprint_filter.md` and updated `TODO.md` with S2T0 completion status.
- Wrote 36 tests (22 unit + 14 functional), all passing.
- Merged `feature/step2-s2t0-footprint-filter` into `main`.

## Current State

### Key Issues
- None blocking. The 23MB patch footprint CSV is gitignored (regenerable via CLI).
- Unit tests are slow (~27 min) because parsing the W-autumn geometry file (291K lines) is I/O-heavy. Could optimize with caching or binary format in the future.

### Next Steps
- Begin S2T1: spec-z truth table foundation — inventory HSC internal spec-z, DESI inputs, and external sources.
- Each source inventory step should use the S2T0 footprint filter to scope candidates to the HSC wide footprint.

## Lessons Learned
- **Shifted-RA break point matters**: the naive RA-180 shift moves the 0/360 wrap to ±180, splitting W-autumn. Shifting to break at RA=290 (the gap between hectomap/AEGIS and autumn) keeps all 4 wide fields contiguous. The formula is `((RA + 70) % 360) - 180`.
- **patch_qa has 47 rows with NULL tract/coordinates** — these are empty patches with no calexp data in any band. Silently dropping them is correct; the five-band count (56,713) still matches the planned expectation exactly.
- **Plan row count was off by 47**: the plan estimated 59,644 patches (raw QA row count) but the true joinable count is 59,597. Always validate join counts against actual data before hardcoding expectations.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
