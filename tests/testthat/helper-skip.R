skip_if_server_unavailable <- function() {
  url <- "https://infoelectoral.interior.gob.es"
  tryCatch(
    {
      httr::HEAD(url, httr::timeout(5))
    },
    error = function(e) {
      skip(paste("Server unavailable:", conditionMessage(e)))
    }
  )
}
