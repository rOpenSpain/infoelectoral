#' @title basicos
#'
#' @description Esta función descarga los datos globales de las mesas de unas elecciones, los importa al espacio de trabajo, y los formatea.
#'
#' @param url url a los datos del Ministerio del Interior.
#'
#' @return Dataframe con los datos globales de las mesas.
#'
#' @import stats
#' @import utils
#' @import readr
#' @importFrom dplyr as_data_frame
#'
#' @export

basicos <- function(url) {

  temp <- tempfile(fileext = ".zip")
  tempd <- tempdir()

  download.file(url,temp, mode = "wb")
  unzip(temp, exdir = tempd)

  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 2) == "09"]

  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 16) == "09"]
  }


  dfbasicos <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfbasicos <- as_data_frame(dfbasicos)

  borrar <- list.files(tempd, pattern = "DAT|MESA|doc|rtf|zip", full.names = T, include.dirs = T,all.files = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfbasicos$value

  dfbasicos$eleccion <- substr(lineas, 1, 2)
  dfbasicos$year <- substr(lineas, 3, 6)
  dfbasicos$mes <- substr(lineas, 7, 8)
  dfbasicos$ccaa <- substr(lineas, 10, 11)
  dfbasicos$provincia <- substr(lineas, 12, 13)
  dfbasicos$municipio <- substr(lineas, 14, 16)
  dfbasicos$distrito <- substr(lineas, 17, 18)
  dfbasicos$seccion <- substr(lineas, 19, 22)
  dfbasicos$mesa <- substr(lineas, 23, 23)
  dfbasicos$censo.INE <- as.numeric(substr(lineas, 24, 30))
  dfbasicos$CERA <- as.numeric(substr(lineas, 31, 37))
  dfbasicos$CERE <- as.numeric(substr(lineas, 38, 44))
  dfbasicos$votantes.CERE <- as.numeric(substr(lineas, 45, 51))
  dfbasicos$blancos <- as.numeric(substr(lineas, 66, 72))
  dfbasicos$nulos <- as.numeric(substr(lineas, 73, 79))
  dfbasicos$candidaturas <- as.numeric(substr(lineas, 80, 86))

  dfbasicos <- dfbasicos[,-1]

  dfbasicos <<- dfbasicos

}
