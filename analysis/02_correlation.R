# Correlation analysis driver
# Run with: Rscript analysis/02_correlation.R
suppressPackageStartupMessages(library(energyEfficiency))

INPUT_PATH <- file.path("data-raw", "Energy_Efficiency_Data.xlsx")
OUTPUT_DIR <- file.path("output", "correlation")
ensure_dir(OUTPUT_DIR)

df <- load_energy_data(INPUT_PATH)
cor_mat <- correlation_matrix(df, method = "pearson")
write.csv(cor_mat, file.path(OUTPUT_DIR, "correlation_matrix.csv"))

ggplot2::ggsave(
  file.path(OUTPUT_DIR, "correlation_heatmap.png"),
  plot = plot_correlation_heatmap(cor_mat),
  width = 8, height = 7, dpi = 150
)

plot_pairs(df, file.path(OUTPUT_DIR, "pairs.png"))

message("Correlation outputs written to ", OUTPUT_DIR)
