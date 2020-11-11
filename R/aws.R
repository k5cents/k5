#' List all objects in an AWS bucket
#'
#' Uses [aws.s3::get_bucket_df()] styled as an 'fs' data frame.
#'
#' @param bucket Character string with the name of the bucket, or an object of
#'   class “s3_bucket”.
#' @param prefix Character string that limits the response to keys that begin
#'   with the specified prefix.
#' @param ... Additional arguments passed to [aws.s3::s3HTTP()].
#' @importFrom aws.s3 get_bucket_df
#' @importFrom fs as_fs_path as_fs_bytes
#' @importFrom readr parse_datetime
#' @importFrom tibble as_tibble
#' @export
aws_ls <- function(bucket = getOption("bucket"), prefix = NULL, ...) {
  stopifnot(!is.null(bucket))
  z <- aws.s3::get_bucket_df(bucket = bucket, prefix = prefix, ...)
  z$path <- fs::as_fs_path(z$Key)
  z$size <- fs::as_fs_bytes(z$Size)
  z$time <- readr::parse_datetime(z$LastModified)
  tibble::as_tibble(z[, c("path", "size", "time")])
}
