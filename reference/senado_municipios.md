# senado_municipios

\`senado_mesas\` downloads the Senate candidates data at the
municipality level.

## Usage

``` r
senado_municipios(anno, mes)
```

## Arguments

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

## Value

data.frame with the data for the Senate candidates, or `NULL` if the
remote resource is unavailable.
