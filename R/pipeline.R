#' Run the full energy efficiency analysis pipeline
#'
#' Loads the dataset, computes descriptive statistics and correlations,
#' fits stepwise regression models for heating and cooling load, runs
#' diagnostics, and writes plots to `output_dir`.
#'
#' @param input_path Path to the energy efficiency `.xlsx` file.
#' @param output_dir Directory in which plots and CSV summaries are saved.
#' @return A list containing the loaded data, descriptive statistics,
#'   correlation matrix, fitted models, and diagnostic results.
#' @export
run_full_analysis <- function(input_path, output_dir = "output") {
  log_msg <- get_logger("pipeline")
  ensure_dir(output_dir)

  log_msg("Loading data")
  df <- load_energy_data(input_path)

  log_msg("Computing descriptive statistics")
  desc <- descriptive_stats(df)
  utils::write.csv(
    desc,
    file = file.path(output_dir, "descriptive_stats.csv"),
    row.names = FALSE
  )

  log_msg("Computing correlation matrix")
  cor_mat <- correlation_matrix(df)
  utils::write.csv(
    cor_mat,
    file = file.path(output_dir, "correlation_matrix.csv")
  )

  log_msg("Plotting distributions and correlations")
  ggplot2::ggsave(
    file.path(output_dir, "distributions.png"),
    plot = plot_distributions(df), width = 10, height = 5, dpi = 150
  )
  ggplot2::ggsave(
    file.path(output_dir, "correlation_heatmap.png"),
    plot = plot_correlation_heatmap(cor_mat),
    width = 8, height = 7, dpi = 150
  )
  plot_pairs(df, file.path(output_dir, "pairs.png"))

  log_msg("Fitting heating load model")
  heat_model <- fit_heating_load_model(df)

  log_msg("Fitting cooling load model")
  cool_model <- fit_cooling_load_model(df)

  log_msg("Running model diagnostics")
  diagnostics <- list(
    heating_vif = vif_check(heat_model),
    heating_normality = normality_test(heat_model),
    heating_heteroscedasticity = heteroscedasticity_test(heat_model),
    cooling_vif = vif_check(cool_model),
    cooling_normality = normality_test(cool_model),
    cooling_heteroscedasticity = heteroscedasticity_test(cool_model)
  )
  plot_residuals(heat_model, file.path(output_dir, "heating_residuals.png"))
  plot_residuals(cool_model, file.path(output_dir, "cooling_residuals.png"))

  log_msg("Pipeline complete")
  list(
    data = df,
    descriptive_stats = desc,
    correlation_matrix = cor_mat,
    heating_model = heat_model,
    cooling_model = cool_model,
    diagnostics = diagnostics
  )
}
