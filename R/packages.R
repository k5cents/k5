#' Save and load packages from file
#'
#' @param path The path to a text file containing one package per line. If
#'   `NULL` (default), then the default list is read from `k5/inst/PACKAGES`.
#' @param x A character vector of package names to save. If `NULL` (default),
#'   use all currently attached packages.
#' @return The list of packages, invisibly.
#' @export
load_my_packages <- function(path = NULL) {
  if (is.null(path)) {
    path <- system.file("PACKAGES", package = "k5", mustWork = TRUE)
  }
  x <- readLines(path)
  is_loaded <- vapply(x, require_quiet, logical(1))
  x <- x[is_loaded]
  usethis::ui_done("load {length(x)} packages from {usethis::ui_path(path)}")
  invisible(x)
}

#' @rdname load_my_packages
#' @export
save_my_packages <- function(x = NULL, path = tempfile()) {
  if (is.null(path)) {
    path <- system.file("PACKAGES", package = "k5", mustWork = TRUE)
  }
  if (is.null(x)) {
    x <- search()
    x <- sub("^package:", "", x[grepl("^package:", x), drop = FALSE])
  }
  writeLines(x, path)
  usethis::ui_done("saved {length(x)} packages to {usethis::ui_path(path)}")
  invisible(x)
}

require_quiet <- function(...) {
  suppressPackageStartupMessages(require(..., character.only = TRUE))
}
