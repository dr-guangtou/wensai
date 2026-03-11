---
date: 2026-03-03
tags:
  - development
  - dev/frankenz
---
# frankenz — main — 2026-03-03

## Progress
- Replaced fixed KDE bandwidth (`ZSMOOTH=0.01`) with a z-proportional scheme: `bandwidth = max(fraction * z_spec, floor)`, where both `fraction` and `floor` are configurable via `pdf.kde_bandwidth_fraction` and `pdf.kde_bandwidth_floor` in `PDFConfig`
- Added the two new config fields to `frankenz/config.py` (`PDFConfig` dataclass) and `example/frankenz_config.yaml`
- Updated `load_hsc_data()` in `example/run_photoz.py` to accept a `config` parameter and derive bandwidth from it, removing the hardcoded `ZSMOOTH` constant
- Fixed `np.trapezoid` compatibility in the example script for NumPy 1.x (added try/except shim, same pattern already used in the library itself)
- Ran a 13-config parameter sweep benchmarking point estimates (bias, sNMAD, f_out) and PDF quality (coverage, CRPS) across bandwidth settings

## Current State

### Parameter Sweep Results (10k HSC S20 tutorial data)

| Config (frac, floor) | sNMAD | f_out | cov68 | cov95 | CRPS |
|---|---|---|---|---|---|
| 0.01, 0.01 (old baseline) | 0.067 | 0.204 | 0.178 | 0.321 | 0.255 |
| 0.05, 0.03 | 0.067 | 0.204 | 0.376 | 0.592 | 0.243 |
| 0.10, 0.05 | 0.066 | 0.203 | 0.534 | 0.745 | 0.235 |
| 0.15, 0.08 | 0.066 | 0.201 | 0.649 | 0.829 | 0.229 |
| 0.20, 0.10 | 0.067 | 0.199 | 0.718 | 0.865 | 0.226 |

Point estimates are invariant to bandwidth; coverage and CRPS improve monotonically with wider bandwidth, confirming the baseline was severely under-dispersed.

### Key Issues
- Coverage still below nominal even at the widest tested bandwidth (0.718 vs 0.680 target for 68%) — likely needs the full 709k training set or post-hoc recalibration to fully close the gap
- The 10k tutorial dataset is a small subset; results with the full training catalog may differ
- Default config values (`0.01, 0.01`) still match the old baseline — user should choose production values based on their dataset

### Next Steps
- Settle on default `kde_bandwidth_fraction` / `kde_bandwidth_floor` values for production use
- Test with the full 709k HSC S20 training catalog on the remote machine
- Consider post-hoc PDF recalibration (e.g., Bordoloi et al. 2010 method) as a complementary approach
- Begin Phase 03 (HSC pipeline integration)

## Lessons Learned
- KDE bandwidth only affects PDF width, not point estimates — sNMAD and f_out are determined by the neighbor selection and weighting, not the smoothing kernel
- The z-proportional bandwidth is physically motivated: photo-z uncertainties scale with redshift, so `sigma ~ 0.01 * (1+z)` or `sigma ~ frac * z` is a natural scaling
- HSC zerr column has 31% sentinel values (-9, 0, 99) — these must never be used as bandwidth directly
- PIT histogram shape directly diagnoses PDF calibration: U-shaped = under-dispersed (our baseline), flat = well-calibrated, hump = over-dispersed

---
*Agent: Claude Code (claude-opus-4-6) · Session: [paste session ID here]*
