library(dplyr)

test_that("mesas downloads and validates correctly", {
  skip_on_cran()
  skip_if_server_unavailable()

  x <- fechas_elecciones %>%
    filter(tipo_eleccion == "generales") %>%
    sample() %>%
    slice(1)

  data <- mesas("congreso", x$anno, x$mes) %>%
    filter(codigo_provincia != "99")

  # n_provincias
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)

  # n_mesas more than 40000
  n_mesas <-
    data %>%
    select(starts_with("codigo_") & !starts_with("codigo_partido")) %>%
    distinct() %>%
    nrow()
  expect_gte(n_mesas, 40000)
})
