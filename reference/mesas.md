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

data.frame with the electoral results data at the polling station level.

## Examples

``` r
# \donttest{
data <- mesas(tipo_eleccion = "congreso", anno = "2023", mes = "07")
#> Downloading https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/02202307_MESA.zip
#> Error in curl::curl_fetch_memory(url, handle = handle): SSL peer certificate or SSH remote key was not OK [infoelectoral.interior.gob.es]:
#> SSL certificate problem: unable to get local issuer certificate
str(data)
#> function (..., list = character(), package = NULL, lib.loc = NULL, verbose = getOption("verbose"), 
#>     envir = .GlobalEnv, overwrite = TRUE)  
# }
```
