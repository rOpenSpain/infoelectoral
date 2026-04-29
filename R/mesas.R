#' @title Download data at the polling station level
#'
#' @description `mesas()` downloads, formats and imports to the environment the electoral results data of the selected election at the polling station level.
#'
#' @param tipo_eleccion The type of choice you want to download. The accepted values are "congreso", "senado", "europeas" o "municipales".
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @example R/examples/mesas.R
#'
#' @return data.frame with the electoral results data at the polling station
#'   level, or \code{NULL} if the remote resource is unavailable.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr relocate
#' @importFrom dplyr desc
#' @importFrom dplyr full_join
#' @importFrom dplyr left_join
#' @importFrom dplyr %>%
#'
#' @export
mesas <- function(tipo_eleccion, anno, mes) {
  ### Construyo la url al zip de la elecciones
  tipo <- election_type_code(tipo_eleccion)
  url <- generate_url(tipo, anno, mes, "MESA")

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
  x <- todos[grepl(paste0("10", tipo, codigo_eleccion, ".DAT"), todos)]
  xbasicos <- todos[grepl(paste0("09", tipo, codigo_eleccion, ".DAT"), todos)]
  xcandidaturas <- todos[grepl(paste0("03", tipo, codigo_eleccion, ".DAT"), todos)]

  ### Leo los ficheros .DAT
  dfbasicos <- read09(xbasicos, tempd)
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfmesas <- read10(x, tempd)

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfmesas,
    by = c(
      "tipo_eleccion", "anno", "mes", "vuelta",
      "codigo_ccaa", "codigo_provincia", "codigo_municipio", "codigo_distrito",
      "codigo_seccion", "codigo_mesa"
    )
  )
  df <- left_join(df, dfcandidaturas,
    by = c("tipo_eleccion", "anno", "mes", "codigo_partido")
  )

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$codigo_seccion <- str_trim(df$codigo_seccion)
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
      "codigo_seccion",
      "codigo_mesa",
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
      .after = "codigo_partido_nacional"
    ) %>%
    arrange(
      codigo_ccaa,
      codigo_provincia,
      codigo_municipio,
      codigo_distrito,
      codigo_seccion,
      codigo_mesa,
      desc(votos)
    )

  df$municipio[df$codigo_municipio == "999"] <- "CERA"

  cleanup(tempd)

  return(df)
}
