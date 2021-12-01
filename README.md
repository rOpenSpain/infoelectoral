# [R-elecciones](https://r-elecciones.netlify.com/)

[R-elecciones](https://r-elecciones.netlify.com/) es una librería de R para descargar resultados electorales oficiales de España del [Ministerio del Interior](http://www.infoelectoral.mir.es/infoelectoral/min/). Permite descargar resultados de las elecciones generales y municipales de cualquier año a nivel de mesa electoral y de municipio.


# Cómo instalarlo

```
devtools::install_github("hmeleiro/infoelectoral")
```

# Cómo usarlo

La librería tiene cinco funciones: 

1. ``` mesas()``` para descargar datos a nivel de mesa electoral e importarlos al entorno.
2. ``` municipios()``` para descargar datos a nivel de municipio e importarlos al entorno.
3. ```candidatos()``` para descargar los datos de las listas electorales e importarlos al entorno.
3. ```download_mesas()``` para descargar datos a nivel de mesa electoral y guardarlos en la carpeta especificada.
4. ```download_municipios()``` para descargar datos a nivel de mesa municipio y guardarlos en la carpeta especificada.

Las funciones aceptan cuatro argumentos:

1. ``` tipoeleccion = c("generales", "municipales")```. El tipo de elección que se quiere descargar.
2. ``` yr```. El año de la elección en formato YYYY. Puede ir como número o como texto.
3. ``` mes```. El mes de la elección en formato mm. Se debe introducir el número del mes pero en forma texto (p.e: para mayo hay que introducir "05").
4. ```dir```. SOLO PARA LAS FUNCIONES DOWNLOAD: La carpeta donde se quiere guardar el resultado.

## Ejemplo
Para descargar los resultados electorales a nivel de municipio de las elecciones generales de marzo de 1979 (e importarlos directamente al entorno) se debe introducir:

```
library(infoelectoral)
generales.1979 <- municipios(tipoeleccion = "generales", yr = 1979, mes = "03")

```

Para descargar los resultados electorales a nivel de mesa electoral de las elecciones generales de octubre de 1982 (y guardarlos en una carpeta) se debe introducir:

```
library(infoelectoral)
download_mesas(tipoeleccion = "generales", yr = 1982, mes = "10", dir = "UNA-RUTA-VÁLIDA-A-UNA-CARPETA-EN-TU-ORDENADOR")
```

## Ejemplos de uso

Aquí algunos [ejemplos de uso](https://r-elecciones.netlify.com/posts/).
