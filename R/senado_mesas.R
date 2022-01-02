#' @title senado_mesas
#'
#' @description `senado_mesas` downloads the Senate candidates data at the polling station level.
#'
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @return data.frame with the data for the Senate candidates.
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
#' @keywords internal
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
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfcandidatos <- read04(x, tempd)
  dfbasicos <- read09(xbasicos, tempd)
  dfmesas <- read10(xmesas, tempd)

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

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
