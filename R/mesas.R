#' @title mesas
#'
#'
#' @description Esta función descarga los datos de voto a candidaturas a nivel de mesas de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipoeleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param yr El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#'
#' @return Dataframe con los datos de voto a candidaturas por mesas.
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#' @importFrom readr read_lines
#' @importFrom readr locale
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr as_tibble
#' @importFrom dplyr %>%
#'
#' @export
mesas <- function(tipoeleccion, yr, mes) {

  ### Construyo la url al zip de la elecciones...

  if (tipoeleccion == "municipales") {
    tipoeleccion <- "04"
  } else if (tipoeleccion == "generales") {
    tipoeleccion <- "02"
  }

  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipoeleccion, yr, mes, "_MESA", ".zip")

  ###
  tempd <- tempdir(check = F)
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)

  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 2) == "10"]
  xbasicos <- todos[substr(todos, 1, 2) == "09"]
  xcandidaturas <- todos[substr(todos, 1, 2) == "03"]

  # Porsiaca de datos de mesa
  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 16) == "10"]
  }

  #Porsiaca de basicos
  if (length(xbasicos) == 0) {
    xbasicos <- todos[substr(todos, 15, 16) == "09"]
  }

  # Porsiaca de candidaturas
  if (length(xcandidaturas) == 0) {
    xcandidaturas <- todos[substr(todos, 15, 16) == "03"]
  }


  dfmesas <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfmesas <- as_tibble(dfmesas)

  dfbasicos <- read_lines(file.path(tempd, xbasicos), locale = locale(encoding = "ISO-8859-1"))
  dfbasicos <- as_tibble(dfbasicos)

  dfcandidaturas <- read_lines(file.path(tempd, xcandidaturas), locale = locale(encoding = "ISO-8859-1"))
  dfcandidaturas <- as_tibble(dfcandidaturas)

  borrar <-  list.files(tempd, full.names = T, recursive = T)
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



  ##### Datos basicos de mesa

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

  df <- merge(dfbasicos, dfmesas, by = c("eleccion", "year", "mes", "ccaa", "provincia", "municipio", "distrito", "seccion", "mesa"), all = T)
  df <- merge(df, dfcandidaturas, by = c("eleccion", "year", "mes", "partido"), all.x = T)


  # Quito los espacios en blanco a los lados de estas variables
  df$seccion <- str_trim(df$seccion)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Creo la columna CUSEC codificada como los shapefiles del INE
  df$CUSEC <- paste0(df$provincia, df$municipio, df$distrito, df$seccion)
  df <- df[, c(1:11, 24, 12:23)]


  return(df)

}
