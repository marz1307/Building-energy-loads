#' Canonical model formulae used throughout the analysis
#'
#' @export
MODEL_FORMULAE <- list(
  heating_simple = stats::as.formula("HeatingLoad ~ RelCompact"),
  heating_full = stats::as.formula(
    paste(
      "HeatingLoad ~ RelCompact + SurfaceArea * WallArea + RoofArea +",
      "factor(Height) + factor(Orientation) +",
      "factor(GlazingArea) + factor(GlazingDist)"
    )
  ),
  cooling_full = stats::as.formula(
    paste(
      "CoolingLoad ~ RelCompact + SurfaceArea + WallArea + RoofArea +",
      "factor(Height) + factor(Orientation) +",
      "factor(GlazingArea) + factor(GlazingDist)"
    )
  )
)

#' Fit a stepwise heating load model
#'
#' Fits the full heating model formula and applies bidirectional stepwise
#' selection by AIC.
#'
#' @param df A validated energy data frame.
#' @return An `lm` model object.
#' @export
fit_heating_load_model <- function(df) {
  validate_energy_data(df)
  set.seed(42)
  full_model <- stats::lm(MODEL_FORMULAE$heating_full, data = df)
  stats::step(full_model, direction = "both", trace = 0)
}

#' Fit a stepwise cooling load model
#'
#' @param df A validated energy data frame.
#' @return An `lm` model object.
#' @export
fit_cooling_load_model <- function(df) {
  validate_energy_data(df)
  set.seed(42)
  full_model <- stats::lm(MODEL_FORMULAE$cooling_full, data = df)
  stats::step(full_model, direction = "both", trace = 0)
}
