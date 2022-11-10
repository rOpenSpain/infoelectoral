#' @title Reads the basic data files for municipalities of 250 inhabitants or less
#'
#' @param file Path to the .DAT file that begins with 11.
#'
#'  @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read11 <- function(file, tempd) {
  ### Leo los ficheros DAT necesarios
  con <- file(file.path(tempd, file), encoding = "ISO-8859-1")
  df <- data.frame( value = readLines(con) )
  close(con)

  ### Separo los valores según el diseño de registro
  lineas <- df$value

  df$tipo_eleccion <- "04"
  df$anno <- substr(lineas, 3, 6)
  df$mes <- substr(lineas, 7, 8)
  df$vuelta <- substr(lineas, 9, 9)
  df$codigo_ccaa <- substr(lineas, 10, 11)
  df$codigo_provincia <- substr(lineas, 12, 13)
  df$codigo_municipio <- substr(lineas, 14, 16)
  df$codigo_distrito <- "99"
  # df$codigo_distrito_electoral <- NA
  df$codigo_partido_judicial <- substr(lineas, 117, 119)
  df$codigo_diputacion <- substr(lineas, 120, 122)
  df$codigo_comarca <- substr(lineas, 123, 125)
  df$poblacion_derecho <- as.numeric(substr(lineas, 126, 128))
  df$numero_mesas <- as.numeric(substr(lineas, 129, 130))
  df$censo_ine <- as.numeric(substr(lineas, 131, 133))
  df$censo_escrutinio <- as.numeric(substr(lineas, 134, 136))
  df$censo_cere <- as.numeric(substr(lineas, 137, 139))
  df$votantes_cere <- as.numeric(substr(lineas, 140, 142))
  df$participacion_1 <- as.numeric(substr(lineas, 143, 145))
  df$participacion_2 <- as.numeric(substr(lineas, 146, 148))
  df$votos_blancos <- as.numeric(substr(lineas, 149, 151))
  df$votos_nulos <- as.numeric(substr(lineas, 152, 154))
  df$votos_candidaturas <- as.numeric(substr(lineas, 155, 157))
  df$numero_concejales <- as.numeric(substr(lineas, 158, 159))
  df$datos_oficiales <- substr(lineas, 160, 160)

  df <- df[,-1]

  return(df)

}
