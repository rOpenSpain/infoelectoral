#' @title Reads the candidacy files for small municipalities
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
read12 <- function(file, tempd) {
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
  df$codigo_provincia <- substr(lineas, 10, 11)
  df$codigo_municipio <- substr(lineas, 12, 14)
  df$codigo_distrito <- "99"
  df$codigo_partido <- as.character(substr(lineas, 15, 20))
  df$votos <- as.numeric(substr(lineas, 21, 23))
  df$concejales_obtenidos <- as.numeric(substr(lineas, 24, 25))

  df <- df[ , -1]
  df <- unique(df) # individual candidates

  # Check if different candidaturas got different votes
  if(nrow(df) != nrow(unique(df[,
    c("codigo_provincia", "codigo_municipio", "codigo_partido")]))){
      stop("In small municipalities: different candidates from same party got different votes (?)")
  }

  return(df)

}
