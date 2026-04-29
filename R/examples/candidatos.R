\donttest{
data <- candidatos(
  tipo_eleccion = "senado", anno = "2004",
  mes = "03", nivel = "municipio"
)
if (!is.null(data)) {
  str(data)
}
}
