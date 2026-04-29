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
#' @return Dataframe with the electoral results data at the municipality level,
#'   or \code{NULL} if the remote resource is unavailable.
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
  tipo <- election_type_code(tipo_eleccion)
  url <- generate_url(tipo, anno, mes, "MUNI")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = TRUE)
  filename <- gsub(".+/", "", url)
  temp <- file.path(tempd, filename)
  tempd <- file.path(tempd, gsub(".zip", "", filename))
  temp <- download_bin(url, temp)
  if (is.null(temp)) {
    return(NULL)
  }
  if (!safe_unzip_infoelectoral(temp, tempd)) {
    return(NULL)
  }

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno) - 1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = TRUE)
  x <- todos[grepl(paste0("06", tipo, codigo_eleccion, ".DAT"), todos)]
  xbasicos <- todos[grepl(paste0("05", tipo, codigo_eleccion, ".DAT"), todos)]
  xcandidaturas <- todos[grepl(paste0("03", tipo, codigo_eleccion, ".DAT"), todos)]

  ### Leo los ficheros DAT necesarios
  dfbasicos <- read05(xbasicos, tempd)
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfmunicipios <- read06(x, tempd)

  ### If municipal elections, need to read additional files for small municipalities
  if (tipo == "04") {
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

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfmunicipios,
    by = c(
      "tipo_eleccion", "vuelta", "anno", "mes",
      "codigo_provincia", "codigo_municipio",
      "codigo_distrito"
    )
  )
  df <- left_join(df, dfcandidaturas,
    by = c("tipo_eleccion", "anno", "mes", "codigo_partido")
  )

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- infoelectoral::codigos_municipios
  df <- left_join(df, codigos_municipios,
    by = c("codigo_provincia", "codigo_municipio")
  ) %>%
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
      .after = "vuelta"
    ) %>%
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
    df <- unique(df[df$codigo_distrito == 99, ])
  }

  cleanup(tempd)

  return(df)
}
