#' Rain gauge data from Biological Dynamics of Forest Fragments Project (BDFFP)
#'
#' Precipitation data from the Biological Dynamics of Forest Fragments Project.
#' Data was collected by rain gauge manually recorded by observers.  When a site
#' wasn't visited for some time, measurements were noted as accumulated.  There
#' are also gaps in the data when sites weren't visited for longer periods of
#' time.
#'
#' @format a tibble with 42552 rows and 10 variables:
#' \describe{
#'  \item{site}{site name}
#'  \item{lat}{approximate lattitude of rain gauge}
#'  \item{lon}{approximate longitude of rain gauge}
#'  \item{date}{date of observation}
#'  \item{doy}{day of year}
#'  \item{time}{time of observation in 24 hr time}
#'  \item{observer}{observer name}
#'  \item{precip}{recorded precipitation in mm}
#'  \item{notes}{consolidated notes from field notes column in raw data sheets
#'  as well as text comments made in the time column in the original data}
#'  \item{flag}{Mult-day accumulations noted in raw data (A), observations
#'  following missing data points (assumed multi-day accumulations, U), data
#'  error (E), trace precipitation (T)}
#' }
"bdffp_rain"