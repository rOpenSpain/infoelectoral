#' @title Reads the candidacy files at the area superior to the municipality (provinces, islands, etc...)
#'
#' @param file Path to the .DAT file that begins with 08.
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read08 <- function(file, tempd) {
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
  df$codigo_partido <- substr(lineas, 15, 20)
  df$votos <- as.numeric(substr(lineas, 21, 28))
  df$diputados <- as.numeric(substr(lineas, 29, 33))

  df <- df[ , -1]

  return(df)

}
