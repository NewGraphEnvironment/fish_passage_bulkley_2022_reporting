# install.packages('pak')

pkgs_cran <- c(
  'readwritesqlite',
  'sf',
  'readxl',
  'janitor',
  'leafem',
  'leaflet',
  'httr',
  'RPostgres',
  'DBI',
  'magick',
  'bcdata',
  'jpeg',
  'datapasta',
  'knitr',
  'data.table',
  'lubridate',
  'forcats',
  'bookdown',
  'fasstr',
  'tidyhydat',
  'geojsonio',
  'english',
  'leaflet.extras',
  'ggdark',
  'pdftools',
  'chron',
  'leafpop',
  'exifr',
  'pagedown',
  'devtools',
  'tidyverse',
  'fishbc'

)


pkgs_gh <- c(
  #hased out fpr due to https://github.com/NewGraphEnvironment/fpr/issues/94
  # "NewGraphEnvironment/fpr",
  "poissonconsulting/fwapgr",
  'poissonconsulting/poisspatial',
  # watch for issues in the future with this particular pin to deal with black captions
  # https://github.com/NewGraphEnvironment/mybookdown-template/issues/50
  "haozhu233/kableExtra@a9c509a"
)

pkgs_all <- c(pkgs_cran,
              pkgs_gh)

# install or upgrade all the packages with pak
# install or upgrade all the packages with pak
if(params$update_packages){
  lapply(pkgs_all, pak::pkg_install, ask = FALSE)
}

# load all the packages
pkgs_ld <- c(pkgs_cran,
             basename(pkgs_gh))

lapply(pkgs_ld,
       require,
       character.only = TRUE)

# load fpr due to https://github.com/NewGraphEnvironment/fpr/issues/94
library(fpr)

