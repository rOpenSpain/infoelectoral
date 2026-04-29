#' @title Downloads the elections zip file
#'
#' @param url The URL of the elections zip to download
#' @param tempfile The path to save the downloaded file
#'
#' @return The path to the downloaded file, or \code{NULL} if the remote
#'   resource is unavailable.
#'
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom httr timeout
#'
#' @keywords internal
#'
safe_download_infoelectoral <- function(url, tempfile, get = httr::GET) {
  UA <- paste(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0)",
    "Gecko/20100101 Firefox/98.0"
  )
  request_timeout <- getOption("infoelectoral.timeout", 10)
  request_timeout <- suppressWarnings(as.numeric(request_timeout))
  if (is.na(request_timeout) || request_timeout <= 0) {
    request_timeout <- 10
  }

  if (file.exists(tempfile)) {
    message(
      "File already exists, skipping download. Reading existing file ",
      gsub("..+/", "", tempfile)
    )
    return(tempfile)
  }

  message("Downloading ", url)
  res <- tryCatch(
    get(
      url,
      add_headers(`User-Agent` = UA, Connection = "keep-alive"),
      timeout(request_timeout)
    ),
    warning = function(w) {
      message(
        "Could not download ", url, ": ", conditionMessage(w),
        ". The remote resource may be temporarily unavailable."
      )
      NULL
    },
    error = function(e) {
      message(
        "Could not download ", url, ": ", conditionMessage(e),
        ". The remote resource may be temporarily unavailable."
      )
      NULL
    }
  )

  if (is.null(res)) {
    return(NULL)
  }

  status <- httr::status_code(res)
  if (status >= 400) {
    message(
      "Could not download ", url, ": HTTP ", status,
      ". The remote resource may be temporarily unavailable."
    )
    return(NULL)
  }

  tryCatch(
    {
      writeBin(res$content, tempfile)
      tempfile
    },
    warning = function(w) {
      message("Could not write downloaded file: ", conditionMessage(w))
      NULL
    },
    error = function(e) {
      message("Could not write downloaded file: ", conditionMessage(e))
      NULL
    }
  )
}

#' @title Downloads the elections zip file
#'
#' @param url The URL of the elections zip to download
#' @param tempfile The path to save the downloaded file
#'
#' @return The path to the downloaded file, or \code{NULL} if the remote
#'   resource is unavailable.
#'
#' @keywords internal
#'
download_bin <- function(url, tempfile) {
  path <- safe_download_infoelectoral(url, tempfile)
  if (is.null(path)) {
    return(NULL)
  } else {
    return(path)
  }
}

safe_unzip_infoelectoral <- function(zipfile, exdir) {
  tryCatch(
    {
      unzip(zipfile, overwrite = TRUE, exdir = exdir)
      TRUE
    },
    warning = function(w) {
      message(
        "Could not unzip downloaded file ", zipfile, ": ",
        conditionMessage(w)
      )
      FALSE
    },
    error = function(e) {
      message(
        "Could not unzip downloaded file ", zipfile, ": ",
        conditionMessage(e)
      )
      FALSE
    }
  )
}
