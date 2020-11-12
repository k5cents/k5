
<!-- README.md is generated from README.Rmd. Please edit that file -->

# k5

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
interactive programming. Many of the functions offer simple changes to
bring commonly used functions more in line with the
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
t <- path_temp(LETTERS[1:5], ext = "txt")
for (i in seq_along(t)) {
  n <- runif(1, 100, 1000)
  write_lines(rnorm(n), t[i])
}
sum(file_size(t))
#> 44.2K
z <- file_temp(ext = "zip")
t %>% # can easily pipe zip
  zip_create(z, junk = FALSE)
zip_ls(z)
#> # A tibble: 5 x 3
#>   path                        size date               
#>   <fs::path>           <fs::bytes> <dttm>             
#> 1 tmp/RtmpAT2cmv/A.txt      15.07K 2020-11-11 19:35:00
#> 2 tmp/RtmpAT2cmv/B.txt       9.77K 2020-11-11 19:35:00
#> 3 tmp/RtmpAT2cmv/C.txt       4.09K 2020-11-11 19:35:00
#> 4 tmp/RtmpAT2cmv/D.txt       12.3K 2020-11-11 19:35:00
#> 5 tmp/RtmpAT2cmv/E.txt       2.94K 2020-11-11 19:35:00
file_size(z)
#> 22.4K
o <- zip_move(z, path_temp("test"))
sum(file_size(o))
#> 44.2K
```

<!-- refs: start -->

<!-- refs: end -->
