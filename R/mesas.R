#' @title mesas
#'
#'
#' @description Esta función descarga los datos de voto a candidaturas a nivel de mesas de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipo_eleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param anno El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#'
#' @return Dataframe con los datos de voto a candidaturas por mesas.
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr relocate
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#'
#' @export
mesas <- function(tipo_eleccion, anno, mes) {

  ### Construyo la url al zip de la elecciones...
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
  } else if (tipo_eleccion == "generales") {
    tipo <- "02"
  }
  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipo, anno, mes, "_MESA", ".zip")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = F)
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno)-1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = T)
  x <- todos[todos == paste0("10", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("09", tipo, codigo_eleccion, ".DAT")]
  xcandidaturas <- todos[todos == paste0("03", tipo, codigo_eleccion, ".DAT")]

  ### Leo los ficheros DAT necesarios
  con <- file(file.path(tempd, x), encoding = "ISO-8859-1")
  dfmesas <- data.frame( value = readLines(con) )
  close(con)

  con <- file(file.path(tempd, xbasicos), encoding = "ISO-8859-1")
  dfbasicos <- data.frame( value = readLines(con) )
  close(con)

  con <- file(file.path(tempd, xcandidaturas), encoding = "ISO-8859-1")
  dfcandidaturas <- data.frame( value = readLines(con) )
  close(con)

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)


  ### Separo los valores según el diseño de registro

  ##### Datos de mesa
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

  ### Junto los datos de los tres ficheros
  df <- merge(dfbasicos, dfmesas, by = c("tipo_eleccion", "anno", "mes", "vuelta", "codigo_ccaa", "codigo_provincia", "codigo_municipio", "codigo_distrito", "codigo_seccion", "codigo_mesa"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all.x = T)

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$codigo_seccion <- str_trim(df$codigo_seccion)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- NULL
  data("codigos_municipios", envir = environment())
  df <- merge(df, codigos_municipios, by = c("codigo_provincia", "codigo_municipio"), all = T) %>%
    relocate(
      .data$codigo_ccaa,
      .data$codigo_provincia,
      .data$codigo_municipio,
      .data$municipio,
      .data$codigo_distrito,
      .data$codigo_seccion,
      .data$codigo_mesa,
      .after = .data$vuelta) %>%
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

  df$municipio[df$codigo_municipio == "999"] <- "CERA"

  return(df)
}
