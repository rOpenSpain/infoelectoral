#' @title senado_mesas
#'
#' @description `senado_mesas` downloads the Senate candidates data at the polling station level.
#'
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @return data.frame with the data for the Senate candidates.
#'
#' @importFrom utils unzip
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#' @importFrom dplyr full_join
#'
#' @keywords internal
senado_mesas <- function(anno, mes) {
  ### Construyo la url al zip de la elecciones
  tipo <- "03"
  url <- generate_url(tipo, anno, mes, "MESA")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = TRUE)
  filename <- gsub(".+/", "", url)
  temp <- file.path(tempd, filename)
  tempd <- file.path(tempd, gsub(".zip", "", filename))
  download_bin(url, temp)
  unzip(temp, overwrite = TRUE, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno) - 1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = TRUE)
  x <- todos[todos == paste0("04", tipo, codigo_eleccion, ".DAT")]
  xmesas <- todos[todos == paste0("10", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("09", tipo, codigo_eleccion, ".DAT")]
  xcandidaturas <- todos[todos == paste0("03", tipo, codigo_eleccion, ".DAT")]

  ### Leo los ficheros DAT necesarios
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfcandidatos <- read04(x, tempd)
  dfbasicos <- read09(xbasicos, tempd)
  dfmesas <- read10(xmesas, tempd)

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfmesas,
    by = c(
      "tipo_eleccion", "anno", "mes", "vuelta", "codigo_ccaa",
      "codigo_provincia", "codigo_municipio", "codigo_distrito",
      "codigo_seccion", "codigo_mesa"
    )
  )
  df <- full_join(df, dfcandidatos,
    by = c(
      "tipo_eleccion", "anno", "mes", "vuelta",
      "codigo_provincia", "codigo_senador"
    )
  )
  df <- full_join(df, dfcandidaturas,
    by = c("tipo_eleccion", "anno", "mes", "codigo_partido")
  )

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- infoelectoral::codigos_municipios
  df <- full_join(df, codigos_municipios,
    by = c("codigo_provincia", "codigo_municipio")
  )

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  df2 <- df %>%
    mutate_if(is.character, str_trim) %>%
    mutate(denominacion = str_remove_all(denominacion, '"')) %>%
    select(
      "tipo_eleccion",
      "anno",
      "mes",
      "vuelta",
      "codigo_ccaa",
      "codigo_provincia",
      "codigo_distrito_electoral",
      "codigo_municipio",
      "municipio",
      "codigo_distrito",
      "codigo_seccion",
      "codigo_mesa",
      "censo_ine",
      "censo_cera",
      "censo_cere",
      "votantes_cere",
      "participacion_1",
      "participacion_2",
      "votos_blancos",
      "votos_nulos",
      "votos_candidaturas",
      "codigo_partido_nacional",
      "codigo_partido_autonomia",
      "codigo_partido_provincia",
      "codigo_partido",
      "denominacion",
      "siglas",
      "codigo_senador",
      "orden_candidato",
      "tipo_candidato",
      "nombre",
      "apellido_1",
      "apellido_2",
      "sexo",
      "nacimiento",
      "dni",
      "votos",
      "electo",
      "datos_oficiales"
    ) %>%
    arrange(
      codigo_provincia, codigo_municipio,
      codigo_distrito,
      codigo_seccion,
      codigo_mesa,
      siglas,
      orden_candidato
    )

  df$nacimiento[df$nacimiento_anno == "0000"] <- NA

  cleanup(tempd)

  return(df)
}
