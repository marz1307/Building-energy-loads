# Regression and diagnostics driver
# Run with: Rscript analysis/03_regression.R
suppressPackageStartupMessages(library(energyEfficiency))

INPUT_PATH <- file.path("data-raw", "Energy_Efficiency_Data.xlsx")
OUTPUT_DIR <- file.path("output", "regression")
ensure_dir(OUTPUT_DIR)

df <- load_energy_data(INPUT_PATH)

heat_model <- fit_heating_load_model(df)
cool_model <- fit_cooling_load_model(df)

saveRDS(heat_model, file.path(OUTPUT_DIR, "heating_model.rds"))
saveRDS(cool_model, file.path(OUTPUT_DIR, "cooling_model.rds"))

writeLines(
  capture.output(summary(heat_model)),
  file.path(OUTPUT_DIR, "heating_model_summary.txt")
)
writeLines(
  capture.output(summary(cool_model)),
  file.path(OUTPUT_DIR, "cooling_model_summary.txt")
)

plot_residuals(heat_model, file.path(OUTPUT_DIR, "heating_residuals.png"))
plot_residuals(cool_model, file.path(OUTPUT_DIR, "cooling_residuals.png"))

diagnostics <- list(
  heating_vif = vif_check(heat_model),
  heating_normality = normality_test(heat_model),
  heating_heteroscedasticity = heteroscedasticity_test(heat_model),
  cooling_vif = vif_check(cool_model),
  cooling_normality = normality_test(cool_model),
  cooling_heteroscedasticity = heteroscedasticity_test(cool_model)
)
saveRDS(diagnostics, file.path(OUTPUT_DIR, "diagnostics.rds"))

message("Regression outputs written to ", OUTPUT_DIR)
