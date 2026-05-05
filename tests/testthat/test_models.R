test_that("fit_heating_load_model returns an lm with coefficients", {
  df <- make_energy_fixture()
  model <- fit_heating_load_model(df)
  expect_s3_class(model, "lm")
  coefs <- coef(model)
  expect_true(length(coefs) >= 2)
  expect_true("(Intercept)" %in% names(coefs))
})

test_that("fit_cooling_load_model returns an lm with coefficients", {
  df <- make_energy_fixture()
  model <- fit_cooling_load_model(df)
  expect_s3_class(model, "lm")
  expect_true(length(coef(model)) >= 2)
})

test_that("vif_check returns numeric values for the heating model", {
  df <- make_energy_fixture()
  model <- fit_heating_load_model(df)
  vifs <- vif_check(model)
  expect_true(is.numeric(vifs) || is.matrix(vifs))
})

test_that("normality_test returns expected list elements", {
  df <- make_energy_fixture()
  model <- fit_heating_load_model(df)
  result <- normality_test(model)
  expect_named(result, c("statistic", "p_value", "n"))
  expect_true(result$p_value >= 0 && result$p_value <= 1)
})

test_that("heteroscedasticity_test returns expected list elements", {
  df <- make_energy_fixture()
  model <- fit_heating_load_model(df)
  result <- heteroscedasticity_test(model)
  expect_named(result, c("statistic", "p_value", "df"))
  expect_length(result$df, 2)
})
