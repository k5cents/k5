test_that("bucket contents are listed as tibble", {
  skip_if_offline()
  z <- aws_info(bucket = "1000genomes")
  expect_length(z, 4)
  expect_s3_class(z$path, "fs_path")
  expect_s3_class(z$type, "factor")
  expect_s3_class(z$size, "fs_bytes")
  expect_s3_class(z$time, "POSIXt")
})

test_that("bucket objects are listed as vector", {
  skip_if_offline()
  z <- aws_ls(bucket = "1000genomes")
  expect_s3_class(z, "fs_path")
})
