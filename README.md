
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
interactive programming. They make things easier for me but are *bad*
for scripts and packages.

## Installation

You can install the development version of ‘k5’ from
[GitHub](https://github.com/kiernann/k5):

``` r
# install.packages("remotes")
remotes::install_github("kiernann/k5")
```

## Example

``` r
library(k5)
```

A list of frequently used packages can be loaded from a system (or
custom) file.

``` r
load.packages(path = NULL, install = FALSE)
#> ✓ load 20 packages from '/home/kiernan/R/x86_64-pc-linux-gnu-library/3.6/k5/PACKAGES'
```

The `zip_*()` functions use `utils::zip()` but return data like
`fs::file_*()`.

``` r
z <- file_temp(ext = "zip")
tmp %>% # can easily pipe into
  zip_create(z, junk = FALSE)
zip_info(z)
#> # A tibble: 3 x 3
#>   path                        size date               
#>   <fs::path>           <fs::bytes> <dttm>             
#> 1 tmp/RtmpvzndAB/A.txt      14.99K 2020-12-03 09:55:00
#> 2 tmp/RtmpvzndAB/B.txt       7.74K 2020-12-03 09:55:00
#> 3 tmp/RtmpvzndAB/C.txt      13.71K 2020-12-03 09:55:00
zip_size(z)
#> ℹ deflated: 36.4K, compressed: 18.3K (50.12%)
zip_move(z, tempdir())
```

There are also some handy shortcuts for the `.Last.value` tool.

``` r
df <- tail(mtcars, 50)
write_last()
#> ℹ `.Last.value` has class 'data.frame'
#> ✓ Saved tab-separated file '/tmp/RtmpFTaCH6/file15127cc7851b.tsv' (1.25K)
vc <- sample(state.name, 1000, replace = TRUE)
write_last()
#> ℹ `.Last.value` has class 'character'
#> ✓ Saved line-separated file '/tmp/RtmpFTaCH6/file151235b67c89.txt' (9.19K)
```

<!-- refs: start -->

<!-- refs: end -->
