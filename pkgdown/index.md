<!-- badges: start -->

[![R-CMD-check](https://github.com/ropenspain/infoelectoral/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenSpain/infoelectoral/actions) [![CRAN status](https://www.r-pkg.org/badges/version/infoelectoral)] [![License: GPL-2](https://img.shields.io/badge/license-GPL--2-blue.svg)](https://cran.r-project.org/web/licenses/GPL-2) [![rOS-badge](https://ropenspain.github.io/rostemplate/reference/figures/ropenspain-badge.svg)](https://ropenspain.es/)

<!-- badges: end -->

[infoelectoral](https://ropenspain.github.io/infoelectoral/) is a R library that helps retrieve official electoral results for Spain from the [Ministry of the Interior](https://infoelectoral.interior.gob.es/es/inicio/). It allows you to download the results of general, european and municipal elections of any year at the polling station and municipality level.

## Installation

``` r
# To install the latest stable version from CRAN:
install.packages("infoelectoral")

# To install the development version:
devtools::install_github("ropenspain/infoelectoral")
```

## Overview

[infoelectoral](https://ropenspain.github.io/infoelectoral/) has four functions:

-   `mesas()` downloads the electoral results data of the selected election at the polling station level.
-   `municipios()` downloads the electoral results data of the selected election at the municipality level.
-   `provincias()` downloads the electoral results data of the selected election at the constituency level.
-   `candidatos()` downloads the candidates data of the selected elections.

The package also includes some [datasets](https://ropenspain.github.io/infoelectoral/reference/index.html#datasets) with the official names of the territorial units and the election dates.

## Basic usage

``` r
library(infoelectoral)
df <- municipios(tipo_eleccion = "congreso", anno = 1982, mes = "10")
```

## Learn more

For a a extended example of how all functions work please check the vignettes:

-   [Get started](https://ropenspain.github.io/infoelectoral/articles/infoelectoral.html)
-   [Using infoelectoral to make electoral maps](https://ropenspain.github.io/infoelectoral/articles/municipios.html)
