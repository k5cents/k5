library(fs)

p1 <- test_path("test-aws.R")
p2 <- test_path("test-last.R")

test_that("wc called for default args", {
  skip_on_os("mac")
  wc <- word_count(p1)
  expect_length(wc, 4)
  expect_s3_class(wc[[1]], "fs_path")
  expect_type(wc[[2]], "integer")
})

test_that("wc called for single arg on one file", {
  skip_on_os("mac")
  wc <- word_count(p1, "bytes")
  expect_length(wc, 2)
  expect_s3_class(wc[[1]], "fs_path")
  expect_s3_class(wc[[2]], "fs_bytes")
})

test_that("wc called for single arg on multiple files", {
  skip_on_os("mac")
  wc <- word_count(c(p1, p2), "bytes")
  expect_length(wc, 2)
  expect_s3_class(wc[[1]], "fs_path")
  expect_s3_class(wc[[2]], "fs_bytes")
  expect_true(nrow(wc) == 2)
})

test_that("wc called for multiple args on multiple files", {
  skip_on_os("mac")
  wc <- word_count(c(p1, p2), c("bytes", "max"))
  expect_length(wc, 3)
  expect_s3_class(wc[[1]], "fs_path")
  expect_s3_class(wc[[2]], "fs_bytes")
  expect_true(nrow(wc) == 2)
})
