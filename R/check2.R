#' Check an R-package on R-hub, for a CRAN submission
#'
#' Per issue [r-hub/rhub#367](https://github.com/r-hub/rhub/issues/367), this
#' calls [rhub::check_for_cran()] with the `R_COMPILE_AND_INSTALL_PACKAGES`
#' flag set to "always" to avoid package installation issues.
#'
#' @param path Path to a directory containing an R package, or path to source R
#'   package tarball built with R CMD build or `devtools::build()`.
#' @param email Email address to send notification to about the check. It must
#'   be a validated email address, see validate_email(). If NULL, then the email
#'   address of the maintainer is used, as defined in the DESCRIPTION file of
#'   the package.
#' @export
check_for_cran2 <- function(path = ".", email = NULL) {
  if (is_installed("rhub")) {
    rhub::check_for_cran(
      path = path,
      email = email,
      env_vars = c(
        `R_COMPILE_AND_INSTALL_PACKAGES` = "always",
        `_R_CHECK_FORCE_SUGGESTS_` = "true",
        `_R_CHECK_CRAN_INCOMING_USE_ASPELL_` = "true"
      )
    )
  } else {
    stop("The \"rhub\" package is needed to check for CRAN.", call. = FALSE)
  }
}
