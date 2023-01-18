#' List all objects in an AWS bucket
#'
#' @description
#' [aws_info()] uses [aws.s3::get_bucket_df()] to return a tibble of stored
#' objects in a remote bucket, like [fs::dir_info()] returns information on a
#' local directory.
#'
#' [aws_ls()] also uses [aws.s3::get_bucket_df()] but only returns the filenames
#' within the bucket as a named `fs_path` character vector, like
#' [fs::dir_ls()]) returns files in a local directory.
#'
#' @param bucket Character string with the name of the bucket. If you use the
#'   same bucket frequently, you can set a default through an option named
#'   that can be retrieved with [aws_bucket()].
#' @param prefix Character string that limits the response to keys that begin
#'   with the specified prefix.
#' @param max Number of objects to return.
#' @param ... Additional arguments passed to [aws.s3::s3HTTP()].
#' @examples
#' aws_info("1000genomes", max = 10)
#' aws_ls("irs-form-990", max = 1)
#' @importFrom aws.s3 get_bucket_df
#' @importFrom fs as_fs_path as_fs_bytes
#' @importFrom readr parse_datetime
#' @importFrom tibble as_tibble
#' @return A list of objects on the AWS bucket.
#' @export
aws_info <- function(bucket = aws_bucket(), prefix = NULL, max = Inf, ...) {
  stopifnot(!is.null(bucket))
  z <- aws.s3::get_bucket_df(bucket = bucket, prefix = prefix, max = max, ...)
  z$path <- fs::as_fs_path(z$Key)
  z$type <- ifelse(z$Size == 0, 2L, 5L)
  z$type <- factor(z$type, levels = file_types, labels = names(file_types))
  z$size <- fs::as_fs_bytes(z$Size)
  z$time <- readr::parse_datetime(z$LastModified)
  tibble::as_tibble(z[, c("path", "type", "size", "time")])
}

#' @rdname aws_info
#' @export
aws_ls <- function(bucket = aws_bucket(), prefix = NULL, ...) {
  z <- aws.s3::get_bucket_df(bucket = bucket, prefix = prefix, ...)
  fs::as_fs_path(z$Key)
}

#' @rdname aws_info
#' @param set If `TRUE`, print instructions for setting the option.
#' @importFrom usethis ui_code ui_code_block ui_path ui_todo
#' @export
aws_bucket <- function(bucket = getOption("aws.bucket"), set = FALSE) {
  if (set) {
    usethis::ui_todo("Call {usethis::ui_code('usethis::edit_r_profile()')} \\
                     to open {usethis::ui_path('.Rprofile')}.")
    usethis::ui_todo("Set your option on start-up with a line like:")
    usethis::ui_code_block("options(aws.bucket = \"{bucket}\")")
    invisible(getOption("aws.bucket", bucket))
  } else {
    getOption("aws.bucket", bucket)
  }
}

file_types <- c(
  "any" = -1,
  "block_device" = 0L,
  "character_device" = 1L,
  "directory" = 2L,
  "FIFO" = 3L,
  "symlink" = 4L,
  "file" = 5L,
  "socket" = 6L
)
