#' @title Downloads the elections zip file
#'
#' @param url The URL of the elections zip to download
#' @param tempfile The path to save the downloaded file
#'
#' @return NULL
#'
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom httr stop_for_status
#' @importFrom httr timeout
#'
#' @keywords internal
#'
download_bin <- function(url, tempfile) {
  UA <- paste(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0)",
    "Gecko/20100101 Firefox/98.0"
  )

  if (file.exists(tempfile)) {
    message(
      "File already exists, skipping download. Reading existing file ",
      gsub("..+/", "", tempfile)
    )
  } else {
    message("Downloading ", url)
    res <- GET(
      url,
      add_headers(`User-Agent` = UA, Connection = "keep-alive"),
      timeout(30)
    )
    stop_for_status(res)
    writeBin(res$content, tempfile)
  }
}
