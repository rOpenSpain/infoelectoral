\donttest{
data <- provincias(tipo_eleccion = "congreso", anno = "1982", mes = "10")
if (!is.null(data)) {
  str(data)
}
}
