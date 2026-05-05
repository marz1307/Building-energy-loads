# Exploratory data analysis driver
# Run with: Rscript analysis/01_eda.R
suppressPackageStartupMessages(library(energyEfficiency))

INPUT_PATH <- file.path("data-raw", "Energy_Efficiency_Data.xlsx")
OUTPUT_DIR <- file.path("output", "eda")
ensure_dir(OUTPUT_DIR)

df <- load_energy_data(INPUT_PATH)

desc <- descriptive_stats(df)
write.csv(desc, file.path(OUTPUT_DIR, "descriptive_stats.csv"), row.names = FALSE)
print(knitr::kable(desc, digits = 2, caption = "Descriptive statistics"))

ggplot2::ggsave(
  file.path(OUTPUT_DIR, "distributions.png"),
  plot = plot_distributions(df),
  width = 10, height = 5, dpi = 150
)

orient_summary <- summary_by_orientation(df)
write.csv(
  orient_summary,
  file.path(OUTPUT_DIR, "summary_by_orientation.csv"),
  row.names = FALSE
)

message("EDA outputs written to ", OUTPUT_DIR)
