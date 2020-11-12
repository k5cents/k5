test_that("installation can be checked", {
  expect_true(is_installed("fs"))
  expect_false(is_installed("ABCDEFG"))
})
