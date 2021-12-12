#' @title senado
#'
#'
#' @description Esta función descarga los datos de los candidatos al Senado a nivel de mesa o municipio.
#'
#' @param anno El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#' @param nivel El nivel de desagregación para el que se quieren los datos. Puede ser "mesa" o "municipio".
#'
#' @return Dataframe con los datos de los senadores.
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#' @export
senado <- function(anno, mes, nivel) {


  if(nivel == "mesa") {
    df <- senado_mesas(anno, mes)
  } else if(nivel == "municipio") {
    df <- senado_municipios(anno, mes)
  } else {
    # errorCondition(message = 'El argumento nivel debe adoptar uno de los siguientes valores: "mesa", "municipio"')
    stop('El argumento nivel debe adoptar uno de los siguientes valores: "mesa", "municipio"')
  }

  return(df)
}
