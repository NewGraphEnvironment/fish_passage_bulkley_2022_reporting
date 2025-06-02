# install.packages('pak')

pkgs_cran <- c(
  # 'readwritesqlite',
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
  # 'fishbc',
  'kableExtra'

)


pkgs_gh <- c(
  #hased out fpr due to https://github.com/NewGraphEnvironment/fpr/issues/94
  # "NewGraphEnvironment/fpr",
  "poissonconsulting/fwapgr",
  'poissonconsulting/poisspatial',
  "lucy-schick/fishbc@updated_data",
  "poissonconsulting/readwritesqlite" #https://github.com/poissonconsulting/readwritesqlite/issues/47
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

