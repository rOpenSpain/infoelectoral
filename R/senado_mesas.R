#' @title senado_mesas
#'
#'
#' @description Esta función descarga los datos de los candidatos al Senado a nivel de mesa.
#'
#' @param anno El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
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
#'
senado_mesas <- function(anno, mes) {

  ### Construyo la url al zip de la elecciones
  tipo <- "03"
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
  x <- todos[todos == paste0("04", tipo, codigo_eleccion, ".DAT")]
  xmesas <- todos[todos == paste0("10", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("09", tipo, codigo_eleccion, ".DAT")]
  xcandidaturas <- todos[todos == paste0("03", tipo, codigo_eleccion, ".DAT")]

  ### Leo los ficheros DAT necesarios
  con <- file(file.path(tempd, x), encoding = "ISO-8859-1")
  dfcandidatos <- data.frame( value = readLines(con) )
  close(con)

  con <- file(file.path(tempd, xbasicos), encoding = "ISO-8859-1")
  dfbasicos <- data.frame( value = readLines(con) )
  close(con)

  con <- file(file.path(tempd, xcandidaturas), encoding = "ISO-8859-1")
  dfcandidaturas <- data.frame( value = readLines(con) )
  close(con)

  con <- file(file.path(tempd, xmesas), encoding = "ISO-8859-1")
  dfmesas <- data.frame( value = readLines(con) )
  close(con)

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

  ### Separo los valores según el diseño de registro
  ##### Datos de candidatos
  lineas <- dfcandidatos$value

  dfcandidatos$tipo_eleccion <- substr(lineas, 1, 2)
  dfcandidatos$anno <- substr(lineas, 3, 6)
  dfcandidatos$mes <- substr(lineas, 7, 8)
  dfcandidatos$vuelta <- substr(lineas, 9, 9)
  dfcandidatos$codigo_provincia <- substr(lineas, 10, 11)
  dfcandidatos$codigo_distrito_electoral <- substr(lineas, 12, 12)
  dfcandidatos$codigo_senador <- substr(lineas, 13, 15)
  dfcandidatos$codigo_partido <- substr(lineas, 16, 21)
  dfcandidatos$orden_candidato <- as.numeric( substr(lineas, 22, 24) )
  dfcandidatos$tipo_candidato <- substr(lineas, 25, 25)
  dfcandidatos$nombre <- substr(lineas, 26, 50)
  dfcandidatos$apellido_1 <- substr(lineas, 51, 75)
  dfcandidatos$apellido_2 <- substr(lineas, 76, 100)
  dfcandidatos$sexo <- substr(lineas, 101, 101)
  dfcandidatos$nacimiento_dia <- substr(lineas, 102, 103)
  dfcandidatos$nacimiento_mes <- substr(lineas, 104, 105)
  dfcandidatos$nacimiento_anno <- substr(lineas, 106, 109)
  dfcandidatos$nacimiento <- as.Date(dfcandidatos$nacimiento_anno, dfcandidatos$nacimiento_mes, dfcandidatos$nacimiento_dia)
  dfcandidatos$dni <- substr(lineas, 110, 119)
  dfcandidatos$electo <- substr(lineas, 120, 120)
  dfcandidatos$codigo_senador <- paste0(dfcandidatos$codigo_provincia, dfcandidatos$codigo_distrito_electoral, dfcandidatos$codigo_senador)

  dfcandidatos <- dfcandidatos[, -1]

  #### Datos de candidaturas en mesa
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
  dfmesas$codigo_senador <- as.character(substr(lineas, 24, 29))
  dfmesas$votos <- as.numeric(substr(lineas, 30, 36))

  dfmesas <- dfmesas[, -1]

  ##### Datos basicos de municipio
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
  df <- merge(df, dfcandidatos, by = c("tipo_eleccion", "anno", "mes", "vuelta", "codigo_provincia", "codigo_senador"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all = T)

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- NULL
  data("codigos_municipios", envir = environment())
  df <- merge(df, codigos_municipios, by = c("codigo_provincia", "codigo_municipio"), all = T)

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  df2 <- df %>%
    mutate_if(is.character, str_trim) %>%
    mutate(denominacion = str_remove_all(.data$denominacion, '"')) %>%
    select(
      .data$tipo_eleccion,
      .data$anno,
      .data$mes,
      .data$vuelta,
      .data$codigo_ccaa,
      .data$codigo_provincia,
      .data$codigo_distrito_electoral,
      .data$codigo_municipio,
      .data$municipio,
      .data$codigo_distrito,
      .data$codigo_seccion,
      .data$codigo_mesa,
      .data$censo_ine,
      .data$censo_cera,
      .data$censo_cere,
      .data$votantes_cere,
      .data$participacion_1,
      .data$participacion_2,
      .data$votos_blancos,
      .data$votos_nulos,
      .data$votos_candidaturas,
      .data$codigo_partido_nacional,
      .data$codigo_partido_autonomia,
      .data$codigo_partido_provincia,
      .data$codigo_partido,
      .data$denominacion,
      .data$siglas,
      .data$codigo_senador,
      .data$orden_candidato,
      .data$tipo_candidato,
      .data$nombre,
      .data$apellido_1,
      .data$apellido_2,
      .data$sexo,
      .data$nacimiento,
      .data$dni ,
      .data$votos,
      .data$electo,
      .data$datos_oficiales
    )%>%
    arrange(.data$codigo_provincia, .data$codigo_municipio,
            .data$codigo_distrito,
            .data$codigo_seccion,
            .data$codigo_mesa,
            .data$siglas,
            .data$orden_candidato)

  df$nacimiento[df$nacimiento_anno == "0000"] <- NA

  return(df)
}
