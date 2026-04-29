# infoelectoral

[infoelectoral](https://infoelectoral.spainelectoralproject.com/) is a R
library that helps retrieve official electoral results for Spain from
the [Ministry of the
Interior](https://infoelectoral.interior.gob.es/es/inicio/). It allows
you to download the results of general, european and municipal elections
of any year at the polling station and municipality level.

## Installation

You can install the latest stable version from CRAN:

``` r
install.packages("infoelectoral")
```

You can install the development version from GitHub:

``` r
devtools::install_github("ropenspain/infoelectoral")
```

## Overview

[infoelectoral](https://infoelectoral.spainelectoralproject.com/) has
four functions:

- [`mesas()`](https://infoelectoral.spainelectoralproject.com/reference/mesas.md)
  downloads the electoral results data of the selected election at the
  polling station level.
- [`municipios()`](https://infoelectoral.spainelectoralproject.com/reference/municipios.md)
  downloads the electoral results data of the selected election at the
  municipality level.
- [`provincias()`](https://infoelectoral.spainelectoralproject.com/reference/provincias.md)
  downloads the electoral results data of the selected election at the
  constituency level.
- [`candidatos()`](https://infoelectoral.spainelectoralproject.com/reference/candidatos.md)
  downloads the candidates data of the selected elections.

The package also includes some
[datasets](https://infoelectoral.spainelectoralproject.com/reference/index.html#datasets)
with the official names of the territorial units and the election dates.

## Basic usage

``` r
library(infoelectoral)
df <- municipios(tipo_eleccion = "congreso", anno = 1982, mes = "10")
```

## Learn more

For a a extended example of how all functions work please check the
vignettes:

- [Get
  started](https://infoelectoral.spainelectoralproject.com/articles/infoelectoral.html)
- [Using infoelectoral to make electoral
  maps](https://infoelectoral.spainelectoralproject.com/articles/municipios.html)
