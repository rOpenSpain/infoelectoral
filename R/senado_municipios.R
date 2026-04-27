#' @title senado_municipios
#'
#' @description `senado_mesas` downloads the Senate candidates data at the municipality level.
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
senado_municipios <- function(anno, mes) {
  ### Construyo la url al zip de la elecciones
  tipo <- "03"
  url <- generate_url(tipo, anno, mes, "MUNI")

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
  xmunicipios <- todos[todos == paste0("06", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("05", tipo, codigo_eleccion, ".DAT")]
  xcandidaturas <- todos[todos == paste0("03", tipo, codigo_eleccion, ".DAT")]


  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfcandidatos <- read04(x, tempd)
  dfcandidatos$codigo_distrito_electoral[dfcandidatos$codigo_distrito_electoral == "9"] <- "0"
  dfbasicos <- read05(xbasicos, tempd)
  dfbasicos <- dfbasicos[dfbasicos$codigo_distrito == "99", ]
  dfmunicipios <- read06(xmunicipios, tempd)
  colnames(dfmunicipios)[colnames(dfmunicipios) == "codigo_partido"] <- "codigo_senador"

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfmunicipios,
    by = c(
      "tipo_eleccion", "anno", "mes", "vuelta", "codigo_provincia",
      "codigo_municipio", "codigo_distrito"
    )
  )
  df <- full_join(df, dfcandidatos,
    by = c(
      "tipo_eleccion", "anno", "mes", "vuelta", "codigo_provincia",
      "codigo_distrito_electoral", "codigo_senador"
    ),
    relationship = "many-to-many",
  )
  df <- full_join(df, dfcandidaturas,
    by = c("tipo_eleccion", "anno", "mes", "codigo_partido")
  )

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  codigos_municipios <- infoelectoral::codigos_municipios
  df <- full_join(df, codigos_municipios,
    by = c("codigo_provincia", "codigo_municipio")
  ) %>%
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
      "numero_mesas",
      "poblacion_derecho",
      "censo_ine",
      "censo_escrutinio",
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
      codigo_provincia,
      siglas,
      orden_candidato
    )

  df$nacimiento[df$nacimiento_anno == "0000"] <- NA

  cleanup(tempd)

  return(df)
}
