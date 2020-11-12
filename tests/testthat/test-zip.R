library(fs)

test_that("zip archives can be created", {
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- zip_create(t)
  expect_true(file_exists(z))
  expect_lt(file_size(z), file_size(t))
  unlink(c(t, z))
})

test_that("zip paths can be junked", {
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- zip_create(t, junk = TRUE)
  l <- zip_ls(z)
  expect_true(file_exists(z))
  expect_equal(dirname(l), ".")
  expect_lt(file_size(z), file_size(t))
  unlink(c(t, z))
})

test_that("zip contents can be listed", {
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- zip_create(t)
  o <- zip_ls(z)
  expect_equal(length(o), length(t))
  expect_s3_class(o, "fs_path")
  unlink(c(t, z, o))
})

test_that("multiple zips can be listed", {
  skip_if_not_installed("utils")
  t1 <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t1)
  z1 <- zip_create(t1, file_temp(ext = "zip"))

  t2 <- file_temp("iris", ext = "csv")
  write.csv(iris, t2)
  z2 <- zip_create(t2, file_temp(ext = "zip"))

  o <- zip_info(c(z1, z2))
  expect_equal(nrow(o), 2)
  expect_length(o, 3)
  expect_s3_class(o, "data.frame")
  unlink(c(t1, t2, z1, z2, o))
})

test_that("zips can be extracted", {
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- zip_create(t)
  o <- zip_move(z, tempdir())
  expect_equal(length(o), length(t))
  expect_s3_class(o, "fs_path")
  unlink(c(t, z, o))
})

test_that("zip extract fails without dir", {
  skip_if_not_installed("utils")
  t <- file_temp("mtcars", ext = "csv")
  write.csv(mtcars, t)
  z <- zip_create(t)
  expect_error(zip_move(z))
  unlink(c(t, z))
})
