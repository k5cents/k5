test_that("given packages can be saved", {
  tmp <- tempfile()
  a <- "test"
  save.packages(a, tmp)
  b <- readLines(tmp)
  expect_equal(a, b)
})

test_that("attached packages can be saved", {
  tmp <- tempfile()
  save.packages(NULL, tmp)
  expect_true(file.exists(tmp))
  b <- readLines(tmp)
  expect_gt(length(b), 1)
})

test_that("default packages can be loaded", {
  tmp <- tempfile()
  writeLines("k5", tmp)
  x <- load.packages(path = tmp, install = FALSE)
  expect_length(x, 1)
})
