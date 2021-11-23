#' Read a CSV file without column guessing
#'
#' Use [readr::read_csv()] without specifying _any_ column types. All columns
#' are treated as character strings.
#'
#' @param file Either a path to a file, a connection, or literal data.
#' @param ... Additional arguments passed to [readr::read_csv()].
#' @importFrom readr read_csv cols
#' @export
read_csv_dumb <- function(file, ...) {
  readr::read_csv(
    file = file,
    col_types = readr::cols(
      .default = "c"
    ),
    guess_max = 0,
    ...
  )
}
