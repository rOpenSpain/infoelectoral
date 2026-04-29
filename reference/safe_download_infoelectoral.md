# Downloads the elections zip file

Downloads the elections zip file

## Usage

``` r
safe_download_infoelectoral(url, tempfile, get = httr::GET)
```

## Arguments

- url:

  The URL of the elections zip to download

- tempfile:

  The path to save the downloaded file

## Value

The path to the downloaded file, or `NULL` if the remote resource is
unavailable.
