library(fs)

test_that("tar archives can be created", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  expect_true(file_exists(z))
  expect_lt(file_size(z), file_size(t))
  unlink(c(t, z))
})

test_that("tar paths can be junked", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  l <- tar_ls(z)
  expect_true(file_exists(z))
  expect_lt(file_size(z), file_size(t))
  unlink(c(t, z))
})

test_that("tar contents can be listed", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  o <- tar_ls(z)
  expect_equal(length(o), length(t))
  expect_s3_class(o, "fs_path")
  unlink(c(t, z, o))
})

test_that("tar total size is returned invisibly", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  o <- expect_invisible(tar_size(z))
  expect_s3_class(o, "fs_bytes")
  unlink(c(t, z))
})

test_that("tar total size comparrison is displayed", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  expect_output(
    object = tar_size(z),
    regexp = "deflated: .*, compressed: .* (.*)"
  )
  unlink(c(t, z))
})


test_that("vector of tar content sizes is returned", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t1 <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t1)
  t2 <- file_temp("iris", ext = "csv")
  write.csv(iris, t2)
  z <- tar_create(c(t1, t2), file_temp(ext = "tar"))
  o <- tar_size(z, sum = FALSE)
  expect_length(o, 2)
  expect_s3_class(o, "fs_bytes")
  unlink(c(t1, t2, z))
})

test_that("multiple tars can be listed", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t1 <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t1)
  z1 <- tar_create(t1, file_temp(ext = "tar"))

  t2 <- file_temp("iris", ext = "csv")
  write.csv(iris, t2)
  z2 <- tar_create(t2, file_temp(ext = "tar"))

  o <- tar_info(c(z1, z2))
  expect_equal(nrow(o), 2)
  expect_length(o, 6)
  expect_s3_class(o, "data.frame")
  unlink(c(t1, t2, z1, z2, o))
})

test_that("tars can be extracted", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  o <- tar_move(z, tempdir())
  expect_equal(length(o), length(t))
  expect_s3_class(o, "fs_path")
  unlink(c(t, z, o))
})

test_that("tar extract fails without dir", {
  skip_on_os("windows")
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- tar_create(t)
  expect_error(tar_move(z))
  unlink(c(t, z))
})
