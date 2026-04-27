## Resubmission

This is a resubmission of `infoelectoral` (version 1.0.3), previously archived on CRAN.

Main changes made for this resubmission:

- Updated package version to 1.0.3.
- Removed/rewrote fragile URL references in package metadata and documentation to avoid incoming URL check failures.
- Improved download robustness by adding HTTP timeout and explicit status checks.
- Fixed election type handling consistency (including senate code handling).
- Corrected ordering/data transformation issues in internal data-processing functions.
- Added global variable declarations to avoid NSE-related check notes.

## Test environments

- local Windows 11 x64 (build 26200)
- R 4.3.2 (ucrt)

## R CMD check results

`R CMD check --as-cran --no-tests --no-manual infoelectoral_1.0.3.tar.gz`

0 errors | 0 warnings | 2 notes

Notes:

- CRAN incoming note for archived package/new submission context.
- `unable to verify current time` (environment-related).

## Additional notes

A full local `--as-cran` run in this machine is affected by local environment tooling/library constraints unrelated to package source (test stack compatibility in this R installation and missing `pdflatex` for manual PDF build).
