# Manaus Weather

## Filename

`manaus_weather.csv`

## Description

This is weather data for Manaus from a weather station between 1985-01-01 and 2019-01-01

## Location

- Station: MANAUS - AM (OMM: 82331)
- Latitude  (degrees) : -3.1
- Longitude (degrees) : -60.01
- Altitude  (meters): 61.25

## Variable definitions

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

`daily precip.csv`

## Description

Precipitation data from the Biological Dynamics of Forest Fragments Project.  Data was collected by rain gauge manually recorded by observers.  When a site wasn't visited for some time, measurements were noted as accumulated.  There are also gaps in the data when sites weren't visited for longer periods of time

## Location

## Variable Definitions

- `site`: site name
- `date`: date in ISO format
- `doy`: day of year
- `time`: time in HH:MM:SS
- `observer`: name of observer who recorded the data
- `precip`: precipitation in mm
- `notes`: consolidated notes from notes column in original data as well as text comments made in the time column in the original data.
