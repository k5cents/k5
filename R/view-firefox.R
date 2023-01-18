#' View an HTML document in Firefox
#'
#' Take an XML document object, write to an HTML file, and open in Firefox.
#'
#' @param html An object which has the class `xml_document`, often from rvest.
#' @return The html object, invisibly.
#' @export
view_firefox <- function(html) {
  stopifnot(inherits(html, "xml_document"))
  stopifnot(nzchar(Sys.which("firefox")))
  tmp <- tempfile(fileext = ".html")
  txt <- as.character(html)
  writeLines(txt, tmp)
  system2(
    command = Sys.which("firefox"),
    args = tmp
  )
  invisible(html)
}
