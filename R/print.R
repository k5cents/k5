#' Print all rows of elements
#'
#' Print up to the `getOption("max.print")` and ask the user if they want to
#' print more than that. This is most useful when printing tibbles with more
#' than 10 rows but less than `getOption("max.print")`.
#'
#' @param x Object to print, typically a data frame or vector.
#' @param ask If the length of `x` exceeds `getOption("max.print")`, should the
#'   user be promoted confirm their intention to print everything. If `FALSE`,
#'   the maximum is printed without double checking: this can be **extremely**
#'   slow. The 'usethis' package must be installed for interactive confirmation.
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
      if (is_installed("usethis")) {
        sure <- usethis::ui_yeah(
          x = "Length exceedes {usethis::ui_code('getOption(\"max.print\")')}",
          yes = glue::glue(
            "Print {crayon::red('all')}: {prettyNum(n, big.mark = ',')}"
          ),
          no = glue::glue("Print max: {prettyNum(max, big.mark = ',')}")
        )
      } else {
        stop("Package \"usethis\" needed for confirmation", call. = FALSE)
      }
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
    print(x, max = max * 2)
  }
}
