#' @title municipios
#'
#'
#' @description Esta función descarga los datos de voto a candidaturas a nivel de municipio de las elecciones seleccionadas, los importa al espacio de trabajo, y los formatea.
#'
#' @param tipoeleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param yr El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
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
municipios <- function(tipoeleccion, yr, mes) {


  ### Constuyo la url al zip de la eleccio

  if (tipoeleccion == "municipales") {
    tipoeleccion <- "04"
  } else if (tipoeleccion == "generales") {
    tipoeleccion <- "02"
  }

  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipoeleccion, yr, mes, "_MUNI", ".zip")

  ###


  temp <- tempfile(fileext = ".zip")
  tempd <- tempdir()

  download.file(url,temp, mode = "wb")
  unzip(temp, exdir = tempd)

  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 2) == "06"]
  xbasicos <- todos[substr(todos, 1, 2) == "05"]
  xcandidaturas <- todos[substr(todos, 1, 2) == "03"]

  # Porsiaca de datos de voto en municipio
  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 16) == "06"]
  } else if (length(x) > 1) {
    x <- x[1]
  }

  #Porsiaca de basicos
  if (length(xbasicos) == 0) {
    xbasicos <- todos[substr(todos, 15, 16) == "05"]
  } else if (length(xbasicos) > 1) {
    xbasicos <- xbasicos[1]
  }

  # Porsiaca de candidaturas
  if (length(xcandidaturas) == 0) {
    xcandidaturas <- todos[substr(todos, 15, 16) == "03"]
  } else if (length(xcandidaturas) > 1) {
    xcandidaturas <- xcandidaturas[1]
  }

  dfmunicipios <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfmunicipios <- as_data_frame(dfmunicipios)

  dfbasicos <- read_lines(file.path(tempd, xbasicos), locale = locale(encoding = "ISO-8859-1"))
  dfbasicos <- as_data_frame(dfbasicos)

  dfcandidaturas <- read_lines(file.path(tempd, xcandidaturas), locale = locale(encoding = "ISO-8859-1"))
  dfcandidaturas <- as_data_frame(dfcandidaturas)

  borrar <- list.files(tempd, pattern = "DAT|MESA|doc|rtf|zip", full.names = T, include.dirs = T,all.files = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfmunicipios$value

  dfmunicipios$eleccion <- substr(lineas, 1, 2)
  dfmunicipios$year <- substr(lineas, 3, 6)
  dfmunicipios$mes <- substr(lineas, 7, 8)
  dfmunicipios$provincia <- substr(lineas, 10, 11)
  dfmunicipios$municipio <- substr(lineas, 12, 14)
  dfmunicipios$distrito <- substr(lineas, 15, 16)
  dfmunicipios$partido <- as.character(substr(lineas, 17, 22))
  dfmunicipios$votos <- as.numeric(substr(lineas, 23, 30))
  dfmunicipios$concejales <- as.numeric(substr(lineas, 31, 33))

  dfmunicipios <- dfmunicipios[, -1]

  ##### Datos basicos de mesa

  lineas <- dfbasicos$value

  dfbasicos$eleccion <- substr(lineas, 1, 2)
  dfbasicos$year <- substr(lineas, 3, 6)
  dfbasicos$mes <- substr(lineas, 7, 8)
  dfbasicos$ccaa <- substr(lineas, 10, 11)
  dfbasicos$provincia <- substr(lineas, 12, 13)
  dfbasicos$municipio <- substr(lineas, 14, 16)
  dfbasicos$distrito <- substr(lineas, 17, 18)
  dfbasicos$nombre.municipio <- substr(lineas, 19, 118)
  dfbasicos$comarca <- substr(lineas, 126, 128)
  dfbasicos$pob.derecho <- substr(lineas, 129, 136)
  dfbasicos$n.mesas <- substr(lineas, 137, 141)
  dfbasicos$censo.INE <- as.numeric(substr(lineas, 142, 149))
  dfbasicos$INE.escrutinio <- as.numeric(substr(lineas, 150, 157))
  dfbasicos$CERE.escrutinio <- as.numeric(substr(lineas, 158, 165))
  dfbasicos$CERE.votantes <- as.numeric(substr(lineas, 166, 173))
  dfbasicos$participacion1 <- as.numeric(substr(lineas, 174, 181))
  dfbasicos$participacion2 <- as.numeric(substr(lineas, 182, 189))
  dfbasicos$blancos <- as.numeric(substr(lineas, 190, 197))
  dfbasicos$nulos <- as.numeric(substr(lineas, 198, 205))
  dfbasicos$candidaturas <- as.numeric(substr(lineas, 206, 213))
  dfbasicos$nconcejales <- as.numeric(substr(lineas, 214, 216))
  dfbasicos$oficiales <- substr(lineas, 233, 233)

  dfbasicos <- dfbasicos[,-1]


  #### Datos de candidaturas

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

  ## Hago merge para juntar los data frames
  df <- merge(dfbasicos, dfmunicipios, by = c("eleccion", "year", "mes", "provincia", "municipio", "distrito"), all = T)
  df <- merge(df, dfcandidaturas, by = c("eleccion", "year", "mes", "partido"), all = T)

  dftotal <<- df
  dfmunicipios <<- dfmunicipios
  dfbasicos <<- dfbasicos
  dfcandidaturas <<- dfcandidaturas

}

