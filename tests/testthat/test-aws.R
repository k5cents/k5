test_that("bucket contents are listed as tibble", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(nzchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")))
  z <- aws_info(bucket = "publicaccountability")
  expect_length(z, 4)
  expect_s3_class(z$path, "fs_path")
  expect_s3_class(z$type, "factor")
  expect_s3_class(z$size, "fs_bytes")
  expect_s3_class(z$time, "POSIXt")
})

test_that("bucket objects are listed as vector", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(nzchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")))
  z <- aws_ls(bucket = "publicaccountability")
  expect_s3_class(z, "fs_path")
})
