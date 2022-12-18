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
#' @param sum Column to replace with a cumulative sum (`n`, `p`, or `np`).
#' @examples
#' count2(iris, Species)
#' @importFrom tibble as_tibble
#' @return A tibble of element counts
#' @export
count2 <- function(x, ..., wt = NULL, sort = TRUE, prop = TRUE, sum = NULL) {
  if (is.null(wt)) {
    df <- dplyr::count(x = x, ..., sort = sort)
  } else {
    df <- dplyr::count(x = x, ..., wt = wt, sort = sort)
  }
  if (prop) {
    df$p <- prop.table(df$n)
  }
  if (!is.null(sum)) {
    sum <- match.arg(sum, c("n", "p", "np", "pn"))
    if (!prop & grepl(pattern = "p", x = sum)) {
      stop("Summing column `p` but `prop` is FALSE", call. = FALSE)
    }
    sum <- strsplit(sum, "")[[1]]
    df[sum] <- lapply(df[sum], cumsum)
  }
  as_tibble(df)
}

#' @rdname count2
#' @export
count_vec <- function(x, sort = TRUE, prop = TRUE, sum = NULL) {
  stopifnot(is.vector(x))
  tb <- table(x)
  if (sort) {
    tb <- rev(sort(tb))
  }
  df <- as_tibble(tb)
  if (prop) {
    df$p <- unclass(prop.table(df$n))
  }
  if (!is.null(sum)) {
    sum <- match.arg(sum, c("n", "p", "np", "pn"))
    if (!prop & grepl(pattern = "p", x = sum)) {
      stop("Summing column `p` but `prop` is FALSE", call. = FALSE)
    }
    sum <- strsplit(sum, "")[[1]]
    df[sum] <- lapply(df[sum], cumsum)
  }
  df
}
