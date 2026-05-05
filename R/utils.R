#' Utility helpers for the energyEfficiency package
#'
#' @keywords internal
#' @name utils
NULL

#' Ensure that a directory exists
#'
#' Creates the directory recursively if it does not already exist.
#'
#' @param path Character path to the directory.
#' @return The (normalised) path, invisibly.
#' @export
ensure_dir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(normalizePath(path, winslash = "/", mustWork = FALSE))
}

#' Lightweight logger
#'
#' Returns a function that prefixes messages with a timestamp and a label.
#'
#' @param label Character label included in each log line.
#' @return A function accepting a single character message.
#' @export
get_logger <- function(label = "energyEfficiency") {
  function(msg) {
    ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    message(sprintf("[%s] %s: %s", ts, label, msg))
  }
}
