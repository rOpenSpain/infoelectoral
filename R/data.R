#' Codigos INE de las provincias de España.
#'
#' Este conjunto de datos contiene los códigos INE y los nombres de las provincias españolas.
#'
#' @format Un conjunto de datos con 52 filas y 5 variables:
#' \describe{
#'   \item{codigo_ccaa}{código infoelectoral de la comunidad autónoma}
#'   \item{codigo_ccaa_ine}{código INE de la comunidad autónoma}
#'   \item{ccaa}{nombre oficial de la comunidad autónoma}
#'   \item{codigo_provincia}{código INE de la provincia}
#'   \item{provincia}{nombre oficial de la provincia}
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
#'   \item{provincia}{nombre oficial de la comunidad autónoma}
#' }
#' @source \url{http://www.infoelectoral.mir.es/infoelectoral/min/areaDescarga.html?method=inicio}
"ccaa"

#' Codigos de los municipios de España.
#'
#' Este conjunto de datos contiene los códigos INE de las municipios de España con sus denominaciones más recientes (p.e: Cabrera d'Igualada aparece como Cabrera d'Anoia). Para los municipios que en algún momento han sido fusionados se mantienen sus códigos por separado junto con el del nuevo municipio creado (p.e: contiene el municipio Oza-Cesuras pero también el de Cesuras y Oza dos Ríos por separado).
#'
#' @format Un conjunto de datos con 19 filas y 3 variables:
#' \describe{
#'   \item{codigo_provincia}{código INE de la provincia}
#'   \item{codigo_municipio}{código INE del municipio}
#'   \item{municipio}{nombre oficial más reciente del municipio}
#' }
#' @source \url{http://www.infoelectoral.mir.es/infoelectoral/min/areaDescarga.html?method=inicio}
"municipios"
