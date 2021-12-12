#!/usr/bin/env Rscript
library(rmarkdown)

rmf = function(f)
{
  if (file.exists(f))
    file.remove(f)
}

clean = function()
{
  files = dir(pattern="*.Rmd", recursive=FALSE)
  for (f in files)
    rmf(f)
}

set_path = function()
{
  while (!file.exists("DESCRIPTION"))
  {
    setwd("..")
    if (getwd() == "/home")
      stop("couldn't find package!")
  }

  setwd("vignettes")
}

build_vignette = function(f)
{
  f_Rmd = basename(f)
  of = sub(f_Rmd, pattern="^_", replacement="")
  rmf(of)

  fmt = rmarkdown::md_document(
    # variant="gfm",
    preserve_yaml=TRUE,
    ext=".Rmd"
  )

  rmarkdown::render(
    f,
    output_file=of,
    output_dir=getwd(),
    output_format=fmt
  )

  invisible(TRUE)
}



# -----------------------------------------------------------------------
set_path()

clean()
build_vignette("./src/_infoelectoral.Rmd")
build_vignette("./src/_mesas.Rmd")
build_vignette("./src/_municipios.Rmd")
