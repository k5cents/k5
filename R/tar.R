#' List tar contents
#'
#' @description
#' [tar_info()] is the equivalent to the `tar -tf` command. It returns a data
#' frame (like [fs::dir_info()]).
#'
#' [tar_ls()] also uses `tar -tf` but only returns the filenames within the
#' archive as a named `fs_path` character vector (like [fs::dir_ls()]).
#'
#' @param path A character vector of tarball archives.
#' @param method The method to be used. Passed to `utils::tar()`. An alternative
#'   is to use `Sys.getenv("TAR")`.
#' @examples
#' # List two files from zip
#' irs <- tempfile(fileext = ".csv")
#' write.csv(iris, irs)
#' mtc <- tempfile(fileext = ".csv")
#' write.csv(mtcars, mtc)
#' txz <- tempfile(fileext = ".tar")
#' tar_create(c(irs, mtc), txz)
#' tar_size(txz)
#' tar_info(txz)
#' tar_ls(txz)
#' @importFrom fs path_real as_fs_path as_fs_bytes
#' @importFrom utils unzip
#' @importFrom tibble as_tibble
#' @export
tar_info <- function(path, method = Sys.getenv("TAR")) {
  path <- fs::path_real(path)
  z <- mapply(
    FUN = tar_verb, tarfile = path,
    SIMPLIFY = FALSE, USE.NAMES = TRUE,
    MoreArgs = list(tar = method)
  )
  z <- do.call(what = "rbind", args = z)
  tibble::as_tibble(z)
}

#' @importFrom utils read.table
tar_verb <- function(tarfile, tar = Sys.getenv("TAR")) {
  # modified from utils::unzip
  res <- utils::untar(tarfile = tarfile, list = TRUE, extras = "-v", tar = tar)
  res <- c("permissions user group size date time path", res)
  res <- gsub(
    pattern = "(?<=\\w)(/)(?=\\w)",
    replacement = " ",
    x = res, perl = TRUE
  )
  res2 <- gsub(
    pattern = " *([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +(.*)",
    replacement = "\\1 \\2 \\3 \\4 \\5 \\6 \"\\7\"",
    x = res
  )
  con <- textConnection(res2)
  on.exit(close(con))
  z <- utils::read.table(con, header = TRUE, as.is = TRUE)
  dt <- paste(z$date, z$time)
  formats <- if (max(nchar(z$date) > 8)) {
    c("%Y-%m-%d", "%d-%m-%Y", "%m-%d-%Y")
  } else {
    c("%m-%d-%y", "%d-%m-%y", "%y-%m-%d")
  }
  slash <- any(grepl("/", z$date))
  if (slash) {
    formats <- gsub("-", "/", formats)
  }
  formats <- paste(formats, "%H:%M")
  for (f in formats) {
    zz <- as.POSIXct(dt, tz = "UTC", format = f)
    if (all(!is.na(zz))) {
      break
    }
  }
  z[, "modification_time"] <- zz
  z[, "permissions"] <- fs::as_fs_perms(substr(z[, "permissions"], 2, 99))
  z[, "size"] <- fs::as_fs_bytes(z[, "size"])
  z[, "path"] <- fs::as_fs_path(z[, "path"])
  tibble::as_tibble(z[, c(7, 4, 1, 8, 2:3)])
}

#' @rdname tar_info
#' @export
tar_ls <- function(path, method = "internal") {
  path <- fs::path_real(path)
  z <- mapply(
    FUN = utils::untar, tarfile = path,
    SIMPLIFY = FALSE, USE.NAMES = TRUE,
    MoreArgs = list(list = TRUE)
  )
  z <- do.call(what = "rbind", args = z)
  fs::as_fs_path(z)
}

