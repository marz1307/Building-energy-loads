#' Plot the distributions of heating and cooling load
#'
#' @param df A validated energy data frame.
#' @return A `ggplot` object faceted by response variable.
#' @export
plot_distributions <- function(df) {
  validate_energy_data(df)
  long_df <- data.frame(
    Load = c(df$HeatingLoad, df$CoolingLoad),
    Type = factor(rep(c("Heating", "Cooling"), each = nrow(df)))
  )
  ggplot2::ggplot(long_df, ggplot2::aes(x = .data$Load, fill = .data$Type)) +
    ggplot2::geom_histogram(bins = 30, alpha = 0.7, colour = "white") +
    ggplot2::facet_wrap(~ .data$Type, scales = "free") +
    ggplot2::labs(
      title = "Heating and cooling load distributions",
      x = "Load (kWh / m^2)",
      y = "Frequency"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none")
}

#' Plot a correlation matrix as a heatmap
#'
#' @param cor_mat A numeric correlation matrix from [correlation_matrix()].
#' @return A `ggplot` object.
#' @export
plot_correlation_heatmap <- function(cor_mat) {
  if (!is.matrix(cor_mat)) {
    stop("`cor_mat` must be a numeric matrix")
  }
  vars <- rownames(cor_mat)
  long <- expand.grid(Var1 = vars, Var2 = vars, KEEP.OUT.ATTRS = FALSE)
  long$Correlation <- as.vector(cor_mat)
  ggplot2::ggplot(
    long,
    ggplot2::aes(x = .data$Var1, y = .data$Var2, fill = .data$Correlation)
  ) +
    ggplot2::geom_tile(colour = "white") +
    ggplot2::geom_text(
      ggplot2::aes(label = sprintf("%.2f", .data$Correlation)), size = 3
    ) +
    ggplot2::scale_fill_gradient2(
      low = "navy", mid = "white", high = "darkred",
      midpoint = 0, limits = c(-1, 1)
    ) +
    ggplot2::labs(
      title = "Correlation heatmap", x = NULL, y = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}

#' Pairwise scatterplot matrix for the continuous variables and responses
#'
#' @param df A validated energy data frame.
#' @param output_path Optional file path to save the plot as PNG.
#' @return Invisible NULL; called for its side effect.
#' @export
plot_pairs <- function(df, output_path = NULL) {
  validate_energy_data(df)
  fc <- feature_categories()
  vars <- c(fc$continuous, fc$responses)
  numeric_df <- df[, vars, drop = FALSE]
  if (!is.null(output_path)) {
    ensure_dir(dirname(output_path))
    grDevices::png(output_path, width = 1000, height = 1000, res = 150)
    on.exit(grDevices::dev.off(), add = TRUE)
  }
  graphics::pairs(
    numeric_df,
    main = "Pairwise scatterplots",
    pch = 19, cex = 0.5,
    col = grDevices::adjustcolor("steelblue", alpha.f = 0.4),
    upper.panel = NULL
  )
  invisible(NULL)
}

#' Plot residual diagnostics for a fitted model
#'
#' @param model An `lm` object.
#' @param output_path Optional file path to save the plot as PNG.
#' @return Invisible NULL; called for its side effect.
#' @export
plot_residuals <- function(model, output_path = NULL) {
  if (!inherits(model, "lm")) {
    stop("`model` must be an lm object")
  }
  if (!is.null(output_path)) {
    ensure_dir(dirname(output_path))
    grDevices::png(output_path, width = 1000, height = 1000, res = 150)
    on.exit(grDevices::dev.off(), add = TRUE)
  }
  graphics::par(mfrow = c(2, 2))
  graphics::plot(model)
  invisible(NULL)
}
