#' @title Generates the election type code from a string
#'
#' @param tipo_eleccion The type of choice you want to download. The accepted values are "congreso", "senado", "europeas" o "municipales".
#'
#' @return A string
#'
#' @keywords internal
#'
election_type_code <- function(tipo_eleccion) {
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
  } else if (tipo_eleccion == "congreso") {
    tipo <- "02"
  } else if (tipo_eleccion == "senado") {
    tipo <- "03"
  } else if (tipo_eleccion == "europeas") {
    tipo <- "07"
  } else if (tipo_eleccion == "cabildos") {
    tipo <- "06"
  } else {
    stop('The argument tipo_eleccion must take one of the following values: "congreso", "senado", "municipales", "europeas", "cabildos"')
  }

  return(tipo)
}
