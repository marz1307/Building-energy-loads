test_that("descriptive_stats returns one row per variable", {
  df <- make_energy_fixture()
  desc <- descriptive_stats(df)
  expect_equal(nrow(desc), ncol(df))
  expect_named(desc, c("Variable", "Mean", "SD", "Min", "Max"))
  expect_true(all(desc$Min <= desc$Mean))
  expect_true(all(desc$Max >= desc$Mean))
})

test_that("correlation_matrix is symmetric with unit diagonal", {
  df <- make_energy_fixture()
  cor_mat <- correlation_matrix(df)
  expect_equal(nrow(cor_mat), ncol(cor_mat))
  expect_equal(unname(diag(cor_mat)), rep(1, nrow(cor_mat)), tolerance = 1e-8)
  expect_equal(cor_mat, t(cor_mat), tolerance = 1e-8)
})

test_that("summary_by_orientation reports one row per orientation level", {
  df <- make_energy_fixture()
  summary_df <- summary_by_orientation(df)
  expect_equal(nrow(summary_df), length(unique(df$Orientation)))
  expect_named(
    summary_df,
    c("Orientation", "MeanHeating", "SdHeating", "MeanCooling", "SdCooling")
  )
})
