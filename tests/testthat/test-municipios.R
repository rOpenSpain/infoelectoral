library(dplyr)

set.seed(120)
x <- fechas_elecciones %>%
  filter(tipo_eleccion == "generales") %>%
  sample() %>%
  slice(1)

data <- municipios("congreso", x$anno, x$mes) %>%
  filter(codigo_provincia != "99")


test_that("n_provincias equal to 52", {
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)
})


test_that("n_municipios more than 8100", {
  n_municipios <-
    data %>%
    select(starts_with("codigo_") & !starts_with("codigo_partido")) %>%
    distinct() %>%
    nrow()

  expect_gte(n_municipios, 8100)
})
