test_that("filtering data frame by column with regex", {
  x <- filter_rx(iris, Species, "^v")
  expect_true(all(grepl("^v", unique(x$Species))))
})
