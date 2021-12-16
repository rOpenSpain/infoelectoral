# infoelectoral

<!-- badges: start -->
[![R-CMD-check](https://github.com/ropenspain/infoelectoral/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenSpain/infoelectoral/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/infoelectoral)](https://CRAN.R-project.org/package=infoelectoral)
[![License: GPL-2](https://img.shields.io/badge/license-GPL--2-blue.svg)](https://cran.r-project.org/web/licenses/GPL-2)
[![rOS-badge](https://ropenspain.github.io/rostemplate/reference/figures/ropenspain-badge.svg)](https://ropenspain.es/)
<!-- badges: end -->

[infoelectoral](https://ropenspain.github.io/infoelectoral/) is a R library that helps retrieve and analize official electoral results for Spain from the [Ministry of the Interior](http://www.infoelectoral.mir.es/infoelectoral/min/). It allows you to download the results of general, european and municipal elections of any year at the polling station and municipality level. 


# How to install?

```
devtools::install_github("ropenspain/infoelectoral")
```

# How to use it
[infoelectoral](https://ropenspain.github.io/infoelectoral/) has three functions:

1. `mesas()` downloads the electoral results data of the selected election at the polling station level.
2. `municipios()` downloads the electoral results data of the selected election at the municipality level.
3. `candidatos()` downloads the candidates data of the selected elections. 

## Example

```
library(infoelectoral)
congress_1979 <- municipios(tipoeleccion = "congreso", yr = 1979, mes = "03")

```

