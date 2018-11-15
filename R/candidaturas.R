#' @title candidaturas
#'
#' @description Esta función descarga los datos de candidaturas de unas elecciones, los importa al espacio de trabajo, y los formatea.
#'
#' @param url url a los datos del Ministerio del Interior de una elección determinada.
#'
#' @return Dataframe con los datos de candidaturas.
#'
#' @import stats
#' @import utils
#' @import readr
#' @importFrom dplyr as_data_frame
#'
#' @export
#'
candidaturas <- function(url) {


  temp <- tempfile(fileext = ".zip")
  tempd <- tempdir()

  download.file(url,temp, mode = "wb")
  unzip(temp, exdir = tempd)

  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 2) == "03"]

  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 16) == "03"]
  }


  dfcandidaturas <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfcandidaturas <- as_data_frame(dfcandidaturas)

  borrar <- list.files(tempd, pattern = "DAT|MESA|doc|rtf|zip", full.names = T, include.dirs = T,all.files = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfcandidaturas$value

  dfcandidaturas$eleccion <- substr(lineas, 1, 2)
  dfcandidaturas$year <- substr(lineas, 3, 6)
  dfcandidaturas$mes <- substr(lineas, 7, 8)
  dfcandidaturas$partido <- substr(lineas, 9, 14)
  dfcandidaturas$siglas <- substr(lineas, 15, 64)
  dfcandidaturas$denominacion <- substr(lineas, 65, 214)
  dfcandidaturas$code.provincia <- substr(lineas, 215, 220)
  dfcandidaturas$code.autonomia <- substr(lineas, 221, 226)
  dfcandidaturas$code.nacional <- substr(lineas, 227, 232)

  dfcandidaturas <- dfcandidaturas[ , -1]

  dfcandidaturas <<- dfcandidaturas
}
