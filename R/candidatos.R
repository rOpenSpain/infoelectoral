#' @title candidatos
#'
#'
#' @description Esta función descarga los datos de los candidatos de las listas electorales de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipoeleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param yr El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#'
#' @return Dataframe con los datos de candidatos.
#'
#' @import stats
#' @import utils
#' @import readr
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr as_tibble
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#'
#' @export
#'
candidatos <- function(tipoeleccion, yr, mes) {

  distrito <- CODIGOINE <- eleccion <- ccaa <- provincia <- nombre.municipio <- comarca <- num_candidato <- nconcejales <- tipo_candidato <- nombre <- code.nacional <- pob.derecho <- candidaturas <- oficiales <- municipio <- NULL

  ### Constuyo la url al zip de la eleccio

  if (tipoeleccion == "municipales") {
    tipo <- "04"
  } else if (tipoeleccion == "generales") {
    tipo <- "02"
  }


  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipo, yr, mes, "_MUNI", ".zip")


  temp <- tempfile(fileext = ".zip")
  tempd <- tempdir()

  download.file(url,temp, mode = "wb")
  unzip(temp, exdir = tempd)


  todos <- list.files(tempd, recursive = T)
  x <- todos[substr(todos, 1, 4) == paste0("04", tipo)]
  xbasicos <- todos[substr(todos, 1, 4) == paste0("05", tipo)]
  xcandidaturas <- todos[substr(todos, 1, 4) == paste0("03", tipo)]



  dfcandidatos <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1")) %>% as_tibble()
  dfbasicos <- read_lines(file.path(tempd, xbasicos), locale = locale(encoding = "ISO-8859-1")) %>% as_tibble()
  dfcandidaturas <- read_lines(file.path(tempd, xcandidaturas), locale = locale(encoding = "ISO-8859-1")) %>% as_tibble()

  borrar <- list.files(tempd, pattern = "DAT|MESA|doc|rtf|zip", full.names = T, include.dirs = T,all.files = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfcandidatos$value

  dfcandidatos$eleccion <- substr(lineas, 1, 2)
  dfcandidatos$year <- substr(lineas, 3, 6)
  dfcandidatos$mes <- substr(lineas, 7, 8)
  dfcandidatos$provincia <- substr(lineas, 10, 11)
  dfcandidatos$distrito <- substr(lineas, 12, 12)
  dfcandidatos$municipio <- substr(lineas, 13, 15)
  dfcandidatos$partido <- substr(lineas, 16, 21)
  dfcandidatos$num_candidato <- substr(lineas, 22, 24)
  dfcandidatos$tipo_candidato <- substr(lineas, 25, 25)
  dfcandidatos$nombre <- substr(lineas, 26, 50)
  dfcandidatos$apellido1 <- substr(lineas, 51, 75)
  dfcandidatos$apellido2 <- substr(lineas, 76, 100)
  dfcandidatos$sexo <- substr(lineas, 101, 101)
  dfcandidatos$nacimiento_dia <- substr(lineas, 102, 103)
  dfcandidatos$nacimiento_mes <- substr(lineas, 104, 105)
  dfcandidatos$nacimiento_year <- substr(lineas, 106, 109)
  dfcandidatos$nacimiento <- as.Date(dfcandidatos$nacimiento_year, dfcandidatos$nacimiento_mes, dfcandidatos$nacimiento_dia)
  dfcandidatos$dni <- substr(lineas, 110, 119)
  dfcandidatos$electo <- substr(lineas, 120, 120)


  dfcandidatos <- dfcandidatos[, -1]

  dfcandidatos$distrito[dfcandidatos$distrito == "9"] <- "99"

  ##### Datos basicos de municipio

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
  dfbasicos <- dfbasicos[dfbasicos$distrito == "99",]

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
  df <- merge(dfbasicos, dfcandidatos, by = c("eleccion", "year", "mes", "provincia", "municipio", "distrito"), all = T)
  df <- merge(df, dfcandidaturas, by = c("eleccion", "year", "mes", "partido"), all.x = T)


  # Quito los espacios en blanco a los lados de estas variables
  df$nombre.municipio <- str_trim(df$nombre.municipio)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  df <- df %>% mutate_all(str_trim) %>%
    mutate(denominacion = str_remove_all(denominacion, '"')) %>%
    as_tibble()

  # Creo la columna CODIGOINE con la concatenación del codigo de la provincia y el del municipio
  df$CODIGOINE <- paste0(df$provincia, df$municipio)

  df <- df %>% select(CODIGOINE, eleccion:mes, ccaa, provincia:distrito,
                      nombre.municipio, comarca, num_candidato,
                      nconcejales, tipo_candidato, nombre:code.nacional,
                      pob.derecho:candidaturas, oficiales) %>%
    arrange(provincia, municipio)


  return(df)
}
