# Download data at the polling station level

\`mesas()\` downloads, formats and imports to the environment the
electoral results data of the selected election at the polling station
level.

## Usage

``` r
mesas(tipo_eleccion, anno, mes)
```

## Arguments

- tipo_eleccion:

  The type of choice you want to download. The accepted values are
  "congreso", "senado", "europeas" o "municipales".

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

## Value

data.frame with the electoral results data at the polling station level,
or `NULL` if the remote resource is unavailable.

## Examples

``` r
# \donttest{
data <- mesas(tipo_eleccion = "congreso", anno = "2023", mes = "07")
#> Downloading https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/02202307_MESA.zip
#> Could not download https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/02202307_MESA.zip: Timeout was reached [infoelectoral.interior.gob.es]:
#> Connection timed out after 10002 milliseconds. The remote resource may be temporarily unavailable.
if (!is.null(data)) {
  str(data)
}
# }
```
