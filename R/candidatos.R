#' @title Descarga datos de candidatos
#'
#' @description Esta función descarga los datos de los candidatos de las listas electorales de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipo_eleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param anno El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#' @param nivel El nivel para el que se quieren los datos ("mesa" o "municipio"). Solo necesario cuando tipo_eleccion = "senado"
#'
#' @return Dataframe con los datos de candidatos.
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
    stop('El argumento tipo_eleccion debe adoptar uno de los siguientes valores: "congreso", "senado", "municipales", "europeas"')
  }

  return(df)
}
