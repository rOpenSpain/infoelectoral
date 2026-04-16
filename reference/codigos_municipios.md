# Administrative codes for spanish municipalities.

This dataset contains the INE codes of the municipalities of Spain with
their most recent names (eg: Cabrera d'Igualada appears as Cabrera
d'Anoia). For the municipalities that have been merged at some point,
their codes are kept separately along with that of the new municipality
created (eg: it contains the municipality Oza-Cesuras but also that of
Cesuras and Oza dos Ríos separately).

## Usage

``` r
codigos_municipios
```

## Format

A dataset with more than 8.000 rows and 3 columns:

- codigo_provincia:

  Code given to the provinces by the National Institute of Statistics

- codigo_municipio:

  Code given to the municipalities by the National Institute of
  Statistics

- municipio:

  Most recent official name of the municipality

## Source

<https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177031&menu=ultiDatos&idp=1254734710990>
