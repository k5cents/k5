test_that("Character vectors can be counted with dplyr", {
  c <- count2(mtcars, cyl)
  expect_s3_class(c, "data.frame")
  expect_type(c$n, "integer")
  expect_type(c$p, "double")
})

test_that("Character counts can be sorted and fractioned", {
  x <- sample(LETTERS)[rpois(1000, 10)]
  c <- count_vec(x, sort = TRUE, prop = TRUE)
  expect_true("p" %in% names(c))
  expect_true(all(diff(c$n) <= 0))
})