#' @rdname tar_info
#' @param sum If `TRUE` (default) the summed size of archive contents is
#'   returned invisibly and a message comparing sizes is printed. If `FALSE`,
#'   the uncompressed size of all contents is returned as a numeric `fs_bytes`
#'   vector.
#' @export
tar_size <- function(path, sum = TRUE, method = "tar") {
  b <- tar_info(path, method = method)
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
#' @param dir The directory to extract files to (the equivalent of `tar -C`).
#'   It will be created if necessary with [dir_create()].
#' @param files A character vector of paths to be extracted: the default is to
#'   extract all files. Use [tar_ls()] to list contents without extracting.
#' @param junk If `FALSE` (default), preserve the directories of compressed
#'   files. If `TRUE`, use only the basename of the stored path when extracting;
#'   forward slashes in the tarball contents are counted and the maximum amount
#'   are passed to `tar --strip-components`.
#' @param method The method to be used.
#' @return The path to the extracted files (invisibly).
#' @examples
#' # Extract two files from tarball
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(iris, tmp)
#' txz <- tar_create(tmp)
#' out <- tar_move(txz, dir = tempdir())
#' file.size(c(tmp, txz, out))
#' @importFrom fs path_real dir_create as_fs_path
#' @importFrom utils unzip
#' @export
tar_move <- function(path, dir = NULL, files = NULL, junk = TRUE,
                     method = "tar") {
  if (is.null(dir) | length(dir) > 1) {
    stop("one destination directory must be specified")
  }
  path <- fs::path_real(path)
  dir <- fs::path_expand(dir)
  if (!fs::dir_exists(dir)) {
    fs::dir_create(dir)
    usethis::ui_done("{usethis::ui_path(dir)} created")
  }
  if (junk) {
    loc <- gregexpr(pattern = "/", text = tar_ls(path), fixed = TRUE)
    strip <- max(sapply(loc, function(x) length(attr(x, "match.length"))))
    extra <- paste("--strip-components", strip)
  } else {
    extra <- ""
  }
  z <- mapply(
    FUN = utils::untar, tarfile = path,
    SIMPLIFY = TRUE, USE.NAMES = TRUE,
    MoreArgs = list(
      files = files, exdir = dir, tar = method, extra = extra
    )
  )
  invisible(fs::path(dir, path))
}

#' Create tar archive
#'
#' A wrapper for an external `tar` command to create tar archives. Unlike
#' [utils::tar()], filepaths can be passed into the first argument with `%>%`.
#'
#' @param path A character vector of files to archive.
#' @param tar The path of the tarball file to create. If none is supplied, and
#'   only one path is, an archive with that [basename()] will be created in the
#'   same directory.
#' @param compress Character string giving the type of compression to be used.
#' @param level Integer compression level used with internal method, 1-9.
#' @param extra An optional character vector passed to [system()] as arguments
#'   of the external `tar` command.
#' @param method A character string specifying the external command to be used.
#' @return The path of the created archive (invisibly).
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Tar a file to same basename
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(iris, tmp)
#' (txz <- tar_create(tmp))
#' file.size(c(tmp, txz))
#' \dontshow{setwd(.old_wd)}
#' @importFrom fs path_real path_ext_set path_expand
#' @importFrom utils tar
#' @export
tar_create <- function(path, tar = NULL,
                       compress = c("xz", "gzip", "bzip2", "none"), level = 6,
                       extra = "", method = "tar") {
  path <- fs::path_real(path)
  compress <- match.arg(compress, c("xz", "gzip", "bzip2", "none"))
  if (is.null(tar) && length(path) == 1) {
    tar <- fs::path_ext_set(path, "tar")
    c <- switch(compress,
      xz = ".xz", gzip = ".gz",
      bzip2 = ".bz2", none = ""
    )
    tar <- fs::as_fs_path(paste0(tar, c))
  } else {
    tar <- fs::path_expand(tar)
  }
  utils::tar(tarfile = tar, files = path, compression = compress,
             compression_level = level, tar = method, extra = extra)
  invisible(tar)
}
