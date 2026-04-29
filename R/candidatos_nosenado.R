#' @title candidatos_nosenado
#'
#' @description `candidatos_nosenado()` downloads, formats and imports to the environment the data of the candidates from the electoral lists of the selected elections.
#' @param tipo Code for the type of election.
#' @param anno The year of the election in YYYY format.
#' @param mes The month of the election in MM format.
#'
#' @return data.frame with the data of candidates, or \code{NULL} if the remote
#'   resource is unavailable.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_if
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr %>%
#' @importFrom dplyr full_join
#' @importFrom dplyr left_join
#'
#' @keywords internal
#'
candidatos_nosenado <- function(tipo, anno, mes) {
  urlbase <- "https://infoelectoral.interior.gob.es/estaticos/docxl/apliextr/"
  url <- paste0(urlbase, tipo, anno, mes, "_MUNI", ".zip")
  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir(check = TRUE)
  filename <- gsub(".+/", "", url)
  temp <- file.path(tempd, filename)
  tempd <- file.path(tempd, gsub(".zip", "", filename))
  temp <- download_bin(url, temp)
  if (is.null(temp)) {
    return(NULL)
  }
  if (!safe_unzip_infoelectoral(temp, tempd)) {
    return(NULL)
  }

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno) - 1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = TRUE)
  x <- todos[grepl(paste0("04", tipo, codigo_eleccion, ".DAT"), todos)]
  xbasicos <- todos[grepl(paste0("05", tipo, codigo_eleccion, ".DAT"), todos)]
  xcandidaturas <- todos[grepl(paste0("03", tipo, codigo_eleccion, ".DAT"), todos)]

  ### Leo los ficheros DAT necesarios
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfcandidatos <- read04(x, tempd)
  dfcandidatos$codigo_distrito[dfcandidatos$codigo_distrito == "9"] <- "99"
  colnames(dfcandidatos)[colnames(dfcandidatos) == "codigo_senador"] <- "codigo_municipio"
  dfbasicos <- read05(xbasicos, tempd)
  dfbasicos <- dfbasicos[dfbasicos$codigo_distrito == "99", ]

  ### Junto los datos de los tres ficheros
  df <- full_join(dfbasicos, dfcandidatos,
    by = c(
      "tipo_eleccion", "vuelta", "anno", "mes",
      "codigo_provincia", "codigo_municipio", "codigo_distrito"
    )
  )
  df <- left_join(df, dfcandidaturas,
    by = c("tipo_eleccion", "anno", "mes", "codigo_partido")
  )

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)

  df <- df %>%
    mutate_if(is.character, str_trim) %>%
    mutate(denominacion = str_remove_all(denominacion, '"')) %>%
    select(
      "tipo_eleccion",
      "anno",
      "mes",
      "vuelta",
      "codigo_provincia",
      "codigo_municipio",
      "codigo_distrito",
      "orden_candidato",
      "tipo_candidato",
      "nombre",
      "apellido_1",
      "apellido_2",
      "sexo",
      "nacimiento",
      "dni",
      "electo",
      "codigo_partido_nacional",
      "codigo_partido_autonomia",
      "codigo_partido_provincia",
      "codigo_partido",
      "denominacion",
      "siglas"
    ) %>%
    arrange(codigo_provincia, siglas, orden_candidato)

  df <- df[!is.na(df$orden_candidato), ]

  df$nacimiento <- NA
  df$dni <- NA

  cleanup(tempd)

  return(df)
}
