\donttest{
data <- mesas(tipo_eleccion = "congreso", anno = "2023", mes = "07")
if (!is.null(data)) {
  str(data)
}
}
