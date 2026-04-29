test_that("safe_download_infoelectoral fails gracefully on request errors", {
  destfile <- tempfile(fileext = ".zip")
  get <- function(...) {
    stop("SSL certificate problem: unable to get local issuer certificate")
  }

  expect_warning(
    expect_message(
      {
        result <- safe_download_infoelectoral(
          "https://example.test/file.zip",
          destfile,
          get = get
        )
        expect_null(result)
      },
      "SSL certificate problem"
    ),
    NA
  )

  expect_false(file.exists(destfile))
})

test_that("safe_download_infoelectoral fails gracefully on request warnings", {
  destfile <- tempfile(fileext = ".zip")
  get <- function(...) {
    warning("Timeout was reached")
  }

  expect_warning(
    expect_message(
      {
        result <- safe_download_infoelectoral(
          "https://example.test/file.zip",
          destfile,
          get = get
        )
        expect_null(result)
      },
      "Timeout was reached"
    ),
    NA
  )

  expect_false(file.exists(destfile))
})

test_that("safe_download_infoelectoral fails gracefully on HTTP errors", {
  destfile <- tempfile(fileext = ".zip")
  response <- structure(
    list(status_code = 500, content = raw()),
    class = "response"
  )
  get <- function(...) response

  expect_warning(
    expect_message(
      {
        result <- safe_download_infoelectoral(
          "https://example.test/file.zip",
          destfile,
          get = get
        )
        expect_null(result)
      },
      "HTTP 500"
    ),
    NA
  )

  expect_false(file.exists(destfile))
})

test_that("safe_download_infoelectoral writes successful downloads", {
  destfile <- tempfile(fileext = ".zip")
  response <- structure(
    list(status_code = 200, content = charToRaw("zip-bytes")),
    class = "response"
  )
  get <- function(...) response

  expect_warning(
    expect_message(
      {
        result <- safe_download_infoelectoral(
          "https://example.test/file.zip",
          destfile,
          get = get
        )
        expect_identical(result, destfile)
      },
      "Downloading"
    ),
    NA
  )

  expect_true(file.exists(destfile))
  expect_identical(readBin(destfile, "raw", n = 9), charToRaw("zip-bytes"))
})

test_that("safe_unzip_infoelectoral fails gracefully on invalid archives", {
  zipfile <- tempfile(fileext = ".zip")
  writeLines("not a zip archive", zipfile)

  expect_warning(
    expect_message(
      {
        result <- safe_unzip_infoelectoral(zipfile, tempdir())
        expect_false(result)
      },
      "Could not unzip downloaded file"
    ),
    NA
  )
})
