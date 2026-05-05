test_that("validate_energy_data accepts the synthetic fixture", {
  df <- make_energy_fixture()
  expect_true(validate_energy_data(df))
  expect_equal(ncol(df), 10)
  expect_true(all(vapply(df, is.numeric, logical(1))))
})

test_that("validate_energy_data errors on missing columns", {
  df <- make_energy_fixture()
  df$HeatingLoad <- NULL
  expect_error(validate_energy_data(df), "Missing required columns")
})

test_that("validate_energy_data errors on missing values", {
  df <- make_energy_fixture()
  df$WallArea[1] <- NA
  expect_error(validate_energy_data(df), "missing values")
})

test_that("feature_categories returns three named groups", {
  cats <- feature_categories()
  expect_named(cats, c("continuous", "categorical", "responses"))
  expect_length(cats$continuous, 4)
  expect_length(cats$categorical, 4)
  expect_length(cats$responses, 2)
})
