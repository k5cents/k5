tmp <- tempfile()
writeLines(LETTERS, tmp)

test_that("new file has an age in a period class", {
  skip_on_os("mac")
  skip_if_not(file.exists(tmp))
  a <- file_age(tmp)
  expect_true(inherits(a, "Period"))
})

test_that("new file has an age in a period class", {
  skip_on_os("mac")
  skip_if_not(file.exists(tmp))
  e <- file_encoding(tmp)
  expect_s3_class(e, "data.frame")
  expect_s3_class(e$path, "fs_path")
  expect_equal(e$charset, "us-ascii")
})
