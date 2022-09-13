test_that("bucket contents are listed as tibble", {
  skip("No AWS credentials")
  skip_if_offline()
  z <- aws_info(bucket = "1000genomes")
  expect_length(z, 4)
  expect_s3_class(z$path, "fs_path")
  expect_s3_class(z$type, "factor")
  expect_s3_class(z$size, "fs_bytes")
  expect_s3_class(z$time, "POSIXt")
})

test_that("bucket objects are listed as vector", {
  skip("No AWS credentials")
  skip_if_offline()
  z <- aws_ls(bucket = "1000genomes")
  expect_s3_class(z, "fs_path")
})

test_that("bucket instruction message given", {
  skip("No AWS credentials")
  expect_message(aws_bucket(bucket = "test", set = TRUE))
})

test_that("bucket option returned", {
  skip("No AWS credentials")
  old_opt <- getOption("aws.bucket", "")
  new_opt <- "1000genomes"
  options(aws.bucket = new_opt)
  expect_equal(aws_bucket(), new_opt)
  options(aws.bucket = old_opt)
})
