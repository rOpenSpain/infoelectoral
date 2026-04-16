library(dplyr)

test_that("candidatos downloads and validates correctly", {
  skip_on_cran()
  skip_if_server_unavailable()

  data <- candidatos("senado", "2023", "07", nivel = "municipio") %>%
    filter(codigo_provincia != "99")

  # n_provincias
  n_provincias <- unique(data$codigo_provincia) %>% length()
  expect_equal(n_provincias, 52)

  # n_electos
  n_electos <-
    data %>%
    filter(electo == "S") %>%
    nrow()
  expect_gte(n_electos, 200)
})
