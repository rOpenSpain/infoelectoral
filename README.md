# infoelectoral

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/hmeleiro/infoelectoral/workflows/R-CMD-check/badge.svg)](https://github.com/hmeleiro/infoelectoral/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/infoelectoral)](https://CRAN.R-project.org/package=infoelectoral)
[![License: GPL-2](https://img.shields.io/badge/license-GPL--2-blue.svg)](https://cran.r-project.org/web/licenses/GPL-2)
<!-- badges: end -->

[infoelectoral](https://hmeleiro.github.io/infoelectoral/) es una librería de R para descargar resultados electorales oficiales de España del [Ministerio del Interior](http://www.infoelectoral.mir.es/infoelectoral/min/). Permite descargar resultados de las elecciones generales y municipales de cualquier año a nivel de mesa electoral y de municipio.

[infoelectoral](https://hmeleiro.github.io/infoelectoral/) is a R library that helps retrieve and analize official electoral results for Spain from the [Ministry of the Interior](http://www.infoelectoral.mir.es/infoelectoral/ min /). It allows you to download the results of general, european and municipal elections of any year at the polling station and municipality level. 


# How to install?

```
devtools::install_github("hmeleiro/infoelectoral")
```

# How to use it
[infoelectoral](https://hmeleiro.github.io/infoelectoral/) has three functions:

1. `mesas()` downloads the electoral results data of the selected election at the polling station level.
2. `municipios()` downloads the electoral results data of the selected election at the municipality level.
3. `candidatos()` downloads the candidates data of the selected elections.

## For example
Para descargar los resultados electorales a nivel de municipio de las elecciones generales de marzo de 1979 (e importarlos directamente al entorno) se debe introducir:

```
library(infoelectoral)
congress_1979 <- municipios(tipoeleccion = "congreso", yr = 1979, mes = "03")

```

