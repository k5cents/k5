
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
t <- path_temp(LETTERS[1:5], ext = "txt")
for (i in seq_along(t)) {
  n <- runif(1, 100, 1000)
  write_lines(rnorm(n), t[i])
}
z <- file_temp(ext = "zip")
t %>% # can easily pipe into
  zip_create(z, junk = FALSE)
zip_info(z)
#> # A tibble: 5 x 3
#>   path                        size date               
#>   <fs::path>           <fs::bytes> <dttm>             
#> 1 tmp/RtmpdD6G9O/A.txt      14.85K 2020-11-12 19:41:00
#> 2 tmp/RtmpdD6G9O/B.txt       12.3K 2020-11-12 19:41:00
#> 3 tmp/RtmpdD6G9O/C.txt       7.57K 2020-11-12 19:41:00
#> 4 tmp/RtmpdD6G9O/D.txt      15.88K 2020-11-12 19:41:00
#> 5 tmp/RtmpdD6G9O/E.txt       6.25K 2020-11-12 19:41:00
zip_size(z)
#> deflated: 56.9K, compressed: 28.5K (50.12%)
zip_move(z, tempdir())
```

<!-- refs: start -->

<!-- refs: end -->
