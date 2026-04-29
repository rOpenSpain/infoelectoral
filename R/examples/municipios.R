\donttest{
data <- municipios(tipo_eleccion = "congreso", anno = "2019", mes = "11")
if (!is.null(data)) {
  str(data)
}
}
