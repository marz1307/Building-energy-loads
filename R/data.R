#' Canonical column names for the energy efficiency dataset
#'
#' @keywords internal
ENERGY_COLUMNS <- c(
  "RelCompact", "SurfaceArea", "WallArea", "RoofArea",
  "Height", "Orientation", "GlazingArea", "GlazingDist",
  "HeatingLoad", "CoolingLoad"
)

#' Categorical and continuous feature groupings
#'
#' Returns a list with the two feature categories used throughout the
#' analysis pipeline.
#'
#' @return A named list with elements `continuous`, `categorical`, and
#'   `responses`.
#' @export
feature_categories <- function() {
  list(
    continuous = c("RelCompact", "SurfaceArea", "WallArea", "RoofArea"),
    categorical = c("Height", "Orientation", "GlazingArea", "GlazingDist"),
    responses = c("HeatingLoad", "CoolingLoad")
  )
}

#' Load the energy efficiency dataset
#'
#' Reads the canonical Excel file shipped in `data-raw/` and assigns
#' canonical column names. The structure is validated before returning.
#'
#' @param path Path to the `.xlsx` file.
#' @return A `tibble` with 10 columns (see [feature_categories()]).
#' @export
load_energy_data <- function(path) {
  if (!file.exists(path)) {
    stop("Energy data file not found: ", path)
  }
  raw <- readxl::read_excel(path)
  if (ncol(raw) != length(ENERGY_COLUMNS)) {
    stop(
      "Expected ", length(ENERGY_COLUMNS), " columns but found ", ncol(raw)
    )
  }
  colnames(raw) <- ENERGY_COLUMNS
  validate_energy_data(raw)
  tibble::as_tibble(raw)
}

#' Validate an energy efficiency data frame
#'
#' Checks dimensions, column names, types, and missingness.
#'
#' @param df A data frame.
#' @return `TRUE` invisibly if validation passes; otherwise an error.
#' @export
validate_energy_data <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame")
  }
  missing_cols <- setdiff(ENERGY_COLUMNS, colnames(df))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }
  for (col in ENERGY_COLUMNS) {
    if (!is.numeric(df[[col]])) {
      stop("Column '", col, "' must be numeric")
    }
  }
  if (anyNA(df)) {
    stop("Energy data contains missing values")
  }
  invisible(TRUE)
}
