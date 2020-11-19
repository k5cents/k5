library(ggplot2)
library(readr)
library(fs)

test_that("last images without ext are saved as png", {
  x <- ggplot(diamonds, aes(color)) + geom_bar()
  y <- write_last(x)
  expect_true(file_exists(y))
})

test_that("last images are saved with custom dimmensions", {
  x <- ggplot(diamonds, aes(color)) + geom_bar()
  y <- write_last(x, height = 5, width = 10, device = "jpg")
  expect_true(file_exists(y))
})

test_that("data frames are saved as tsv", {
  y <- write_last(x = mtcars, col_names = FALSE)
  expect_true(file_exists(y))
  expect_error(read_tsv(y, col_names = FALSE), NA)
})

test_that("vectors are saved as txt", {
  y <- write_last(x = state.name)
  expect_true(file_exists(y))
  expect_error(read_lines(y), NA)
})

test_that("lists are saved as rds", {
  y <- write_last(x = list(a = 1, b = "2"))
  expect_true(file_exists(y))
  expect_error(z <- read_rds(y), NA)
  expect_length(z, 2)
  expect_type(z, "list")
})

test_that("functions are saved as R source files", {
  y <- write_last(x = tibble::as_tibble)
  expect_true(file_exists(y))
  expect_error(z <- read_lines(y), NA)
  expect_true(grepl("^function", z[1]))
})

test_that("other objects fail to save", {
  expect_error(write_last(x = austres))
})
