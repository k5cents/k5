
<!-- README.md is generated from README.Rmd. Please edit that file -->

# k5 <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/k5)](https://CRAN.R-project.org/package=k5)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/k5/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/k5?branch=master)
[![R build
status](https://github.com/kiernann/k5/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/k5/actions)
<!-- badges: end -->

The goal of ‘k5’ is to offer miscellaneous quality of life functions
used by [Kiernan Nicholls](https://github.com/kiernann) during
interactive programming. Many of the functions simply to bring commonly
used functions more in line with the
[tidyverse](https://www.tidyverse.org/) style.

## Installation

You can install the development version of ‘k5’ from
[GitHub](https://github.com/kiernann/k5):

``` r
# install.packages("remotes")
remotes::install_github("kiernann/k5")
```

## Example

``` r
library(fs)
library(k5)
library(readr)
```

The `zip_*()` functions use `utils::zip()` but return data like
`fs::file_*()`.

``` r
z <- file_temp(ext = "zip")
t %>% # can easily pipe into
  zip_create(z, junk = FALSE)
zip_info(z)
#> # A tibble: 5 x 3
#>   path                        size date               
#>   <fs::path>           <fs::bytes> <dttm>             
#> 1 tmp/RtmpsYA89A/A.txt      17.15K 2020-11-12 21:59:00
#> 2 tmp/RtmpsYA89A/B.txt      15.36K 2020-11-12 21:59:00
#> 3 tmp/RtmpsYA89A/C.txt        5.5K 2020-11-12 21:59:00
#> 4 tmp/RtmpsYA89A/D.txt       8.44K 2020-11-12 21:59:00
#> 5 tmp/RtmpsYA89A/E.txt       2.21K 2020-11-12 21:59:00
zip_size(z)
#> deflated: 48.6K, compressed: 24.5K (50.36%)
zip_move(z, tempdir())
```

Compare this to the output of the `utils::unzip()` and other base
versions.

``` r
zip(z, t)
file.size(z)
#> [1] 25086
unzip(z, list = TRUE)
#>                   Name Length                Date
#> 1 tmp/RtmpsYA89A/A.txt  17557 2020-11-12 21:59:00
#> 2 tmp/RtmpsYA89A/B.txt  15724 2020-11-12 21:59:00
#> 3 tmp/RtmpsYA89A/C.txt   5627 2020-11-12 21:59:00
#> 4 tmp/RtmpsYA89A/D.txt   8643 2020-11-12 21:59:00
#> 5 tmp/RtmpsYA89A/E.txt   2264 2020-11-12 21:59:00
unzip(z, exdir = tempdir())
```

<!-- refs: start -->

<!-- refs: end -->
