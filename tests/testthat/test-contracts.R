test_that("contracts with words", {
  x <- contract_convert(c("4 or fewer", "8 or more", "5", "6", "7"))
  expect_s3_class(x, "ordered")
  expect_s3_class(x, "factor")
  expect_length(x, 5)
})

test_that("contracts with percentages", {
  x <- contract_convert(c("3%-", "12%+", "9% - 12%", "3% - 6%", "6% - 9%"))
  expect_s3_class(x, "ordered")
  expect_s3_class(x, "factor")
  expect_length(x, 5)
})

test_that("contracts with integers", {
  x <- contract_convert(c("219-", "220 to 229", "240+",  "230 to 239"))
  expect_s3_class(x, "ordered")
  expect_s3_class(x, "factor")
  expect_length(x, 4)
})

test_that("contracts with names", {
  a <- c("Sanders", "Biden", "Warren", "Buttigieg")
  x <- contract_convert(a)
  expect_s3_class(x, "factor")
  expect_true(all(levels(x) == sort(a)))
})

test_that("contracts with single value", {
  x <- contract_convert(c("Brokered convention?", "Brokered convention?"))
  expect_type(x, "logical")
})

