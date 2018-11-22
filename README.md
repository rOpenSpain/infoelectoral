# elecciones

Esto es una librería de R para descarga resultados electorales oficiales de España del [Ministerio del Interior](http://www.infoelectoral.mir.es/infoelectoral/min/). Por ahora solo permite descargar resultados de las elecciones generales y municipales a nivel de mesa electoral y de municipio. Sigo trabajando para ampliarlo.


# Cómo instalarlo

```
devtools::install_github("meneos/elecciones")
```

# Cómo usarlo

La librería tiene cuatro funciones: 

1. ``` mesas()``` para descargar datos a nivel de mesa electoral e importarlos al entorno.
2. ``` municipios()``` para descargar datos a nivel de municipio e importarlos al entorno.
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
library(elecciones)
generales.1979 <- municipios(tipoeleccion = "generales", yr = 1979, mes = "03")

```

Para descargar los resultados electorales a nivel de mesa electoral de las elecciones generales de marzo de 1982 (y guardarlos en una carpeta) se debe introducir:

```
library(elecciones)
download_mesas(tipoeleccion = "generales", yr = 1979, mes = "03", dir = "UNA-RUTA-VÁLIDA-A-UNA-CARPETA-EN-TU-ORDENADOR")
```

# Qué devuelve

Ambas funciones devuelven cuatro data frames:

1. ``` dfcandidaturas```. El data frame con los datos básicos de todas las candidaturas (siglas, denominación, códigos de cabecera provincial, autonómica y estatal, etc...).
2. ``` dfbasicos```. El data frame con los datos básicos de los municipios o las mesas electorales (códigos de provincia, municipio, distrito, censo, etc...).
3. ``` dfmesas``` o ``` dfmunicipios```. El data frame con los resultados electorales de cada partido en cada mesa/municipio en formato [long](https://www.dummies.com/programming/r/understanding-data-in-long-and-wide-formats-in-r/).
4. ``` dftotal```. El data frame fusionado de los tres data frames anteriores.

Hay que tener en cuenta que en el caso de que se hayan descargado los datos a nivel de municipio, aparecerán por separado los resultados del total del municipio y los de los distritos de los municipios.
