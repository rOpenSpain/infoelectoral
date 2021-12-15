#' @title candidatos_senado
#'
#' @description `candidatos_senado()` downloads, formats and imports to the environment the data of the Senate candidates of the selected elections.
#'
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#' @param nivel The administrative level for which the data is wanted ("mesa" for polling stations or "municipio" for municipalities).
#'
#' @return data.frame with the data for the Senate candidates.
#'
#' @keywords internal
#'
candidatos_senado <- function(anno, mes, nivel) {
  if(nivel == "mesa") {
    df <- senado_mesas(anno, mes)
  } else if(nivel == "municipio") {
    df <- senado_municipios(anno, mes)
  } else {
    stop('The argumento nivel must take one of the following values: "mesa", "municipio".')
  }

  return(df)
}
