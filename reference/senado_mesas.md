# senado_mesas

\`senado_mesas\` downloads the Senate candidates data at the polling
station level.

## Usage

``` r
senado_mesas(anno, mes)
```

## Arguments

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

## Value

data.frame with the data for the Senate candidates, or `NULL` if the
remote resource is unavailable.
