#' @title Lee los ficheros de relación de candidatos
#'
#' @param file Ruta al fichero .DAT que comienza con 04 y que contienen la relación de candidatos
#'
#' @return data.frame
#'
#' @importFrom utils download.file
#' @importFrom utils unzip
#'
#' @keywords internal
#'
read04 <- function(file, tempd) {
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
  df$codigo_provincia <- substr(lineas, 10, 11)
  df$codigo_distrito_electoral <- substr(lineas, 12, 12)
  df$codigo_senador <- substr(lineas, 13, 15)
  df$codigo_partido <- substr(lineas, 16, 21)
  df$orden_candidato <- as.numeric( substr(lineas, 22, 24) )
  df$tipo_candidato <- substr(lineas, 25, 25)
  df$nombre <- substr(lineas, 26, 50)
  df$apellido_1 <- substr(lineas, 51, 75)
  df$apellido_2 <- substr(lineas, 76, 100)
  df$sexo <- substr(lineas, 101, 101)
  df$nacimiento_dia <- substr(lineas, 102, 103)
  df$nacimiento_mes <- substr(lineas, 104, 105)
  df$nacimiento_anno <- substr(lineas, 106, 109)
  df$nacimiento <- as.Date(df$nacimiento_anno, df$nacimiento_mes, df$nacimiento_dia)
  df$dni <- substr(lineas, 110, 119)
  df$electo <- substr(lineas, 120, 120)
  df$codigo_senador <- paste0(df$codigo_provincia, df$codigo_distrito_electoral, df$codigo_senador)

  df <- df[, -1]

  return(df)

}
