#' List zip contents
#'
#' @description
#' [zip_info()] is the equivalent to the `unzip -l` command. It returns a data
#' frame (like [fs::dir_info()]).
#'
#' [zip_ls()] also uses `unzip -l` but only returns the filenames within the
#' archive as a named `fs_path` character vector (like [fs::dir_ls()]).
#'
#' @param path A character vector of zip archives.
#' @param method The method to be used. Passed to `utils::unizp()`. An
#'   alternative is to use `getOption("unzip")`.
#' @examples
#' # List two files from zip
#' irs <- tempfile(fileext = ".csv")
#' write.csv(iris, irs)
#' mtc <- tempfile(fileext = ".csv")
#' write.csv(mtcars, mtc)
#' zzp <- tempfile(fileext = ".zip")
#' zip_create(c(irs, mtc), zzp, junk = TRUE)
#' zip_size(zzp)
#' zip_info(zzp)
#' zip_ls(zzp)
#' @importFrom fs path_real as_fs_path as_fs_bytes
#' @importFrom utils unzip
#' @importFrom tibble as_tibble
#' @export
zip_info <- function(path, method = "internal") {
  path <- fs::path_real(path)
  z <- mapply(
    FUN = utils::unzip, zipfile = path,
    SIMPLIFY = FALSE, USE.NAMES = TRUE,
    MoreArgs = list(list = TRUE)
  )
  z <- do.call(what = "rbind", args = z)
  names(z)[1:3] <- c("path", "size", "date")
  z$path <- fs::as_fs_path(z$path)
  z$size <- fs::as_fs_bytes(z$size)
  tibble::as_tibble(z)
}

#' @rdname zip_info
#' @export
zip_ls <- function(path, method = "internal") {
  path <- fs::path_real(path)
  z <- mapply(
    FUN = utils::unzip, zipfile = path,
    SIMPLIFY = FALSE, USE.NAMES = TRUE,
    MoreArgs = list(list = TRUE)
  )
  z <- do.call(what = "rbind", args = z)
  fs::as_fs_path(z$Name)
}

#' @rdname zip_info
#' @param sum If `TRUE` (default) the summed size of archive contents is
#'   returned invisibly and a message comparing sizes is printed. If `FALSE`,
#'   the uncompressed size of all contents is returned as a numeric `fs_bytes`
#'   vector.
#' @export
zip_size <- function(path, sum = TRUE, method = "internal") {
  b <- zip_info(path, method = method)
  c <- fs::file_size(path)
  d <- sum(b$size)
  if (sum) {
    diff <- scales::percent(c/d, 0.01)
    cat(glue::glue("deflated: {d}, compressed: {c} ({diff})"))
    return(invisible(c))
  } else {
    b$size
  }
}

#' Extract zip contents
#'
#' Decompress the contents of a zip archive and extract them to a single
#' directory so they can be read. Compared to [utils::unzip()], a directory
#' _must_ be provided in the `dir` directory; files are not automatically
#' extracted to the current working directory. New file paths are returned
#' invisibly.
#'
#' @param path A character vector of zip archives.
#' @param dir The directory to extract files to (the equivalent of `unzip -d`).
#'   It will be created if necessary with [dir_create()].
#' @param files A character vector of paths to be extracted: the default is to
#'   extract all files. Use [zip_ls()] to list contents without extracting.
#' @param overwrite If `TRUE` (default), overwrite existing files (the
#'   equivalent of `unzip -o`), otherwise ignore such files (the equivalent of
#'   `unzip -n`).
#' @param junk If `FALSE` (default), preserve the directories of compressed
#'   files. If `TRUE`, use only the basename of the stored path when extracting
#'   (the equivalent of `unzip -j`).
#' @param method The method to be used. An alternative is to use
#'   `getOption("unzip")`, which on a Unix-alike may be set to the path to a
#'   unzip program.
#' @return The path to the extracted files (invisibly).
#' @examples
#' # Extract two files from zip
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(iris, tmp)
#' zip <- zip_create(tmp, junk = TRUE)
#' out <- zip_move(zip, dir = tempdir())
#' file.size(c(tmp, zip, out))
#' @importFrom fs path_real dir_create as_fs_path
#' @importFrom utils unzip
#' @export
zip_move <- function(path, dir = NULL, files = NULL, overwrite = TRUE,
                     junk = FALSE, method = "internal") {
  if (is.null(dir) | length(dir) > 1) {
    stop("one destination directory must be specified")
  }
  path <- fs::path_real(path)
  dir <- fs::dir_create(dir)
  z <- mapply(
    FUN = utils::unzip, zipfile = path,
    SIMPLIFY = TRUE, USE.NAMES = TRUE,
    MoreArgs = list(
      files = files, overwrite = overwrite,
      junkpaths = junk, exdir = dir, unzip = method
    )
  )
  invisible(fs::as_fs_path(z))
}

#' Create zip archive
#'
#' A wrapper for an external `zip` command to create zip archives. Unlike
#' [utils::zip()], filepaths can be passed into the first argument with `%>%`.
#'
#' @param path A character vector of files to archive.
#' @param zip The path of the zip file to create. If none is supplied, and only
#'   one path is, an archive with that [basename()] will be created in the same
#'   directory.
#' @param quiet If `TRUE`, suppress deflating messages (the equivalent of
#'   `zip -q`).
#' @param junk If `TRUE`, use only the basename of the path when creating the
#'   archive (the equivalent of `zip -j`).
#' @param extra An optional character vector passed to [system()] as arguments
#'   of the external `zip` command (e.g., `-x` followed by paths to exclude).
#' @param method A character string specifying the external command to be used.
#' @return The path of the created archive (invisibly).
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Zip a file to same basename
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(iris, tmp)
#' (zip <- zip_create(tmp))
#' file.size(c(tmp, zip))
#' \dontshow{setwd(.old_wd)}
#' @importFrom fs path_real path_ext_set path_expand
#' @importFrom utils zip
#' @export
zip_create <- function(path, zip = NULL, quiet = TRUE, junk = FALSE,
                       extra = "", method = Sys.getenv("R_ZIPCMD", "zip")) {
  path <- fs::path_real(path)
  if (is.null(zip) && length(path) == 1) {
    zip <- fs::path_ext_set(path, "zip")
  } else {
    zip <- fs::path_expand(zip)
  }
  x <- c("-j", "-q")[c(junk, quiet)]
  utils::zip(zipfile = zip, files = path, zip = method, extra = c(extra, x))
  invisible(zip)
}

#' Get path to k5 example
#'
#' k5 comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access. The two files are regular
#' and compressed versions of a delimited file containing the mtcars data.
#'
#' @param zip If `TRUE` (default), the path to the compressed version is
#'   returned. If `FALSE`, the uncompressed version. If `NULL`, the example
#'   file names (not paths) will be listed.
#' @examples
#' zip_example()
#' zip_example(NULL)
#' @return If `zip` is not `NULL`, the `fs_path` to the system file.
#' @export
zip_example <- function(zip = TRUE) {
  out <- if (is.null(zip)) {
    dir(system.file("extdata", package = "k5"))
  } else if (zip) {
    system.file("extdata", "mtcars.csv.zip", package = "k5", mustWork = TRUE)
  } else {
    system.file("extdata", "mtcars.csv", package = "k5", mustWork = TRUE)
  }
  fs::as_fs_path(out)
}
