library(dplyr)

set.seed(120)
x <- fechas_elecciones %>%
  filter(tipo_eleccion == "generales") %>%
  sample() %>%
  slice(1)

data <- provincias("congreso", x$anno, x$mes) %>%
  filter(codigo_provincia != "99")


test_that("n_diputados  equal to 350", {

  n_diputados <-
    data %>%
    summarise(n_diputados = sum(diputados)) %>% pull(n_diputados)

  expect_equal(n_diputados, 350)
})

test_that("n_provincias equal to 52", {
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)
})

test_that("more than 300 rows", {
  expect_gte(nrow(data), 300)
})
