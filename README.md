<div align="center">

# energyEfficiency

### Statistical analysis of building energy loads from geometric design parameters

[![R](https://img.shields.io/badge/R-%3E%3D4.3-blue.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![CI](https://img.shields.io/badge/CI-R--CMD--check-brightgreen.svg)](.github/workflows/R-CMD-check.yml)

</div>

## Overview

`energyEfficiency` is a small R analysis package that turns a building
energy efficiency dataset into a reproducible statistical workflow. The
problem: predict annual heating and cooling loads from eight building
geometry and facade parameters. The approach: descriptive statistics,
correlation analysis, and stepwise linear regression with standard
diagnostic checks. The data: 768 simulated building configurations across
10 variables (8 design predictors, 2 energy response variables).

## What the pipeline produces

Running the analysis (see [Reproducibility](#reproducibility)) writes the
following artefacts under `output/`:

- `descriptive_stats.csv`: per-variable mean, standard deviation, min, max
- `correlation_matrix.csv` and `correlation_heatmap.png`
- `distributions.png`, `pairs.png`
- `heating_model.rds`, `cooling_model.rds`: fitted stepwise models
- `heating_model_summary.txt`, `cooling_model_summary.txt`
- `heating_residuals.png`, `cooling_residuals.png`
- `diagnostics.rds`: VIF, normality, and heteroscedasticity results

## Architecture

```
data-raw/Energy_Efficiency_Data.xlsx
        |
        v
  load_energy_data ---> validate_energy_data
        |
        v
  descriptive_stats / correlation_matrix / summary_by_orientation
        |
        v
  fit_heating_load_model / fit_cooling_load_model  (stepwise AIC)
        |
        v
  vif_check / normality_test / heteroscedasticity_test
        |
        v
  plots + CSV summaries in output/
```

## Project structure

```
energy/
  DESCRIPTION, NAMESPACE, LICENSE(.md)
  Makefile, .lintr, .Rbuildignore, .gitignore
  .github/workflows/R-CMD-check.yml
  R/
    data.R          load and validate the dataset
    eda.R           descriptive stats, correlations, group summaries
    models.R        canonical formulae and stepwise model fits
    diagnostics.R   VIF, Shapiro-Wilk, heteroscedasticity tests
    plots.R         distributions, heatmap, pairs, residuals
    pipeline.R      run_full_analysis end-to-end
    utils.R         ensure_dir, get_logger
  analysis/
    01_eda.R        descriptive statistics and distribution plots
    02_correlation.R correlation matrix and heatmap
    03_regression.R stepwise models and diagnostics
  tests/testthat/   data, eda, and model tests with synthetic fixture
  data-raw/         dataset and variable description
```

## Methodology

1. **Data preparation.** The `.xlsx` is read with `readxl`, columns are
   normalised to canonical names, and each row is checked for type and
   completeness before any analysis runs.
2. **Exploratory analysis.** Mean, standard deviation, min, and max are
   computed for every variable. Histograms reveal the bimodal shape of
   both response distributions, driven by the discrete categorical
   predictors.
3. **Correlation analysis.** Pearson correlations are computed between the
   four continuous geometry variables and the two responses; the heatmap
   highlights the strong heating-cooling link and the negative roof-area
   association.
4. **Regression.** For each response, a full linear model is fitted with
   continuous predictors, factor-coded categoricals, and a surface-area by
   wall-area interaction. Bidirectional stepwise selection (AIC) yields a
   parsimonious final model.
5. **Diagnostics.** Variance inflation factors flag collinearity, a
   Shapiro-Wilk test on residuals checks normality, and an auxiliary
   regression of squared residuals on fitted values screens for
   heteroscedasticity.

Numerical results (R-squared, coefficients, p-values) are not committed
in this README. Run `make analyze` to produce them locally.

## Reproducibility

- R version: 4.3 or newer
- Random seed: `set.seed(42)` is used wherever sampling occurs
- One-line run:

```bash
make install
make analyze
```

Individual stages can be run via `make lint`, `make test`, or by invoking
the scripts in `analysis/` directly.

## Limitations

- The dataset is a balanced simulated factorial design, not a sample of
  real buildings; absolute load magnitudes will not transfer directly.
- Stepwise selection by AIC is convenient but can be unstable under
  multicollinearity; coefficients should be interpreted alongside the VIF
  output.
- No cross-validation or hold-out evaluation is performed; the focus is
  inferential rather than predictive.

## License

MIT, see [LICENSE.md](LICENSE.md).

## Author

Marvis Osazuwa, Analytics Engineer / Data Scientist with seven years
across banking, healthcare, and marketing analytics.

- Email: marvis.osazuwa@hotmail.com

## Links

- Source: this repository
- Dataset description: [data-raw/README.md](data-raw/README.md)
