#' Filter a data frame by a regular expression
#'
#' A shortcut for `dat %>% filter(str_detect(column, "\\d"))`.
#'
#' @param dat A data frame with a character column to filter.
#' @param col The column containing a character vector to input.
#' @param pattern Pattern to look for..
#' @param ... Additional arguments passed to [stringr::str_detect()].
#' @return A subset of rows from `dat`.
#' @importFrom dplyr filter
#' @importFrom stringr str_detect
#' @export
filter_rx <- function(dat, col, pattern, ...) {
  stopifnot(is.data.frame(dat))
  dplyr::filter(dat, stringr::str_detect({{ col }}, pattern, ...))
}
