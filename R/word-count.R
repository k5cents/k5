#' Count file words, lines, and bytes
#'
#' Invoke system tool to print newline, word, and byte counts for each file.
#'
#' One of five options or an empty string (default):
#' 1. "lines" for newline characters (separating lines).
#' 2. "words" for words separated by white space.
#' 3. "chars" for individual characters.
#' 4. "bytes" for total bytes, differs with multibyte characters.
#' 5. "max" for the maximum display width of longest line.
#'
#' @param path Character vector of file paths.
#' @param count The type of element to count, see details.
#' @importFrom utils read.table
#' @return A data frame of counts by file.
#' @export
word_count <- function(path, count = "") {
  if (!find_cmd("wc")) {
    stop("The \"wc\" command is not found")
  }
  opt <- c("lines", "words", "chars", "bytes", "max")
  if (!all(nzchar(count))) {
    count <- opt[1:3]
  }
  if (!all(count %in% opt)) {
    stop("count must be one or more of: lines, words, chars, bytes, max.")
  }
  opt2 <- paste0("--", count)
  out <- system2(
    command = Sys.which("wc"),
    args = c(
      opt2,
      path
    ),
    stdout = TRUE
  )
  if (length(path) > 1) {
    out <- out[-length(out)]
  }
  rx_find <- paste(
    # any sequence of non-space numbers plus last everything
    # indented any number of spaces at the start
    c(" *([^ ]+)", rep("+([^ ]+)", length(opt2) - 1), "+(.*)"),
    collapse = " "
  )
  rx_group <- paste(
    # \\x for all but last, which is quoted
    c(paste0("\\", seq(length(opt2))), sprintf("\"\\%s\"", length(opt2) + 1)),
    collapse = " "
  )
  out <- gsub(
    pattern = rx_find,
    replacement = rx_group,
    x = out
  )
  con <- textConnection(out)
  on.exit(close(con))
  z <- read.table(con, as.is = TRUE, col.names = c(count, "path"))
  z$path <- fs::as_fs_path(z$path)
  if ("bytes" %in% names(z)) {
    z$bytes <- fs::as_fs_bytes(z$bytes)
  }
  tibble::as_tibble(z[, c(length(z), seq(length(z) - 1))])
}

find_cmd <- function(cmd, arg = "--version") {
  cmd_test <- tryCatch(
    expr = system2(Sys.which(cmd), arg, stdout = TRUE, stderr = NULL),
    error = function(e) return(NULL)
  )
  !is.null(cmd_test)
}
