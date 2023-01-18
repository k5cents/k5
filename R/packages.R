#' Save and load packages from file
#'
#' @param path The path to a text file containing package names. If `NULL`
#'   (default), then the default list is read from `k5/inst/PACKAGES`.
#' @param install If `TRUE`, install missing packages.
#' @param x A character vector of package names to save. If `NULL` (default),
#'   use all currently attached packages.
#' @return The list of packages, invisibly.
#' @export
load.packages <- function(path = NULL, install = FALSE) {
  if (is.null(path)) {
    path <- system.file("PACKAGES", package = "k5", mustWork = TRUE)
  }
  x <- readLines(path)
  if (isFALSE(install)) {
    x <- x[vapply(x, is_installed, logical(1))]
  }
  pacman::p_load(char = x)
  usethis::ui_done("load {length(x)} packages from {usethis::ui_path(path)}")
  invisible(x)
}

#' @rdname load.packages
#' @export
save.packages <- function(x = NULL, path = tempfile()) {
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
