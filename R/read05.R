#' @title Reads the basic municipal data files
#'
#' @param file Path to the .DAT file that begins with 05.
#'
#'  @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read05 <- function(file, tempd) {
  ### Leo los ficheros DAT necesarios
  con <- file(file.path(tempd, file), encoding = "ISO-8859-1")
  df <- data.frame( value = readLines(con) )
  close(con)

  ### Separo los valores según el diseño de registro
  lineas <- df$value

  df$tipo_eleccion <- substr(lineas, 1, 2)
  df$anno <- substr(lineas, 3, 6)
  df$mes <- substr(lineas, 7, 8)
  df$vuelta <- substr(lineas, 9, 9)
  df$codigo_ccaa <- substr(lineas, 10, 11)
  df$codigo_provincia <- substr(lineas, 12, 13)
  df$codigo_municipio <- substr(lineas, 14, 16)
  df$codigo_distrito <- substr(lineas, 17, 18)
  df$codigo_distrito_electoral <- substr(lineas, 119, 119)
  df$codigo_partido_judicial <- substr(lineas, 120, 122)
  df$codigo_diputacion <- substr(lineas, 123, 125)
  df$codigo_comarca <- substr(lineas, 126, 128)
  df$poblacion_derecho <- as.numeric(substr(lineas, 129, 136))
  df$numero_mesas <- as.numeric(substr(lineas, 137, 141))
  df$censo_ine <- as.numeric(substr(lineas, 142, 149))
  df$censo_escrutinio <- as.numeric(substr(lineas, 150, 157))
  df$censo_cere <- as.numeric(substr(lineas, 158, 165))
  df$votantes_cere <- as.numeric(substr(lineas, 166, 173))
  df$participacion_1 <- as.numeric(substr(lineas, 174, 181))
  df$participacion_2 <- as.numeric(substr(lineas, 182, 189))
  df$votos_blancos <- as.numeric(substr(lineas, 190, 197))
  df$votos_nulos <- as.numeric(substr(lineas, 198, 205))
  df$votos_candidaturas <- as.numeric(substr(lineas, 206, 213))
  df$numero_concejales <- as.numeric(substr(lineas, 214, 216))
  df$datos_oficiales <- substr(lineas, 233, 233)

  df <- df[,-1]

  return(df)

}
