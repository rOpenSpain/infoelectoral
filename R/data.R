#' Administrative codes for spanish provinces.
#'
#' This dataset contains the National Institute of Statistics administrative codes for spanish provinces with their official names.
#'
#' @format A dataset with 52 rows and 5 columns:
#' \describe{
#'   \item{codigo_ccaa}{Code given to the autonomous communities by the Ministry of Interior (not the same as the National Institute of Statistics codes)}
#'   \item{codigo_ccaa_ine}{Code given to the autonomous communities by the National Institute of Statistics}
#'   \item{ccaa}{Official name of the autonomous communities}
#'   \item{codigo_provincia}{Code given to the provinces by the National Institute of Statistics}
#'   \item{provincia}{Official name of the provinces}
#' }
#' @source \url{https://www.ine.es/daco/daco42/codmun/cod_provincia.htm}
"codigos_provincias"

#' Administrative codes for spanish autonomous communities.
#'
#' This dataset contains the codes given to the autonomus communities by the Ministry of Interior and the ones given by the National Institute of Statistics with their official names.
#'
#' @format A dataset with 19 rows and 3 columns:
#' \describe{
#'   \item{codigo_ccaa}{Code given to the autonomous communities by the Ministry of Interior (not the same as the National Institute of Statistics codes)}
#'   \item{codigo_ccaa_ine}{Code given to the autonomous communities by the National Institute of Statistics}
#'   \item{provincia}{Official name of the provinces}
#' }
#' @source \url{https://infoelectoral.interior.gob.es/opencms/es/elecciones-celebradas/area-de-descargas/}
"codigos_ccaa"

#' Administrative codes for spanish municipalities.
#'
#'This dataset contains the INE codes of the municipalities of Spain with their most recent names (eg: Cabrera d'Igualada appears as Cabrera d'Anoia). For the municipalities that have been merged at some point, their codes are kept separately along with that of the new municipality created (eg: it contains the municipality Oza-Cesuras but also that of Cesuras and Oza dos Ríos separately).
#'
#' @format A dataset with more than 8.000 rows and 3 columns:
#' \describe{
#'   \item{codigo_provincia}{Code given to the provinces by the National Institute of Statistics}
#'   \item{codigo_municipio}{Code given to the municipalities by the National Institute of Statistics}
#'   \item{municipio}{Most recent official name of the municipality}
#' }
#' @source \url{https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177031&menu=ultiDatos&idp=1254734710990}
"codigos_municipios"

#' Recoded party names
#'
#' This dataset contains a list of recoded electoral party or coalition names with their correspondent national codes. For example: 'PSOE' when the original name is 'PSA-PSOE', 'PSOE-PROGR.' or 'PSOE-A'. This recodification helps the longitudinal analysis of the electoral results, avoiding the many variations in the party and coalition names.
#'
#' @format A dataset with the names of the electoral party or coalition
#' \describe{
#'   \item{anno}{Year of the election}
#'   \item{mes}{Month of the election}
#'   \item{codigo_partido_nacional}{The national accumulation code for the electoral party or coalition}
#'   \item{partido}{The recoded name for the electoral party or coalition.}
#' }
"codigos_partidos"

#' Mean income at the census section level (INE)
#'
#' This dataset contains the mean income of each census section
#'
#' @format A dataset with more than 34.000 rows and 2 columns:
#' \describe{
#'   \item{codigo_seccion}{Code given to the census section made by the combination of the codes of the province, the municipality, the district and the section.}
#'   \item{renta}{Mean income of the census section in euros}
#' }
#' @source \url{https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177088&menu=ultiDatos&idp=1254735976608}
"renta"
