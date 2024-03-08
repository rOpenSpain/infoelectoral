library(dplyr)

set.seed(120)
x <- fechas_elecciones %>%
  filter(tipo_eleccion == "generales") %>%
  sample() %>%
  slice(1)

data <- mesas("congreso", x$anno, x$mes) %>%
  filter(codigo_provincia != "99")

test_that("n_provincias function", {
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)
})


test_that("n_mesas more than 40000", {
  n_mesas <-
    data %>%
    select(starts_with("codigo_") & !starts_with("codigo_partido")) %>%
    distinct() %>%
    nrow()

  expect_gte(n_mesas, 40000)
})
