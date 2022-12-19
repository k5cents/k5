
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

The goal of `k5` is to offer miscellaneous quality of life functions
used by [Kiernan Nicholls](https://github.com/kiernann) during
interactive programming. They make things easier for me but are *bad*
for scripts and packages.

## Installation

You can install the development version of `k5` from
[GitHub](https://github.com/kiernann/k5):

``` r
# install.packages("remotes")
remotes::install_github("kiernann/k5")
```

## Example

``` r
library(k5)
packageVersion("k5")
#> [1] '0.0.3'
```

A list of frequently used packages can be loaded from a file.

``` r
load.packages(path = NULL, install = FALSE)
#> ✔ load 20 packages from
#> '/home/kiernan/R/x86_64-pc-linux-gnu-library/4.2/k5/PACKAGES'
```

Some functions wrap common combos like `sum(is.na(x))` or
`mean(x %in% y)`.

``` r
x <- c("VT", "NH", "ZZ", "ME", NA)
count_out(x, state.abb)
#> [1] 1
na_out(x, state.abb)
#> [1] "VT" "NH" NA   "ME" NA
prop_na(x)
#> [1] 0.2
```

Some functions wrap functions from other packages with different
defaults.

``` r
count(mtcars, cyl)
#>   cyl  n
#> 1   4 11
#> 2   6  7
#> 3   8 14

# sort and add fraction
count2(mtcars, cyl)
#> # A tibble: 3 × 3
#>     cyl     n     p
#>   <dbl> <int> <dbl>
#> 1     8    14 0.438
#> 2     4    11 0.344
#> 3     6     7 0.219
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
