# elecciones

Esto es una librería de R para descarga resultados electorales de España del [Ministerio del Interior](http://www.infoelectoral.mir.es/infoelectoral/min/). Por ahora solo permite descargar lo resultados de las elecciones generales y municipales a nivel de mesa electoral y de municipio. Sigo trabajando para ampliarlo.


# Cómo instalarlo

```
devtools::install_github("meneos/elecciones")
```

# Cómo usarlo

La librería tiene dos funciones: 

1. ``` mesas()``` para descargar datos a nivel de mesa electoral.
2. ``` municipios()``` para descargar datos a nivel de municipio.

Ambas funciones aceptan tres argumentos:

1. ``` tipoeleccion = c("generales", "municipales")```. El tipo de elección que se quiere descargar.
2. ``` yr```. El año de la elección en formato YYYY. Puede ir como número o como texto.
3. ``` mes```. El mes de la elección en formato mm. Se debe introducir el número del mes pero en forma texto (p.e: para mayo hay que introducir "05").

De tal forma que para descargar los resultados electorales a nivel de mesa electoral de las elecciones municipales de mayo de 2015 se debe introducir:

```
elecciones::mesas(tipoeleccion = "municipales", yr = 2015, mes = "05")

```
