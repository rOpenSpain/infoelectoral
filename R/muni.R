#' @title Download data at the municipality level
#'
#' @description `municipios()` downloads, formats and imports to the environment the electoral results data of the selected election at the municipality level.
#'
#' @param tipo_eleccion The type of choice you want to download. The accepted values are "congreso", "senado", "europeas" o "municipales".
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#' @param distritos Should district level results be returned when available? The default is FALSE. Please be aware when summarizing the data that districts = TRUE will return separate rows for the total municipal level and for each of the districts.
#'
#' @example R/examples/municipios.R
#'
#' @return Dataframe with the electoral results data at the municipality level.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr relocate
#' @importFrom dplyr %>%
#' @importFrom dplyr bind_rows
#' @importFrom dplyr full_join
#' @importFrom dplyr left_join
#' @export
#'
municipios <- function(tipo_eleccion, anno, mes, distritos = FALSE) {

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
  url <- paste0(urlbase, tipo, anno, mes, "_MUNI", ".zip")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir()
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")

  unzip(temp, overwrite = T, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno)-1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = T)
  x <- todos[grepl(paste0("06", tipo, codigo_eleccion, ".DAT"), todos)]
  xbasicos <- todos[grepl(paste0("05", tipo, codigo_eleccion, ".DAT"), todos)]
  xcandidaturas <- todos[grepl(paste0("03", tipo, codigo_eleccion, ".DAT"), todos)]

  ### Leo los ficheros DAT necesarios
  dfbasicos <- read05(xbasicos, tempd)
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfmunicipios <- read06(x, tempd)

  ### If municipal elections, need to read additional files for small municipalities
  if(tipo == "04"){
    # Files for small municipalities
    xbasicos_small <- todos[grepl(paste0("11", tipo, codigo_eleccion, ".DAT"), todos)]
    xmunicipios_small <- todos[grepl(paste0("12", tipo, codigo_eleccion, ".DAT"), todos)]
    # Read those files
    dfbasicos_small <- read11(xbasicos_small, tempd)
    dfmunicipios_small <- read12(xmunicipios_small, tempd)
    # Bind rows with larger df
    dfbasicos_big <- dfbasicos
    dfmunicipios_big <- dfmunicipios
    dfbasicos <- bind_rows(dfbasicos, dfbasicos_small)
    dfmunicipios <- bind_rows(dfmunicipios, dfmunicipios_small)
  }

  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfmunicipios,
              by = c("tipo_eleccion", "vuelta", "anno", "mes",
                     "codigo_provincia", "codigo_municipio",
                     "codigo_distrito"))
  df <- left_join(df, dfcandidaturas,
              by = c("tipo_eleccion", "anno", "mes", "codigo_partido"))

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- infoelectoral::codigos_municipios
  df <- left_join(df, codigos_municipios,
                  by = c("codigo_provincia", "codigo_municipio")) %>%
    relocate(
      "codigo_ccaa",
      "codigo_provincia",
      "codigo_municipio",
      "municipio",
      "codigo_distrito",
      "codigo_distrito_electoral",
      "codigo_partido_judicial",
      "codigo_diputacion",
      "codigo_comarca",
      .after = "vuelta") %>%
    relocate(
      "codigo_partido_autonomia",
      "codigo_partido_provincia",
      "codigo_partido",
      "denominacion",
      "siglas",
      "votos",
      "datos_oficiales",
      "concejales_obtenidos",
      .after = "codigo_partido_nacional"
    )

  ### Si no se quieren los distritos se eliminan de los datos
  if (distritos == FALSE) {
    df <- unique(df[df$codigo_distrito == 99,])
  }

  return(df)
}
