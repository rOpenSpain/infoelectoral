library(dplyr)

set.seed(120)
x <- fechas_elecciones %>%
  filter(tipo_eleccion == "generales") %>%
  sample() %>%
  slice(1)

data <- candidatos("senado", x$anno, x$mes, nivel = "municipio") %>%
  filter(codigo_provincia != "99")


test_that("n_provincias function", {
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)
})


test_that("n_electos function", {
  n_electos <-
    data %>%
    filter(electo == "S") %>%
    nrow()

  expect_gte(n_electos, 200)
})
