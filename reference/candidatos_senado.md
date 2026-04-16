# candidatos_senado

\`candidatos_senado()\` downloads, formats and imports to the
environment the data of the Senate candidates of the selected elections.

## Usage

``` r
candidatos_senado(anno, mes, nivel)
```

## Arguments

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

- nivel:

  The administrative level for which the data is wanted ("mesa" for
  polling stations or "municipio" for municipalities).

## Value

data.frame with the data for the Senate candidates.
