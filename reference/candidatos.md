# Download candidate data

\`candidatos()\` downloads, formats and imports to the environment the
data of the candidates from the electoral lists of the selected
elections.

## Usage

``` r
candidatos(tipo_eleccion, anno, mes, nivel)
```

## Arguments

- tipo_eleccion:

  The type of choice you want to download. The accepted values are
  "congreso", "senado", "europeas" o "municipales".

- anno:

  The year of the election in YYYY format.

- mes:

  The month of the election in MM format.

- nivel:

  The administrative level for which the data is wanted ("mesa" for
  polling stations or "municipio" for municipalities). Only necessary
  when tipo_eleccion = "senado"

## Value

data.frame with the candidates data, or `NULL` if the remote resource is
unavailable. If tipo_eleccion = "senado" a column called \`votos\` is
included with the votes recieved by each candidate. If other type of
election is selected this column is not included since the votes are not
received by the specific candidates but by the closed list of the party.

## Examples

``` r
# \donttest{
data <- candidatos(
  tipo_eleccion = "senado", anno = "2004",
  mes = "03", nivel = "municipio"
)
#> Downloading https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/03200403_MUNI.zip
#> Could not download https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/03200403_MUNI.zip: SSL peer certificate or SSH remote key was not OK [infoelectoral.interior.gob.es]:
#> SSL certificate problem: unable to get local issuer certificate. The remote resource may be temporarily unavailable.
if (!is.null(data)) {
  str(data)
}
# }
```
