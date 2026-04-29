# Download data at the municipality level

\`municipios()\` downloads, formats and imports to the environment the
electoral results data of the selected election at the municipality
level.

## Usage

``` r
municipios(tipo_eleccion, anno, mes, distritos = FALSE)
```

## Arguments

- tipo_eleccion:

  The type of choice you want to download. The accepted values are
  "congreso", "senado", "europeas" o "municipales".

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

- distritos:

  Should district level results be returned when available? The default
  is FALSE. Please be aware when summarizing the data that districts =
  TRUE will return separate rows for the total municipal level and for
  each of the districts.

## Value

Dataframe with the electoral results data at the municipality level.

## Examples

``` r
# \donttest{
data <- municipios(tipo_eleccion = "congreso", anno = "2019", mes = "11")
#> Downloading https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/02201911_MUNI.zip
#> Error in curl::curl_fetch_memory(url, handle = handle): SSL peer certificate or SSH remote key was not OK [infoelectoral.interior.gob.es]:
#> SSL certificate problem: unable to get local issuer certificate
str(data)
#> function (..., list = character(), package = NULL, lib.loc = NULL, verbose = getOption("verbose"), 
#>     envir = .GlobalEnv, overwrite = TRUE)  
# }
```
