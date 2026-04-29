## Resubmission

This is a resubmission of `infoelectoral` (version 1.0.3), previously archived on CRAN.

Main changes made for this resubmission:

- Updated package version to 1.0.3.
- Added the official Ministry of the Interior data source as an auto-linked
  reference in the `Description` field.
- Moved examples for functions that download data from `\dontrun{}` to
  `\donttest{}`.
- Removed/rewrote fragile URL references in package metadata and documentation to avoid incoming URL check failures.
- Improved download robustness by adding HTTP timeout, explicit status checks
  and graceful failure for network, SSL/certificate and invalid ZIP errors.
- Fixed election type handling consistency (including senate code handling).
- Corrected ordering/data transformation issues in internal data-processing functions.
- Added global variable declarations to avoid NSE-related check notes.

## Test environments

- local Windows 11 x64 (build 26200)
- R 4.5.3 (ucrt)

## R CMD check results

`R CMD check --no-manual --ignore-vignettes infoelectoral_1.0.3.tar.gz`

0 errors | 0 warnings | 0 notes

Also checked examples with donttest enabled:

`R CMD check --no-manual --ignore-vignettes --run-donttest infoelectoral_1.0.3.tar.gz`

0 errors | 0 warnings | 0 notes
