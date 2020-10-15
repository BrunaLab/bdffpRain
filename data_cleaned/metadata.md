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


# Gridded data products

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

