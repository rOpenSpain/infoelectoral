#' @title candidatos_nosenado
#'
#' @description `candidatos_nosenado()` downloads, formats and imports to the environment the data of the candidates from the electoral lists of the selected elections.
#' @param tipo Code for the type of election.
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @return data.frame with the data of candidates.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#'
#' @keywords internal
#'
candidatos_nosenado <- function(tipo, anno, mes) {

  urlbase <- "https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/"
  url <- paste0(urlbase, tipo, anno, mes, "_MUNI", ".zip")
  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = F)
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno)-1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = T)
  x <- todos[grepl(paste0("04", tipo, codigo_eleccion, ".DAT"), todos)]
  xbasicos <- todos[grepl(paste0("05", tipo, codigo_eleccion, ".DAT"), todos)]
  xcandidaturas <- todos[grepl(paste0("03", tipo, codigo_eleccion, ".DAT"), todos)]


  ### Leo los ficheros DAT necesarios
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfcandidatos <- read04(x, tempd)
  dfcandidatos$codigo_distrito[dfcandidatos$codigo_distrito == "9"] <- "99"
  colnames(dfcandidatos)[colnames(dfcandidatos) == "codigo_senador"] <- "codigo_municipio"
  dfbasicos <- read05(xbasicos, tempd)
  dfbasicos <- dfbasicos[dfbasicos$codigo_distrito == "99",]

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

  ### Junto los datos de los tres ficheros
  df <- merge(dfbasicos, dfcandidatos, by = c("tipo_eleccion", "vuelta", "anno", "mes", "codigo_provincia", "codigo_municipio", "codigo_distrito"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all.x = T)

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
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
