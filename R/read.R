#' Read a text file without column guessing
#'
#' Use [readr::read_delim()] without specifying _any_ column types. All columns
#' are treated as character strings.
#'
#' @param file Either a path to a file, a connection, or literal data.
#' @param delim Single character used to separate fields within a record.
#' @param ... Additional arguments passed to [readr::read_csv()].
#' @importFrom readr read_csv read_tsv read_delim cols
#' @export
read_delim_dumb <- function(file, delim = c(",", "\t", "|"), ...) {
  readr::read_delim(
    file = file,
    delim = delim,
    col_types = readr::cols(
      .default = "c"
    ),
    guess_max = 0,
    ...
  )
}

#' @rdname read_delim_dumb
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

#' @rdname read_delim_dumb
#' @export
read_tsv_dumb <- function(file, ...) {
  readr::read_tsv(
    file = file,
    col_types = readr::cols(
      .default = "c"
    ),
    guess_max = 0,
    ...
  )
}


