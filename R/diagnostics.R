#' Variance inflation factors for a fitted model
#'
#' @param model An `lm` object.
#' @return A named numeric vector (or matrix for factor predictors) of
#'   VIF values.
#' @export
vif_check <- function(model) {
  if (!inherits(model, "lm")) {
    stop("`model` must be an lm object")
  }
  car::vif(model)
}

#' Shapiro-Wilk normality test on model residuals
#'
#' For samples larger than 5000 the residuals are randomly subsampled
#' (with a fixed seed) so the test can be applied.
#'
#' @param model An `lm` object.
#' @return A list with `statistic`, `p_value`, and `n` elements.
#' @export
normality_test <- function(model) {
  if (!inherits(model, "lm")) {
    stop("`model` must be an lm object")
  }
  res <- stats::resid(model)
  set.seed(42)
  sample_size <- min(length(res), 5000)
  sampled <- if (length(res) > sample_size) sample(res, sample_size) else res
  test <- stats::shapiro.test(sampled)
  list(
    statistic = unname(test$statistic),
    p_value = test$p.value,
    n = sample_size
  )
}

#' Breusch-Pagan style heteroscedasticity check
#'
#' Regresses squared residuals on the model's fitted values and reports
#' the F-test p-value.
#'
#' @param model An `lm` object.
#' @return A list with `statistic`, `p_value`, and `df` elements.
#' @export
heteroscedasticity_test <- function(model) {
  if (!inherits(model, "lm")) {
    stop("`model` must be an lm object")
  }
  fitted_vals <- stats::fitted(model)
  squared_res <- stats::resid(model)^2
  aux <- stats::lm(squared_res ~ fitted_vals)
  fstat <- summary(aux)$fstatistic
  list(
    statistic = unname(fstat[1]),
    p_value = stats::pf(fstat[1], fstat[2], fstat[3], lower.tail = FALSE),
    df = c(unname(fstat[2]), unname(fstat[3]))
  )
}
