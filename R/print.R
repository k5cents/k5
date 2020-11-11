#' Print all rows of elements
#'
#' Print up to the `getOption("max.print")` and ask the user if they want to
#' print more than that. For tibbles and data frames, use [nrow()] rather than
#' [length()].
#'
#' @param x Object to print, typically a data frame or vector.
#' @param ask If the length of `x` exceeds `getOption("max.print")`, should the
#'   user be promoted to print everything. If `FALSE`, the maximum is printed
#'   without double checking; this can be **extremelly** slow.
#' @return The object x (invisibly)
#' @export
print_all <- function(x, ask = TRUE) {
  max <- getOption("max.print", 1000)
  is_tbl <- tibble::is_tibble(x)
  is_df <- is.data.frame(x)
  n <- ifelse(is_tbl | is_df, nrow(x), length(x))
  if (n > max) {
    sure <- !ask
    if (ask && interactive()) {
      sure <- usethis::ui_yeah(
        x = "Length of x exceedes {usethis::ui_code('getOption(\"max.print\")')}",
        yes = glue::glue("Print all: {scales::comma(n)}"),
        no = glue::glue("Print max: {scales::comma(max)}")
      )
    }
    if (sure && is_tbl) {
      print(x, n = Inf)
      return(invisible(x))
    } else if (sure) {
      print(x, max = 99999L)
      return(invisible(x))
    }
  }
  if (is_tbl) {
    print(x, n = max)
  } else if (!is_tbl) {
    print(x, max = max)
  }
}
