#' Descriptive statistics for the energy efficiency dataset
#'
#' Computes mean, standard deviation, minimum, and maximum for each
#' numeric column.
#'
#' @param df A validated energy data frame.
#' @return A `data.frame` with columns `Variable`, `Mean`, `SD`, `Min`,
#'   `Max`.
#' @export
descriptive_stats <- function(df) {
  validate_energy_data(df)
  data.frame(
    Variable = names(df),
    Mean = vapply(df, mean, numeric(1)),
    SD = vapply(df, stats::sd, numeric(1)),
    Min = vapply(df, min, numeric(1)),
    Max = vapply(df, max, numeric(1)),
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}

#' Correlation matrix for the continuous variables and responses
#'
#' @param df A validated energy data frame.
#' @param method Correlation method passed to [stats::cor()]. One of
#'   `"pearson"`, `"spearman"`, or `"kendall"`.
#' @return A numeric matrix.
#' @export
correlation_matrix <- function(df, method = "pearson") {
  validate_energy_data(df)
  fc <- feature_categories()
  vars <- c(fc$continuous, fc$responses)
  stats::cor(df[, vars, drop = FALSE], method = method)
}

#' Summary of heating and cooling loads by orientation
#'
#' @param df A validated energy data frame.
#' @return A `data.frame` with mean and standard deviation of both
#'   responses for each orientation level.
#' @export
summary_by_orientation <- function(df) {
  validate_energy_data(df)
  orient_levels <- sort(unique(df$Orientation))
  result <- lapply(orient_levels, function(lvl) {
    subset_df <- df[df$Orientation == lvl, , drop = FALSE]
    data.frame(
      Orientation = lvl,
      MeanHeating = mean(subset_df$HeatingLoad),
      SdHeating = stats::sd(subset_df$HeatingLoad),
      MeanCooling = mean(subset_df$CoolingLoad),
      SdCooling = stats::sd(subset_df$CoolingLoad)
    )
  })
  do.call(rbind, result)
}
