#' @title Reads the basic data files for the area superior to the municipality (provinces, islands, etc...)
#'
#' @param file Path to the .DAT file that begins with 07.
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read07 <- function(file, tempd) {
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
  df$codigo_distrito_electoral <- substr(lineas, 14, 14)
  df$ambito_territorial <- substr(lineas, 15, 64)
  df$poblacion_derecho <- as.numeric(substr(lineas, 65, 72))
  df$numero_mesas <- as.numeric(substr(lineas, 73, 77))
  df$censo_ine <- as.numeric(substr(lineas, 78, 85))
  df$censo_escrutinio <- as.numeric(substr(lineas, 86, 93))
  df$censo_cere <- as.numeric(substr(lineas, 94, 101))
  df$votantes_cere <- as.numeric(substr(lineas, 102, 109))
  df$participacion_1 <- as.numeric(substr(lineas, 110, 117))
  df$participacion_2 <- as.numeric(substr(lineas, 118, 125))
  df$votos_blancos <- as.numeric(substr(lineas, 126, 133))
  df$votos_nulos <- as.numeric(substr(lineas, 134, 141))
  df$votos_candidaturas <- as.numeric(substr(lineas, 142, 149))
  df$n_diputados <- as.numeric(substr(lineas, 150, 155))
  df$votos_afirmativos <- as.numeric(substr(lineas, 156, 163))
  df$votos_negativos <- as.numeric(substr(lineas, 164, 171))
  df$datos_oficiales <- substr(lineas, 172, 172)

  df <- df[,-1]

  return(df)

}
