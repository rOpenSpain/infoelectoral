#' @title municipios
#'
#'
#' @description Esta función descarga los datos de voto a candidaturas a nivel de municipio de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipoeleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param yr El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#' @param distritos TRUE o FALSE, segun se quieran los resultados de los distritos de los municipios que tienen división distrital. FALSE por defecto.
#'
#' @return Dataframe con los datos de voto a candidaturas por mesas.
#'
#' @import stats
#' @import utils
#' @import readr
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr as_tibble
#' @importFrom dplyr %>%
#' @export
#'
municipios <- function(tipoeleccion, yr, mes, distritos = FALSE) {


  ### Construyo la url al zip de la elecciones
  if (tipoeleccion == "municipales") {
    tipo <- "04"
  } else if (tipoeleccion == "generales") {
    tipo <- "02"
  }

  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipo, yr, mes, "_MUNI", ".zip")

  ###
  tempd <- tempdir()
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)


  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 4) == paste0("06", tipo)]
  xbasicos <- todos[substr(todos, 1, 4) == paste0("05", tipo)]
  xcandidaturas <- todos[substr(todos, 1, 4) == paste0("03", tipo)]

  # Porsiaca de datos de voto en municipio
  if (length(x) == 0) {
    x <- todos[substr(todos, 15, 18) == paste0("06", tipo)]
  } else if (length(x) > 1) {
    x <- x[1]
  }

  #Porsiaca de basicos
  if (length(xbasicos) == 0) {
    xbasicos <- todos[substr(todos, 15, 18) == paste0("05", tipo)]
  } else if (length(xbasicos) > 1) {
    xbasicos <- xbasicos[1]
  }

  # Porsiaca de candidaturas
  if (length(xcandidaturas) == 0) {
    xcandidaturas <- todos[substr(todos, 15, 18) == paste0("03", tipo)]
  } else if (length(xcandidaturas) > 1) {
    xcandidaturas <- xcandidaturas[1]
  }


  dfmunicipios <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfmunicipios <- as_tibble(dfmunicipios)

  dfbasicos <- read_lines(file.path(tempd, xbasicos), locale = locale(encoding = "ISO-8859-1"))
  dfbasicos <- as_tibble(dfbasicos)

  dfcandidaturas <- read_lines(file.path(tempd, xcandidaturas), locale = locale(encoding = "ISO-8859-1"))
  dfcandidaturas <- as_tibble(dfcandidaturas)

  borrar <-  list.files(tempd, full.names = T, recursive = T)
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
  dfbasicos$pob.derecho <- as.numeric(substr(lineas, 129, 136))
  dfbasicos$n.mesas <- as.numeric(substr(lineas, 137, 141))
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
  df <- merge(df, dfcandidaturas, by = c("eleccion", "year", "mes", "partido"), all.x = T)


  # Quito los espacios en blanco a los lados de estas variables
  df$nombre.municipio <- str_trim(df$nombre.municipio)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Creo la columna CODIGOINE con la concatenación del codigo de la provincia y el del municipio
  df$CODIGOINE <- paste0(df$provincia, df$municipio)

  df <- df[, c(1:7, 31, 8:30)] # Reordeno


  # Bucle para devolver o no los resultados de los distritos
  if (distritos == FALSE) {
    df <- df[df$distrito == 99,]
  }

  return(df)
}
