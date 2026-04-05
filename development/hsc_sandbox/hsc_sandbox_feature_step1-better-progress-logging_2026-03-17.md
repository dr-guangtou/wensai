---
date: 2026-03-17
repo: hsc_sandbox
branch: feature/step1-better-progress-logging
tags:
  - journal
  - step1
  - empty-selection
  - production
---

## Progress

- Diagnosed the `hectomap_004` `empty_download` failures as valid zero-row SQL results, not broken downloads.
- Confirmed the zero-row outcome is caused by the five-band `inputcount >= 3` cut; counts stayed nonzero through `isprimary`, complete-patch, and `i_cmodel_mag <= 25.2`, then dropped to zero at the FDFC cut.
- Updated `step1/python/run_tract_sql_pipeline.py` so a zero-row first pairwise base query is recorded as `empty_selection`, adds a warning to the manifests and journals, skips later catalogs for that tract, and does not stop the chunk.
- Updated `step1/python/postprocess_catalog_run.py` so empty-selection tracts validate cleanly, write empty merged parquet outputs with the expected schema, and skip raw CSV compression.
- Updated `step1/python/examine_tract_quality.py` so QA summaries tolerate zero-row parquet inputs.
- Added unit coverage for empty-selection download handling, empty-selection postprocess behavior, and zero-row QA compatibility.
- Updated `docs/SPEC.md`, `step1/docs/LESSONS.md`, and `step1/docs/TODO.md` to record the new empty-selection contract.

## Lessons Learned

- `empty_download` was a misleading label for this case; the tract had survey data, but the selected object set was empty.
- The first pairwise base query is the correct early-stop trigger for empty tracts because later pairwise catalogs are anchored on the same selected object set.
- Empty-selection tracts need a full downstream contract, not just a relaxed downloader; postprocess, QA, and subset stages must all accept empty merged parquet outputs.

## Key Issues

- The behavior change is local on `feature/step1-better-progress-logging`; it is not merged into `main`.
- The failed `i_cmod_25_2_hectomap_004` run was produced by the old behavior and should be rerun from this updated branch if you want those empty tracts to be treated as warnings instead of chunk-fatal failures.
- Verified tests: `uv run pytest step1/tests/test_run_tract_sql_pipeline_unit.py step1/tests/test_postprocess_catalog_run_unit.py step1/tests/test_examine_tract_quality_unit.py`.
- Verified tests: `uv run pytest step1/tests/test_run_tract_sql_pipeline_functional.py step1/tests/test_postprocess_catalog_run_functional.py`.
- Immediate next action: rerun the affected chunk manually and confirm that empty tracts now record `empty_selection` and the campaign continues to the next tract.
