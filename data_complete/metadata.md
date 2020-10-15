# Daily precipitation data

## Filename

`daily_imputed.csv`

### Description

Derived from `daily_precip.csv` but with some sites aggregated, and missing values filled in by imputation.  The imputation procedure is performed in "R/imputation.R".  Briefly, all accumulations are removed, some sites are averaged to reduce missingness, additional data sources are added including `xavier_daily_0.25x0.25.csv`, `manaus_weather.csv`, and `sa_daily_1x1.csv`.  Then, the `Amelia` package is used to impute missing values.

### Variable Definitions

- `site` (character): site name, or site cluster.  `"colosso_clust"` is an average of the colosso, florestal, cabo_frio, and gaviao sites in `daily_precip.csv`, and `"km_clust"` is an average of km41 and km37.
- `date` (Date): date in ISO format
- `precip` (numeric): precipitation in mm

## Filename

`daily_replacement.csv`

### Description

Derived from `daily_precip.csv` but with missing values filled in using a set of replacement rules.  The procedure is performed in "R/SPI_w_replacement.Rmd".  Briefly, precipitation accumulations greater than 20mm are removed, then missing values are replaced in a series of passes.  First, missing values are replaced by averages from near-by sites.  Then, if still missing, values are replaced by a BDFFP-wide average. Finally, remaining missing values are replaced by values from a gridded data product described under `xavier_daily_0.25x0.25.csv`.

### Variable Definitions

- `site` (character): site name
- `date` (Date): date in ISO format
- `precip` (numeric): precipitation in mm


# Monthly SPI and SPEI

## Description

These data products include 3-month standardized precipitation index (SPI) and 3-month standardized precipitation evapotranspiration index (SPEI).  SPI is calculated using precipitation at each site or cluster of sites and SPEI is calculated using precipitation at each site and evapotranspiration in the nearest grid-cell in the `xavier_daily_0.25x0.25.csv` dataset.  Months with incomplete data at the beginning and end of the dataset have been removed before calculating SPI and SPEI.

## Filename

- `mon_precip_spi_imputed.csv`: calculated using imputed daily precipitation
- `mon_precip_spi_repl.csv`: calculated using daily precipitation with missing values filled by replacement rules (see `daily_replacement.csv`)

### Variable Definitions

- `date` (Date): date in ISO format
- `site` (character): site or site cluster
- `precip_tot` (numeric): total monthly precipitation (mm)
- `spi` (numeric): standardized precipitation index
- `spei` (numeric): standardized precipitation-evapotranspiration index
