#' @title Reads the candidacy info at polling station level files
#'
#' @param file Path to the .DAT file that begins with 10.
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read10 <- function(file, tempd) {
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
  df$codigo_partido <- as.character(substr(lineas, 24, 29))
  df$votos <- as.numeric(substr(lineas, 30, 36))

  df <- df[, -1]

  return(df)

}
