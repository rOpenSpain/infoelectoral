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
#' @importFrom dplyr relocate
#' @importFrom dplyr %>%
#' @importFrom rlang .data
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

  # # Porsiaca de datos de mesa
  # if (length(x) == 0) {
  #   x <- todos[substr(todos, 15, 16) == "10"]
  # }
  #
  # #Porsiaca de basicos
  # if (length(xbasicos) == 0) {
  #   xbasicos <- todos[substr(todos, 15, 16) == "09"]
  # }
  #
  # # Porsiaca de candidaturas
  # if (length(xcandidaturas) == 0) {
  #   xcandidaturas <- todos[substr(todos, 15, 16) == "03"]
  # }


  dfmesas <- read_lines(file.path(tempd, x), locale = locale(encoding = "ISO-8859-1"))
  dfmesas <- as_tibble(dfmesas)

  dfbasicos <- read_lines(file.path(tempd, xbasicos), locale = locale(encoding = "ISO-8859-1"))
  dfbasicos <- as_tibble(dfbasicos)

  dfcandidaturas <- read_lines(file.path(tempd, xcandidaturas), locale = locale(encoding = "ISO-8859-1"))
  dfcandidaturas <- as_tibble(dfcandidaturas)

  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

  lineas <- dfmesas$value

  dfmesas$tipo_eleccion <- substr(lineas, 1, 2)
  dfmesas$anno <- substr(lineas, 3, 6)
  dfmesas$mes <- substr(lineas, 7, 8)
  dfmesas$vuelta <- substr(lineas, 9, 9)
  dfmesas$codigo_ccaa <- substr(lineas, 10, 11)
  dfmesas$codigo_provincia <- substr(lineas, 12, 13)
  dfmesas$codigo_municipio <- substr(lineas, 14, 16)
  dfmesas$codigo_distrito <- substr(lineas, 17, 18)
  dfmesas$codigo_seccion <- substr(lineas, 19, 22)
  dfmesas$codigo_mesa <- substr(lineas, 23, 23)
  dfmesas$codigo_partido <- as.character(substr(lineas, 24, 29))
  dfmesas$votos <- as.numeric(substr(lineas, 30, 36))

  dfmesas <- dfmesas[, -1]

  ##### Datos basicos de mesa

  lineas <- dfbasicos$value

  dfbasicos$tipo_eleccion <- substr(lineas, 1, 2)
  dfbasicos$anno <- substr(lineas, 3, 6)
  dfbasicos$mes <- substr(lineas, 7, 8)
  dfbasicos$vuelta <- substr(lineas, 9, 9)
  dfbasicos$codigo_ccaa <- substr(lineas, 10, 11)
  dfbasicos$codigo_provincia <- substr(lineas, 12, 13)
  dfbasicos$codigo_municipio <- substr(lineas, 14, 16)
  dfbasicos$codigo_distrito <- substr(lineas, 17, 18)
  dfbasicos$codigo_seccion <- substr(lineas, 19, 22)
  dfbasicos$codigo_mesa <- substr(lineas, 23, 23)
  dfbasicos$censo_ine <- as.numeric(substr(lineas, 24, 30))
  dfbasicos$censo_cera <- as.numeric(substr(lineas, 31, 37))
  dfbasicos$censo_cere <- as.numeric(substr(lineas, 38, 44))
  dfbasicos$votantes_cere <- as.numeric(substr(lineas, 45, 51))
  dfbasicos$participacion_1 <- as.numeric(substr(lineas, 52, 58))
  dfbasicos$participacion_2 <- as.numeric(substr(lineas, 59, 65))
  dfbasicos$votos_blancos <- as.numeric(substr(lineas, 66, 72))
  dfbasicos$votos_nulos <- as.numeric(substr(lineas, 73, 79))
  dfbasicos$votos_candidaturas <- as.numeric(substr(lineas, 80, 86))
  dfbasicos$datos_oficiales <- substr(lineas, 101, 101)

  dfbasicos <- dfbasicos[,-1]


  #### Datos de candidaturas

  lineas <- dfcandidaturas$value

  dfcandidaturas$tipo_eleccion <- substr(lineas, 1, 2)
  dfcandidaturas$anno <- substr(lineas, 3, 6)
  dfcandidaturas$mes <- substr(lineas, 7, 8)
  dfcandidaturas$codigo_partido <- substr(lineas, 9, 14)
  dfcandidaturas$siglas <- substr(lineas, 15, 64)
  dfcandidaturas$denominacion <- substr(lineas, 65, 214)
  dfcandidaturas$codigo_partido_provincia <- substr(lineas, 215, 220)
  dfcandidaturas$codigo_partido_autonomia <- substr(lineas, 221, 226)
  dfcandidaturas$codigo_partido_nacional <- substr(lineas, 227, 232)

  dfcandidaturas <- dfcandidaturas[ , -1]

  df <- merge(dfbasicos, dfmesas, by = c("tipo_eleccion", "anno", "mes", "vuelta", "codigo_ccaa", "codigo_provincia", "codigo_municipio", "codigo_distrito", "codigo_seccion", "codigo_mesa"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all.x = T)

  # Quito los espacios en blanco a los lados de estas variables
  df$codigo_seccion <- str_trim(df$codigo_seccion)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Reordeno
  df <-
    df %>%
    relocate(
      .data$codigo_partido_autonomia,
      .data$codigo_partido_provincia,
      .data$codigo_partido,
      .data$denominacion,
      .data$siglas,
      .data$votos,
      .data$datos_oficiales ,
      .after = .data$codigo_partido_nacional
    )

  return(df)

}
