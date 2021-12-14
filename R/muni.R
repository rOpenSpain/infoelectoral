#' @title Descarga datos a nivel de municipio
#'
#' @description Esta función descarga los datos de voto a candidaturas a nivel de municipio de las elecciones seleccionadas, los formatea, y los importa al espacio de trabajo.
#'
#' @param tipo_eleccion El tipo de eleccion que se quiere descargar. Los valores aceptados por ahora son "municipales" o "generales".
#' @param anno El año de la elección en formato YYYY. Se puede introducir como número o como texto (2015 o "2015").
#' @param mes El mes de la elección en formato mm. Se DEBE introducir como texto (p.e. "05" para el mes de mayo).
#' @param distritos TRUE o FALSE, segun se quieran los resultados de los distritos de los municipios que tienen división distrital. FALSE por defecto.
#'
#' @return Dataframe con los datos de voto a candidaturas por mesas.
#'
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom dplyr relocate
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @importFrom utils data
#' @export
#'
municipios <- function(tipo_eleccion, anno, mes, distritos = FALSE) {

  ### Construyo la url al zip de la elecciones
  if (tipo_eleccion == "municipales") {
    tipo <- "04"
  } else if (tipo_eleccion == "congreso") {
    tipo <- "02"
  } else if (tipo_eleccion == "europeas") {
    tipo <- "07"
  } else if (tipo_eleccion == "cabildos") {
    tipo <- "06"
  } else if (tipo_eleccion == "senado") {
    tipo <- "03"
  } else {
    stop('El argumento tipo_eleccion debe adoptar uno de los siguientes valores: "congreso", "senado", "municipales", "europeas"')
  }

  urlbase <- "http://www.infoelectoral.mir.es/infoelectoral/docxl/apliextr/"
  url <- paste0(urlbase, tipo, anno, mes, "_MUNI", ".zip")

  ### Descargo el fichero zip en un directorio temporal y lo descomprimo
  tempd <- tempdir()
  temp <- tempfile(tmpdir = tempd, fileext = ".zip")
  download.file(url, temp, mode = "wb")
  unzip(temp, overwrite = T, exdir = tempd)

  ### Construyo las rutas a los ficheros DAT necesarios
  codigo_eleccion <- paste0(substr(anno, nchar(anno)-1, nchar(anno)), mes)
  todos <- list.files(tempd, recursive = T)
  x <- todos[todos == paste0("06", tipo, codigo_eleccion, ".DAT")]
  xbasicos <- todos[todos == paste0("05", tipo, codigo_eleccion, ".DAT")]
  xcandidaturas <- todos[todos == paste0("03", tipo, codigo_eleccion, ".DAT")]

  ### Leo los ficheros DAT necesarios
  dfcandidaturas <- read03(xcandidaturas, tempd)
  dfbasicos <- read05(xbasicos, tempd)
  dfmunicipios <- read06(x, tempd)


  ### Limpio el directorio temporal (IMPORTANTE: Si no lo hace, puede haber problemas al descargar más de una elección)
  borrar <-  list.files(tempd, full.names = T, recursive = T)
  try(file.remove(borrar), silent = T)

  ### Junto los datos de los tres ficheros
  df <- merge(dfbasicos, dfmunicipios, by = c("tipo_eleccion", "vuelta", "anno", "mes", "codigo_provincia", "codigo_municipio", "codigo_distrito"), all = T)
  df <- merge(df, dfcandidaturas, by = c("tipo_eleccion", "anno", "mes", "codigo_partido"), all.x = T)

  ### Limpieza: Quito los espacios en blanco a los lados de estas variables
  df$siglas <- str_trim(df$siglas)
  df$denominacion <- str_trim(df$denominacion)
  df$denominacion <- str_remove_all(df$denominacion, '"')

  # Inserto el nombre del municipio más reciente y reordeno algunas variables
  codigos_municipios <- NULL
  data("codigos_municipios", envir = environment())
  df <- merge(df, codigos_municipios, by = c("codigo_provincia", "codigo_municipio"), all = T) %>%
    relocate(
      .data$codigo_ccaa,
      .data$codigo_provincia,
      .data$codigo_municipio,
      .data$municipio,
      .data$codigo_distrito,
      .data$codigo_distrito_electoral,
      .data$codigo_partido_judicial,
      .data$codigo_diputacion,
      .data$codigo_comarca,
      .after = .data$vuelta) %>%
    relocate(
      .data$codigo_partido_autonomia,
      .data$codigo_partido_provincia,
      .data$codigo_partido,
      .data$denominacion,
      .data$siglas,
      .data$votos,
      .data$datos_oficiales ,
      .data$concejales_obtenidos,
      .after = .data$codigo_partido_nacional
    )

  ### Si no se quieren los distritos se eliminan de los datos
  if (distritos == FALSE) {
    df <- df[df$codigo_distrito == 99,]
  }

  return(df)
}
