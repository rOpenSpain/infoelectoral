#' @title Download data at the polling station level
#'
#' @description `mesas()` downloads, formats and imports to the environment the electoral results data of the selected election at the polling station level.
#'
#' @param tipo_eleccion The type of choice you want to download. The accepted values are "congreso", "senado", "europeas" o "municipales".
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @return data.frame with the electoral results data at the polling station level.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr relocate
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#'
#' @export
mesas <- function(tipo_eleccion, anno, mes) {

  ### Construyo la url al zip de la elecciones
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
  } else if (tipo_eleccion == "congreso") {
    tipo <- "02"
  } else if (tipo_eleccion == "europeas") {
    tipo <- "07"
  } else if (tipo_eleccion == "cabildos") {
    tipo <- "06"
  } else {
    stop('The argument tipo_eleccion must take one of the following values: "congreso", "municipales", "europeas"')
  }
  urlbase <- "https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/"
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

  ### Leo los ficheros .DAT
  dfbasicos <- read09(xbasicos, tempd)
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfmesas <- read10(x, tempd)

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)


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
  df <- merge(df, codigos_municipios, by = c("codigo_provincia", "codigo_municipio"), all.x = T) %>%
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
