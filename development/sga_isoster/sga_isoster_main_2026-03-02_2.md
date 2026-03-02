---
date: 2026-03-02
tags:
  - development
  - development/sga_isoster
---

# sga_isoster — Step 2: Image Download Pipeline — 2026-03-02

## Progress

### Goal
Build an async FITS image download pipeline to fetch all 12 science products per galaxy from the NERSC SGA-2020 portal, validated against the demo sample (96 galaxies).

### What was built

- Created `scripts/download_fits.py` — a fully async download script using `httpx` + `asyncio`, following the CLI patterns established in Step 1 (`draw_subsample.py`).
- Added `httpx` and `tqdm` as project dependencies via `uv add`.
- Developed on `feature/image-download` branch, merged to `main` as `ed50766`.

### Script design (`download_fits.py`)

**12 products per galaxy:**
- Science images: `image-{g,r,z}.fits.fz`
- Inverse variance: `invvar-{g,r,z}.fits.fz`
- PSF models: `psf-{g,r,z}.fits.fz`
- Mask bits: `maskbits.fits.fz`
- Ellipse fits: `{SGA_ID}-ellipse.fits` (per-galaxy SGA_ID in filename)
- Tractor photometry: `tractor.fits`

**Key features:**
- `asyncio.Semaphore` for concurrency control (`--max-concurrent`, default 4)
- Atomic writes: download to `.tmp` file, rename on success — no partial files on disk
- Filesystem-based resume: skip files already on disk with size > 0
- Exponential backoff retry for 5xx/timeout errors; 404s logged but not retried
- CSV download log with per-file status, bytes, and URL
- `--dry-run` mode to inspect manifest without downloading
- `--products` filter to download a subset (e.g., `--products ellipse tractor`)
- `tqdm` progress bar with inline error reporting

**CLI interface:**
```bash
python scripts/download_fits.py --input output/demo_sample.fits --dry-run
python scripts/download_fits.py --input output/demo_sample.fits --products ellipse
python scripts/download_fits.py --input output/demo_sample.fits
```

### Testing sequence

1. **Dry-run on demo sample** — verified manifest: 96 galaxies × 12 products = 1,152 files. Correct.
2. **Tiny test (12 galaxies × ellipse only)** — initial attempt returned all 404s, revealing the ellipse filename bug (see Lessons below). After fix: 12/12 downloaded successfully.
3. **Resume test** — re-ran the same command, all 12 files skipped. Resume works.
4. **Tiny test, all products (12 × 12 = 144 files)** — 132 new + 12 skipped (from previous ellipse run). 0 errors. 13.9 MB in 12.4s.
5. **Full demo sample (96 × 12 = 1,152 files)** — 1,008 new + 144 skipped. **0 errors, 0 missing, 107.4 MB in 81.9s** (~12 files/s).

### Documentation updates
- `docs/plan/step2_image_download.md` — implementation plan and results
- `docs/todo.md` — Step 2 marked done
- `docs/LESSONS.md` — added ellipse naming discovery and download observations
- `CLAUDE.md` — corrected the ellipse URL pattern from `2-ellipse.fits` to `{SGA_ID}-ellipse.fits`

## Current State

### Repository
- Branch: `main` (clean working tree)
- Commits: `ed50766` (merge), `f70030d` (Step 2 implementation)
- Demo FITS data: `data/fits/` — 96 galaxy directories, 1,152 files, ~107 MB (gitignored)

### Pipeline tracker
| Step | Status |
|------|--------|
| 0. Project setup | done |
| 1. Catalog selection | done |
| 1b. Sub-sample drawing | done |
| 1c. Demo grz mosaics | done |
| **2. Image download** | **done** |
| 3. Data validation / QA | pending |
| 4. Isoster integration | pending |
| 5. Batch processing | pending |
| 6. Results analysis | pending |

### Key Issues
- None. Step 2 completed cleanly with 0 errors on the demo sample.
- Production sample (1,998 galaxies × 12 products = 23,976 files) not yet downloaded — will need ~2.4 GB and ~30 min at observed throughput.

### Next Steps
- **Step 3**: Data validation and QA — verify FITS headers, check image dimensions, flag anomalies
- Run production download when ready (same script, `--input output/production_sample.fits`)

## Lessons Learned

### Ellipse filename uses SGA_ID, not a fixed prefix
The CLAUDE.md originally documented the ellipse file as `{GROUP_NAME}-largegalaxy-2-ellipse.fits`. This was wrong — the "2" was an SGA_ID from a specific example galaxy. The actual pattern is `{GROUP_NAME}-largegalaxy-{SGA_ID}-ellipse.fits`, where `SGA_ID` is unique per galaxy.

**How discovered:** Initial download of 12 ellipse files returned all 404s. Directory listing of a known galaxy (`PGC1552910`) revealed the actual filename `PGC1552910-largegalaxy-116160-ellipse.fits`. Cross-referenced with the catalog: SGA_ID for PGC1552910 is indeed 116160.

**Fix:** Updated the `Galaxy` dataclass to carry `sga_id`, and added special-case handling in `build_manifest()` for the ellipse product. All other products (image, invvar, psf, maskbits, tractor) follow the standard `{GROUP_NAME}-largegalaxy-{product}` pattern.

### NERSC portal throughput
- Sustained ~12 files/s with 4 concurrent connections, no rate limiting observed.
- Total 1,008 files (107 MB) in 82 seconds — good enough for demo; may want to increase concurrency for production.

### Atomic writes prevent resume corruption
Using `.tmp` → `rename()` means interrupted downloads leave no files on disk. Resume logic (`size > 0`) is therefore safe — any file present is guaranteed complete.

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
