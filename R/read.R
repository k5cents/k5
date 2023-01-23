#' Read a text file without column guessing
#'
#' Use [readr::read_delim()] without specifying _any_ column types. All columns
#' are treated as character strings.
#'
#' @param file Either a path to a file, a connection, or literal data.
#' @param delim Single character used to separate fields within a record.
#' @param ... Additional arguments passed to [readr::read_delim()].
#' @importFrom readr read_csv read_tsv read_delim cols
#' @return A tibble data frame read from the file.
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
  readr::read_delim(
    file = file,
    delim = ",",
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
  readr::read_delim(
    file = file,
    delim = "\t",
    col_types = readr::cols(
      .default = "c"
    ),
    guess_max = 0,
    ...
  )
}

#' Read a table from the clipboard
#'
#' Use [readr::read_delim()] on a string copied to the clipboard. Defaults to
#' tab separator like given when copying cells from spreadsheets.
#'
#' @param delim Single character used to separate fields within a record.
#' @param ... Additional arguments passed to [readr::read_delim()].
#' @importFrom readr read_delim
#' @importFrom clipr read_clip
#' @return A data frame read from the clipboard.
#' @export
read_delim_clip <- function(delim = "\t", ...) {
  readr::read_delim(
    file = I(clipr::read_clip()),
    delim = delim,
    ...
  )
}

#' Write a table from the clipboard
#'
#' Use [readr::format_delim()] on a data frame to copy a string to the
#' clipboard. Defaults to tab separator like given when copying cells from
#' spreadsheets.
#'
#' @param x A data frame to write to clipboard.
#' @param delim Single character used to separate fields within a record.
#' @param ... Additional arguments passed to [readr::format_delim()].
#' @importFrom readr format_delim
#' @importFrom clipr write_clip
#' @return Invisibly, the input data frame.
#' @export
write_delim_clip <- function(x, delim = "\t", ...) {
  clipr::write_clip(
    content = readr::format_delim(
      x = x,
      delim = delim,
      ...
    )
  )
  invisible(x)
}
