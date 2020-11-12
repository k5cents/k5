
<!-- README.md is generated from README.Rmd. Please edit that file -->

# k5

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/k5)](https://CRAN.R-project.org/package=k5)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/k5)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/k5/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/k5?branch=master)
[![R build
status](https://github.com/kiernann/k5/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/k5/actions)
<!-- badges: end -->

The goal of k5 is to offer miscellaneous quality of life functions used
by [Kiernan Nicholls](https://github.com/kiernann) (aka *k5cents*)
during interactive R coding. A lot of these functions offer simple
extensions and improvements to bring commonly used functions more in
like with \[tidyverse\] style.

## Installation

You can install the development version of k5 from
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

The `zip_*()` functions take `zip()`/`unzip()` but return data like
`dir_ls()`.

``` r
t <- path_temp(LETTERS[1:5], ext = "txt")
for (i in seq_along(t)) {
  n <- runif(1, 100, 1000)
  write_lines(rnorm(n), t[i])
}
sum(file_size(t))
#> 53.9K
z <- file_temp(ext = "zip")
t %>% # can easily pipe zip
  zip_create(z, junk = TRUE)
zip_ls(z)
#> # A tibble: 5 x 3
#>   path              size date               
#>   <fs::path> <fs::bytes> <dttm>             
#> 1 A.txt            8.94K 2020-11-11 19:16:00
#> 2 B.txt           10.13K 2020-11-11 19:16:00
#> 3 C.txt           17.28K 2020-11-11 19:16:00
#> 4 D.txt            8.13K 2020-11-11 19:16:00
#> 5 E.txt            9.42K 2020-11-11 19:16:00
file_size(z)
#> 27K
o <- zip_move(z, path_temp("test"))
sum(file_size(o))
#> 53.9K
```

<!-- refs: start -->

<!-- refs: end -->
