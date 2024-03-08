#' @title Download candidate data
#'
#' @description `candidatos()` downloads, formats and imports to the environment the data of the candidates from the electoral lists of the selected elections.
#'
#' @param tipo_eleccion The type of choice you want to download. The accepted values are "congreso", "senado", "europeas" o "municipales".
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#' @param nivel The administrative level for which the data is wanted ("mesa" for polling stations or "municipio" for municipalities). Only necessary when tipo_eleccion = "senado"
#'
#' @example R/examples/candidatos.R
#'
#' @return data.frame with the candidates data. If tipo_eleccion = "senado" a column called  `votos` is included with the votes recieved by each candidate. If other type of election is selected this column is not included since the votes are not received by the specific candidates but by the closed list of the party.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#'
#' @export
#'
candidatos <- function(tipo_eleccion, anno, mes, nivel) {

  ### Construyo la url al zip de la elecciones
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
    df <- candidatos_nosenado(tipo, anno, mes)
  } else if (tipo_eleccion == "congreso") {
    tipo <- "02"
    df <- candidatos_nosenado(tipo, anno, mes)
  } else if (tipo_eleccion == "europeas") {
    tipo <- "07"
    df <- candidatos_nosenado(tipo, anno, mes)
  } else if (tipo_eleccion == "cabildos") {
    tipo <- "06"
    df <- candidatos_nosenado(tipo, anno, mes)
  } else if (tipo_eleccion == "senado") {
    tipo <- "03"
    df <- candidatos_senado(anno, mes, nivel)
  } else {
    stop('The argument tipo_eleccion must take one of the following values: "congreso", "senado", "municipales", "europeas"')
  }

  return(df)
}
