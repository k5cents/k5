#' Apply a statistic function to all variables
#'
#' Apply either [count_na()] or [dplyr::n_distinct()] to every column of a data
#' frame and return the count and share of total values (either proportion
#' missing or proportion distinct).
#'
#' @param df A data frame to glimpse.
#' @return Invisibly, a table of statistics by column of a data frame.
#' @examples
#' var_missing(dplyr::storms)
#' var_distinct(dplyr::storms)
#' @importFrom purrr map
#' @importFrom dplyr mutate select
#' @importFrom tibble enframe
#' @importFrom rlang as_label .data
#' @export
var_missing <- function(df) {
  var_stats(df = df, fun = count_na)
}

#' @rdname var_missing
#' @export
var_distinct <- function(df) {
  var_stats(df = df, fun = dplyr::n_distinct)
}

var_stats <- function(df, fun) {
  if (!inherits(fun, "function")) {
    stop("The fun argument must be a function.")
  }
  if (!inherits(df, "data.frame")) {
    stop("The data argument must be a data frame or similar.")
  }
  stats <- unlist(purrr::map(df, fun))
  if (!is.numeric(stats) | length(stats) != ncol(df)) {
    stop("The return of fun must be numeric length one.")
  }
  summary <- stats %>%
    tibble::enframe(name = "var", value = "n") %>%
    dplyr::mutate(p = .data$n / nrow(df)) %>%
    dplyr::mutate(class = purrr::map_chr(df, rlang::as_label)) %>%
    dplyr::select(.data$var, .data$class, .data$n, .data$p)
  print(summary, n = length(df))
  invisible(summary)
}
