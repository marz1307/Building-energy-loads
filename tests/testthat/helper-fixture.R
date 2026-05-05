# Synthetic fixture mirroring the energy efficiency dataset structure.
# Uses set.seed(42) for reproducibility so tests do not depend on the
# shipped xlsx.

make_energy_fixture <- function(n = 200) {
  set.seed(42)
  rel_compact <- runif(n, 0.62, 0.98)
  surface_area <- runif(n, 500, 850)
  wall_area <- runif(n, 245, 416)
  roof_area <- runif(n, 110, 220)
  height <- sample(c(1, 2), n, replace = TRUE)
  orientation <- sample(1:4, n, replace = TRUE)
  glazing_area <- sample(1:4, n, replace = TRUE)
  glazing_dist <- sample(1:5, n, replace = TRUE)
  heating <- 5 + 30 * (height - 1) + 5 * glazing_area + rnorm(n, 0, 2)
  cooling <- 8 + 25 * (height - 1) + 5 * glazing_area + rnorm(n, 0, 2)
  data.frame(
    RelCompact = rel_compact,
    SurfaceArea = surface_area,
    WallArea = wall_area,
    RoofArea = roof_area,
    Height = height,
    Orientation = orientation,
    GlazingArea = glazing_area,
    GlazingDist = glazing_dist,
    HeatingLoad = heating,
    CoolingLoad = cooling
  )
}
