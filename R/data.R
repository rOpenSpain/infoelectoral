#' Codigos INE de las provincias de España.
#'
#' Este conjunto de datos contiene los códigos INE y los nombres de las provincias españolas.
#'
#' @format Un conjunto de datos con 52 filas y 2 variables:
#' \describe{
#'   \item{codigo_provincia}{código INE de la provincia}
#'   \item{provincia}{Nombre oficial de la provincia}
#' }
#' @source \url{https://www.ine.es/daco/daco42/codmun/cod_provincia.htm}
"provincias"

#' Codigos de las comunidades autónomas de España.
#'
#' Este conjunto de datos contiene los códigos de las comunidades autónomas tal y como aparecen en el diseño de registro de infoelectoral, los códigos INE y los nombres de las comunidades autónomas españolas.
#'
#' @format Un conjunto de datos con 19 filas y 3 variables:
#' \describe{
#'   \item{codigo_ccaa}{código infoelectoral de la comunidad autónoma}
#'   \item{codigo_ccaa_ine}{código INE de la comunidad autónoma}
#'   \item{provincia}{Nombre oficial de la comunidad autónoma}
#' }
#' @source \url{http://www.infoelectoral.mir.es/infoelectoral/min/areaDescarga.html?method=inicio}
"ccaa"
