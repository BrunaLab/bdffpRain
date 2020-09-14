# Manaus Weather

## Filename

`manaus_weather.csv`

### Description

This is weather data for Manaus from a weather station between 1985-01-01 and 2019-01-01

### Location

- Station: MANAUS - AM (OMM: 82331)
- Latitude  (degrees) : -3.1
- Longitude (degrees) : -60.01
- Altitude  (meters): 61.25

### Variable definitions

- `date`: date in ISO format
- `precp`: precipitation in mm
- `temp_mean`: daily mean compensated temperature in ºC
- `temp_min`: daily minimum temperature in ºC
- `temp_max`: daily maximum temperature in ºC
- `sun_time`: hours of direct sunlight (???)
- `piche_evap`: evaporation measured by Piche evaporimiter
- `rh`: daily mean relative humidity
- `wind_speed`: daily mean wind speed in m/s


# BDFFP Precipitation

## Filename

`daily_precip.csv`

### Description

Precipitation data from the Biological Dynamics of Forest Fragments Project.  Data was collected by rain gauge manually recorded by observers.  When a site wasn't visited for some time, measurements were noted as accumulated.  There are also gaps in the data when sites weren't visited for longer periods of time

### Location

### Variable Definitions

- `site`: site name
- `date`: date in ISO format
- `doy`: day of year
- `time`: time in HH:MM (24hr time)
- `observer`: name of observer who recorded the data
- `precip`: precipitation in mm
- `notes`: consolidated notes from notes column in original data as well as text comments made in the time column in the original data.


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


# Interpolated/gridded data products

## Filename

`xavier_daily_0.25x0.25.csv`

### Description

Described in:

Xavier, Alexandre C., Carey W. King, and Bridget R. Scanlon. “Daily Gridded Meteorological Variables in Brazil (1980–2013).” International Journal of Climatology 36, no. 6 (2016): 2644–59. https://doi.org/10.1002/joc.4518.

http://careyking.com/data-downloads/

### Variable Definitions

- `date` (Date): date in ISO format
- `lat` (numeric): latitude (decimal degrees)
- `lon` (numeric): longitude (decimal degrees)
- `precip` (numeric): precipitation (mm)
- `eto` (numeric): potential evapotranspiration

## Filename

`sa_daily_1x1.csv`

### Description

Described in:

Liebmann, Brant, and Dave Allured. “Daily Precipitation Grids for South America.” Bulletin of the American Meteorological Society 86, no. 11 (November 2005): 1567–70. https://doi.org/10.1175/BAMS-86-11-1567.

https://psl.noaa.gov/data/gridded/data.south_america_precip.html

### Varialble Definitions

- `date` (Date): date in ISO format
- `lat` (numeric): latitude (decimal degrees)
- `lon` (numeric): longitude (decimal degrees)
- `precip` (numeric): precipitation (mm)

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
