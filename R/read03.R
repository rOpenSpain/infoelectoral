#' @title Reads the candidacy files
#'
#' @param file Path to the .DAT file that begins with 03.
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read03 <- function(file, tempd) {
  ### Leo los ficheros DAT necesarios
  con <- file(file.path(tempd, file), encoding = "ISO-8859-1")
  df <- data.frame( value = readLines(con) )
  close(con)

  ### Separo los valores según el diseño de registro
  lineas <- df$value

  df$tipo_eleccion <- substr(lineas, 1, 2)
  df$anno <- substr(lineas, 3, 6)
  df$mes <- substr(lineas, 7, 8)
  df$codigo_partido <- substr(lineas, 9, 14)
  df$siglas <- substr(lineas, 15, 64)
  df$denominacion <- substr(lineas, 65, 214)
  df$codigo_partido_provincia <- substr(lineas, 215, 220)
  df$codigo_partido_autonomia <- substr(lineas, 221, 226)
  df$codigo_partido_nacional <- substr(lineas, 227, 232)

  df <- df[ , -1]

  return(df)

}
