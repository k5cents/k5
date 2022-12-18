#' File modification date age
#'
#' The period of time since a system file was modified.
#'
#' @param ... Arguments passed to [file.info()], namely character vectors
#'   containing file paths. Tilde-expansion is done: see [path.expand()].
#' @examples
#' file_age(system.file("README.md", package = "campfin"))
#' @importFrom lubridate as.period
#' @return A Period class object.
#' @export
file_age <- function(...) {
  finfo <- file.info(...)
  lubridate::as.period(Sys.time() - finfo$mtime)
}

#' File Encoding
#'
#' Call the `file` command line tool with option `-i`.
#'
#' @param path A local file path or glob to check.
#' @return A tibble of file encoding.
#' @importFrom fs as_fs_path
#' @importFrom tibble tibble
#' @importFrom stringr str_detect str_extract
#' @export
file_encoding <- function(path) {
  if (Sys.info()['sysname'] == "SunOS") {
    stop("file encoding via the command line on Solaris is unreliable")
  }
  enc <- tryCatch(
    expr = system2(Sys.which("file"), args = paste("-i", path), stdout = TRUE),
    error = function(e) return(NULL)
  )
  if (any(stringr::str_detect(enc, "\\(No such file or directory\\)"))) {
    stop("no such file or directory")
  } else {
    tibble::tibble(
      path = fs::as_fs_path(stringr::str_extract(enc, "(.*)(?=:\\s)")),
      mime = stringr::str_extract(enc, "(?<=:\\s)(.*)(?=;)"),
      charset = stringr::str_extract(enc, "(?<=;\\scharset\\=)(.*)")
    )
  }
}
