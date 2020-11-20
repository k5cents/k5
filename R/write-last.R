#' Write the last value to disk
#'
#' The value of the internal evaluation of a top-level R expression is always
#' assigned to `.Last.value` before further processing (e.g., printing).
#'
#' Four types of files are written, based on object class:
#' 1. For data frames, a tab-separated file via [readr::write_tsv()].
#' 2. For vectors, a newline-separated file via [readr::write_lines()].
#' 3. For ggplots, a raster image (by default) via [ggplot2::ggsave()].
#' 4. For other objects, an uncompressed data file via [readr::write_rds()].
#' @param file File or connection to write to.
#' @param x The object to write, usually left as [base::.Last.value].
#' @param ... Additional arguments passed to the writing function (see Details).
#' @return The created file path, invisibly.
#' @importFrom fs as_fs_path path_ext path_ext_set
#' @importFrom ggplot2 ggsave is.ggplot
#' @importFrom readr write_tsv write_lines write_rds
#' @importFrom usethis ui_info ui_done ui_path ui_field ui_stop
#' @importFrom utils hasName capture.output
#' @export
write_last <- function(file = tempfile(), x = .Last.value, ...) {
  y <- x
  no_ext <- !nzchar(fs::path_ext(file))
  usethis::ui_info("{usethis::ui_code('.Last.value')} has class \\
                    {usethis::ui_value(class(x))}")
  if (ggplot2::is.ggplot(y)) {
    if (no_ext) {
      dots <- list()
      file <- fs::path_ext_set(
        path = file,
        ext = ifelse(
          test = hasName(dots, "device") && is.character(dots$device),
          yes = dots$device, no = "png"
        )
      )
    }
    d <- capture.output(ggplot2::ggsave(file, plot = y, ...), type = "message")
    d <- ifelse(length(d) > 0, sub("image", "", substr(d, 8, 99)), "")
    usethis::ui_done(
      "Saved {d}{usethis::ui_field('image')} file {usethis::ui_path(file)}"
    )
    return(invisible(fs::as_fs_path(file)))
  } else if (is.data.frame(y)) {
    file <- fs::path_ext_set(file, "tsv")
    readr::write_tsv(y, file, ...)
    type <- "tab-separated"
  } else if (is.vector(y) && !is.list(y)) {
    file <- fs::path_ext_set(file, "txt")
    readr::write_lines(y, file, ...)
    type <- "line-separated"
  } else if (is.function(y)) {
    file <- fs::path_ext_set(file, "R")
    y <- capture.output(y)
    readr::write_lines(y[-length(y)], file)
    type <- "source code"
  } else {
    file <- fs::path_ext_set(file, "rds")
    readr::write_rds(y, file, ...)
    type <- "binary"
    usethis::ui_oops(
      "Class {usethis::ui_value(class(x))} has no plain text format"
    )
  }
  if (fs::file_exists(file)) {
    usethis::ui_done(
      "Saved {usethis::ui_field(type)} file {usethis::ui_path(file)} \\
      ({fs::file_size(file)})"
    )
  } else {
    usethis::ui_stop(
      "Failed to save file {usethis::ui_path(file)}"
    )
  }
  invisible(fs::as_fs_path(file))
}

#' @rdname write_last
#' @export
save_last <- function(file = tempfile(), x = .Last.value, ...) {
  y <- x
  usethis::ui_info("{usethis::ui_code('.Last.value')} has class \\
                   {usethis::ui_value(class(x))}")
  file <- fs::path_ext_set(file, "rds")
  readr::write_rds(y, file, ...)
  if (fs::file_exists(file)) {
    usethis::ui_done(
      "Saved {usethis::ui_field('binary')} file {usethis::ui_path(file)} \\
      ({fs::file_size(file)})"
    )
  } else {
    usethis::ui_stop(
      "Failed to save file {usethis::ui_path(file)}"
    )
  }
  invisible(fs::as_fs_path(file))
}
