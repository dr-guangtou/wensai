---
date: 2026-02-27
repo: project1
branch: feature/dedup-window-no-dedup
tags:
  - journal
  - project1
  - arxiv-digest
  - llm-scoring
  - dedup
---

## Progress

- Added bounded digest-history dedup in `src/main.py` with `--dedup-days` defaulting to `2` and `--no-dedup` to bypass markdown-history dedup completely.
- Added debug-mode terminal diagnostics in `src/main.py` for fetched-paper counts by primary category before dedup, matched duplicates from previous digests, local-filter rejections, and LLM digest-filter rejections.
- Verified one live debug fetch against arXiv RSS with `uv run python src/main.py --debug --skip-scoring --no-summary --no-log-file`; output matched website counts exactly: `astro-ph.GA=23`, `astro-ph.CO=9`, `astro-ph.IM=6`, total `38`.
- Added `--llm-call-gap-seconds` in `src/main.py` and threaded pacing through `src/scorer.py` and `src/summarizer.py` so LLM scoring and summary calls remain sequential with an optional 5-second inter-call gap.
- Updated the LLM path so `could_be_interesting` papers remain in the final digest as title+link entries while only summary tiers proceed to summary generation.
- Renamed `llm_scoring.keep_tiers` to `llm_scoring.summary_tiers` in `src/config.py`, `src/main.py`, and `config.yaml`, with backward compatibility for legacy `keep_tiers` YAML.
- Tightened tier assignment in `src/scorer.py` so `somewhat_relevant` now requires `score > 6.0`; `score == 6.0` remains `could_be_interesting`.
- Updated project docs in `README.md`, `docs/SPEC.md`, and `docs/todo.md` to reflect dedup controls, debug diagnostics, `summary_tiers`, and the stricter LLM boundary.
- Added tests in `tests/test_digest_filename.py` and new file `tests/test_config_and_tiers.py` covering dedup cutoff logic, debug helpers, config compatibility, and the strict `> 6.0` threshold behavior.
- Wrote session handover files `docs/journal/2026-02-27_handover.md` and `docs/journal/2026-02-27_next-session-prompt.md`.

## Lessons Learned

- The RSS fetch path was not the source of the reported miss; a debug fetch confirmed the feed and category filtering were already returning the expected `38` papers for the day.
- Full-history markdown dedup was harder to reason about than the fetch-stage filters and caused avoidable confusion during debugging; a short dedup window is easier to validate operationally.
- `could_be_interesting` needed to be separated conceptually from summary eligibility; keeping it in the digest while excluding it from summaries required distinct digest and summary tier handling.
- The config name `keep_tiers` was misleading because it sounded like digest-output filtering; `summary_tiers` better matches the actual runtime behavior.
- Tightening the tier boundary required both a config change and a code change because the previous assignment logic treated the boundary as inclusive.
- The `obsidian` CLI command available in PATH earlier was not the correct one for the current setup; direct local-vault write worked around the missing API-key issue for the daily note snapshot.

## Key Issues

- Real provider-backed validation of the new `--llm-call-gap-seconds 5.0` pacing was not run yet; only mock-LLM and local/no-summary verification paths were exercised this session.
- The user still considers the LLM scorer too permissive on borderline papers; the stricter `> 6.0` boundary may help, but prompt calibration against user-selected examples is still a likely next step.
- `config.yaml` had pre-existing modifications before this session; future work should avoid assuming all current config diffs were introduced here.
- The working tree still includes uncommitted changes plus generated output `arxiv_digest/archive/2026/arxiv-2026-02-27.md`; decide in the next session whether to keep, clean, or commit these artifacts.
- Immediate next step: run one small real-provider digest pass with `--debug` and inspect whether the stricter threshold produces a healthier split between `somewhat_relevant` and `could_be_interesting`.
