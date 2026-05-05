.PHONY: install lint test analyze clean

install:
	Rscript -e 'if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes"); remotes::install_deps(dependencies = TRUE)'

lint:
	Rscript -e 'lintr::lint_package()'

test:
	Rscript -e 'devtools::test()'

analyze:
	Rscript analysis/01_eda.R
	Rscript analysis/02_correlation.R
	Rscript analysis/03_regression.R

clean:
	rm -rf output
