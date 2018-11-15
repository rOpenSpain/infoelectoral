#' @title mesas
#'
#'
#' @description Esta función descarga los datos de voto a candidaturas por mesas de unas elecciones, los importa al espacio de trabajo, y los formatea.
#'
#' @param url url a los datos del Ministerio del Interior de una elección determinada.
#'
#' @return Dataframe con los datos de voto a candidaturas por mesas.
#'
#' @import stats
#' @import utils
#' @import readr
#' @importFrom dplyr as_data_frame
#'
#' @export
#'
mesas <- function(url) {

  temp <- tempfile(fileext = ".zip")
  tempd <- tempdir()

  download.file(url,temp, mode = "wb")
  unzip(temp, exdir = tempd)

  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 2) == "10"]

  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 16) == "10"]
  }


  dfmesas <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfmesas <- as_data_frame(dfmesas)

  borrar <- list.files(tempd, pattern = "DAT|MESA|doc|rtf|zip", full.names = T, include.dirs = T,all.files = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfmesas$value

  dfmesas$eleccion <- substr(lineas, 1, 2)
  dfmesas$year <- substr(lineas, 3, 6)
  dfmesas$mes <- substr(lineas, 7, 8)
  dfmesas$ccaa <- substr(lineas, 10, 11)
  dfmesas$provincia <- substr(lineas, 12, 13)
  dfmesas$municipio <- substr(lineas, 14, 16)
  dfmesas$distrito <- substr(lineas, 17, 18)
  dfmesas$seccion <- substr(lineas, 19, 22)
  dfmesas$mesa <- substr(lineas, 23, 23)
  dfmesas$partido <- as.character(substr(lineas, 24, 29))
  dfmesas$votos <- as.numeric(substr(lineas, 30, 36))

  dfmesas <- dfmesas[, -1]

  dfmesas <<- dfmesas
}
