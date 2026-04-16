library(dplyr)
library(infoelectoral)

download_all <- function() {
  fechas_elecciones <- fechas_elecciones[-9, ] %>%
    mutate(tipo_eleccion = ifelse(tipo_eleccion == "generales", "congreso", tipo_eleccion))

  data <- NULL
  for (i in 1:nrow(fechas_elecciones)) {
    t <- fechas_elecciones$tipo_eleccion[i]
    a <- fechas_elecciones$anno[i]
    m <- fechas_elecciones$mes[i]

    tmp <- provincias(t, a, m)

    data <- rbind(data, tmp)
  }

  return(data)
}


test_that("Download all elections provincias", {
  skip_on_cran()
  skip_if_server_unavailable()
  expect_warning(download_all(), regexp = NA)
})
