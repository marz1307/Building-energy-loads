# Energy Efficiency Dataset

The dataset (`Energy_Efficiency_Data.xlsx`) contains 768 simulated building
configurations across 10 variables: 8 design predictors and 2 energy
response variables.

## Variables

**1. Relative Compactness**

- Type: Continuous (float)
- Meaning: Ratio of the building's volume to the volume of a cube with the
  same surface area. Higher values indicate a more compact shape (less
  exterior surface per unit of volume).

**2. Surface Area**

- Type: Continuous (float)
- Meaning: Total external surface area of the building envelope (m^2).
  Larger values correspond to larger exposed surfaces and thus greater
  potential heat loss or gain.

**3. Wall Area**

- Type: Continuous (float)
- Meaning: Total exterior wall area of the building (m^2).

**4. Roof Area**

- Type: Continuous (float)
- Meaning: Total roof surface area (m^2).

**5. Overall Height**

- Type: Categorical (integer codes)
- Meaning: Total height of the building (metres).
- Categories: 1 = 3.5 m, 2 = 7.0 m.

**6. Orientation**

- Type: Categorical (integer codes)
- Meaning: Direction the building faces, which influences solar gain.
- Categories: 1 = North, 2 = East, 3 = South, 4 = West.

**7. Glazing Area**

- Type: Categorical (integer codes)
- Meaning: Percentage of the facade that is glazed (window area as a
  fraction of wall area).
- Categories: 1 = 0%, 2 = 10%, 3 = 25%, 4 = 40%.

**8. Glazing Area Distribution**

- Type: Categorical (integer codes)
- Meaning: Distribution of the glazing across the building's four facades.
- Categories: 1 = Uniform, 2 = North, 3 = East, 4 = South, 5 = West.

**9. Heating Load**

- Type: Continuous (float)
- Meaning: Annual heating requirement (kWh/m^2) to maintain indoor thermal
  comfort.

**10. Cooling Load**

- Type: Continuous (float)
- Meaning: Annual cooling requirement (kWh/m^2) to maintain indoor thermal
  comfort.
