#' Count the way you want
#'
#' A wrapper around [dplyr::count()] with `sort` set to `TRUE` by default and
#' the an additional column created by default containing the proportional
#' fraction each observation makes of the whole.
#'
#' @param x A data frame.
#' @param ... Variables to group by.
#' @param wt Frequency weights.
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param prop If `TRUE`, compute the fraction of marginal table.
#' @examples
#' count(iris, Species)
#' @importFrom tibble as_tibble
#' @return A tibble of element counts
#' @export
count <- function(x, ..., wt = NULL, sort = TRUE, prop = TRUE) {
  if (is.null(wt)) {
    df <- dplyr::count(x = x, ..., sort = sort)
  } else {
    df <- dplyr::count(x = x, ..., wt = wt, sort = sort)
  }
  if (prop) {
    df$p <- prop.table(df$n)
  }
  as_tibble(df)
}

#' Count values in a character vector
#'
#' Method for [dplyr::count()] (or [count()] wrapper).
#'
#' @param x A character vector.
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param prop If `TRUE`, compute the fraction of marginal table.
#' @examples
#' x <- sample(LETTERS)[rpois(1000, 10)]
#' count(x)
#' @importFrom tibble as_tibble
#' @return A tibble of element counts
#' @export
count.character <- function(x, sort = TRUE, prop = TRUE) {
  if (!is.character(x)) {
    stop("x must be a character vector", call. = FALSE)
  }
  tb <- table(x)
  if (sort) {
    tb <- rev(sort(tb))
  }
  df <- as_tibble(tb)
  if (prop) {
    df$p <- unclass(prop.table(df$n))
  }
  df
}
