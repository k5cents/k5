#' Print All Rows
#'
#' If the object is a tibble, all rows are printed.
#'
#' @param x Object to print, typically a data frame or vector.
#' @export
print_all <- function(x) {
  if (inherits(x, "tbl")) {
    nr <- nrow(x)
    if (nr > getOption("max.print")) {
      sure <- usethis::ui_yeah(
        x = glue::glue("object has {nr} rows, exceededs 'max.print' of {getOption('max.print')}"),
        yes = c("Print All"),
        no = glue::glue("Print Max"),
        n_yes = 1,
        n_no = 1
      )
      if (sure) {
        print(x, n = Inf)
      } else {
        print(x)
      }
    } else {
      print(x, n = Inf)
    }
  }
}
