#' @title candidatos
#'
#'
#' @description Esta función descarga los datos de los candidatos de las listas electorales de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipo_eleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
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
#' @export
#'
candidatos <- function(tipo_eleccion, anno, mes) {

  ### Construyo la url al zip de la elecciones
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
  } else if (tipo_eleccion == "congreso") {
    tipo <- "02"
  } else if (tipo_eleccion == "europeas") {
    tipo <- "07"
  } else if (tipo_eleccion == "cabildos") {
    tipo <- "06"
  } else if (tipo_eleccion == "senado") {
    tipo <- "03"
  } else {
    stop('El argumento tipo_eleccion debe adoptar uno de los siguientes valores: "congreso", "senado", "municipales", "europeas"')
  }
  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipo, anno, mes, "_MUNI", ".zip")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = F)
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno)-1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = T)
  x <- todos[todos == paste0("04", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("05", tipo, codigo_eleccion, ".DAT")]
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
  dfcandidatos$codigo_distrito <- substr(lineas, 12, 12)
  dfcandidatos$codigo_municipio <- substr(lineas, 13, 15)
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

  dfcandidatos <- dfcandidatos[, -1]

  dfcandidatos$codigo_distrito[dfcandidatos$codigo_distrito == "9"] <- "99"

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
  dfbasicos$municipio <- substr(lineas, 19, 118)
  dfbasicos$codigo_distrito_electoral <- substr(lineas, 119, 119)
  dfbasicos$codigo_partido_judicial <- substr(lineas, 120, 122)
  dfbasicos$codigo_diputacion <- substr(lineas, 123, 125)
  dfbasicos$codigo_comarca <- substr(lineas, 126, 128)
  dfbasicos$poblacion_derecho <- as.numeric(substr(lineas, 129, 136))
  dfbasicos$numero_mesas <- as.numeric(substr(lineas, 137, 141))
  dfbasicos$censo_ine <- as.numeric(substr(lineas, 142, 149))
  dfbasicos$censo_escrutinio <- as.numeric(substr(lineas, 150, 157))
  dfbasicos$censo_cere <- as.numeric(substr(lineas, 158, 165))
  dfbasicos$votantes_cere <- as.numeric(substr(lineas, 166, 173))
  dfbasicos$participacion_1 <- as.numeric(substr(lineas, 174, 181))
  dfbasicos$participacion_2 <- as.numeric(substr(lineas, 182, 189))
  dfbasicos$votos_blancos <- as.numeric(substr(lineas, 190, 197))
  dfbasicos$votos_nulos <- as.numeric(substr(lineas, 198, 205))
  dfbasicos$votos_candidaturas <- as.numeric(substr(lineas, 206, 213))
  dfbasicos$numero_concejales <- as.numeric(substr(lineas, 214, 216))
  dfbasicos$datos_oficiales <- substr(lineas, 233, 233)

  dfbasicos <- dfbasicos[,-1]
  dfbasicos <- dfbasicos[dfbasicos$codigo_distrito == "99",]

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
  df <- merge(dfbasicos, dfcandidatos, by = c("tipo_eleccion", "vuelta", "anno", "mes", "codigo_provincia", "codigo_municipio", "codigo_distrito"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all.x = T)

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$municipio <- str_trim(df$municipio)
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  df <- df %>%
    mutate_if(is.character, str_trim) %>%
    mutate(denominacion = str_remove_all(.data$denominacion, '"')) %>%
    select(
      .data$tipo_eleccion,
      .data$anno,
      .data$mes,
      .data$vuelta,
      .data$codigo_provincia,
      .data$codigo_municipio,
      .data$codigo_distrito,
      .data$orden_candidato,
      .data$tipo_candidato,
      .data$nombre,
      .data$apellido_1,
      .data$apellido_2,
      .data$sexo,
      .data$nacimiento,
      .data$dni ,
      .data$electo,
      .data$codigo_partido_nacional,
      .data$codigo_partido_autonomia,
      .data$codigo_partido_provincia,
      .data$codigo_partido,
      .data$denominacion,
      .data$siglas
    )%>%
    arrange(.data$codigo_provincia, .data$siglas, .data$orden_candidato)

  df$nacimiento <- NA
  df$dni <- NA

  return(df)
}
