library(ggplot2)
library(readr)

tmp_csv <- tempfile(fileext = ".csv")
tmp_tsv <- tempfile(fileext = ".tsv")

write_csv(diamonds, tmp_csv)
write_tsv(diamonds, tmp_tsv)

test_that("read csv file with explit delim", {
  x <- read_delim_dumb(tmp_csv, delim = ",")
  expect_type(x$cut, "character")
  expect_type(x$x, "character")
})

test_that("read csv file with implicit comma", {
  x <- read_csv_dumb(tmp_csv)
  expect_type(x$cut, "character")
  expect_type(x$x, "character")
})

test_that("read csv file with implicit tab", {
  x <- read_tsv_dumb(tmp_tsv)
  expect_type(x$cut, "character")
  expect_type(x$x, "character")
})
