old_max <- getOption("max.print")
max <- 1000
options(max.print = max)
x <- data.frame(
  state = sample(state.name, size = max + 1, replace = TRUE),
  x = rnorm(n = max + 1),
  y = sample(-9:9, size = max + 1, replace = TRUE),
  z = rep(rivers, length.out = max + 1)
)
y <- x[seq((max/2)), ]
a <- tibble::as_tibble(x)
b <- tibble::as_tibble(y)

test_that("printing all of long data frame", {
  # should print
  expect_output(print_all(x, ask = FALSE), NULL)
  # prints all rows plus header
  l <- capture_output_lines(print_all(x, ask = FALSE))
  expect_length(l, nrow(x) + 1)
})

test_that("printing all of long tibble", {
  # should print
  expect_output(print_all(a, ask = FALSE), NULL)
  # prints all rows plus header and footer
  l <- capture_output_lines(print_all(a, ask = FALSE))
  expect_length(l, nrow(a) + 3)
})

test_that("printing all short data frame", {
  # should print
  expect_output(print_all(y, ask = FALSE), NULL)
  # prints all rows plus header and max
  l <- capture_output_lines(print_all(y, ask = FALSE))
  expect_length(l, nrow(y) + 1)
})

test_that("printing all short tibble", {
  # should print
  expect_output(print_all(b, ask = FALSE), NULL)
  # prints all rows plus header and footer
  l <- capture_output_lines(print_all(b, ask = FALSE))
  expect_length(l, nrow(b) + 3)
})

options(max.print = old_max)
