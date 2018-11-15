# elecciones

Esto es una librería de R para descarga resultados electorales de España a nivel de mesa electoral del [Ministerio del Interior](http://www.infoelectoral.mir.es/infoelectoral/min/).

En un principio solo descarga algunos de los ficheros y solo de datos a nivel de mesa. Sigo trabajando para ampliarlo.

# Cómo usarlo

Para usar las funciones solo se necesita el link al zip del ministerio de alguna de elección. 

1. Ve al Área de descargas
2. Elige unas elecciones
3. Copia la url con la que te descargarías el zip (p.e: http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/03201606_MESA.zip)
4. Emplealo en alguna de las funciones:

```
url <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/03201606_MESA.zip"
elecciones::mesas(url)

```
