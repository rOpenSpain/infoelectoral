#' @title Reads the basic polling station data files
#'
#' @param file Path to the .DAT file that begins with 09.
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read09 <- function(file, tempd) {
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
  df$codigo_seccion <- substr(lineas, 19, 22)
  df$codigo_mesa <- substr(lineas, 23, 23)
  df$censo_ine <- as.numeric(substr(lineas, 24, 30))
  df$censo_cera <- as.numeric(substr(lineas, 31, 37))
  df$censo_cere <- as.numeric(substr(lineas, 38, 44))
  df$votantes_cere <- as.numeric(substr(lineas, 45, 51))
  df$participacion_1 <- as.numeric(substr(lineas, 52, 58))
  df$participacion_2 <- as.numeric(substr(lineas, 59, 65))
  df$votos_blancos <- as.numeric(substr(lineas, 66, 72))
  df$votos_nulos <- as.numeric(substr(lineas, 73, 79))
  df$votos_candidaturas <- as.numeric(substr(lineas, 80, 86))
  df$datos_oficiales <- substr(lineas, 101, 101)

  df <- df[,-1]

  return(df)

}
