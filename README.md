
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bdffpRain

<!-- badges: start -->

[![R build
status](https://github.com/BrunaLab/BDFFP-precipitation/workflows/R-CMD-check/badge.svg)](https://github.com/BrunaLab/BDFFP-precipitation/actions)

<!-- badges: end -->

**Translation**: So far I have only translated documentation with Google
Scholar, so I would appreciate help translating from English to
Portuguese or correcting any mistranslations!

*[Versão em
português](https://github.com/BrunaLab/BDFFP-precipitation/blob/master/README.pt-BR.md)*

This repository houses the `bdffpRain` package and the raw data and
wrangling code used to produce the `bdffp_rain` (English) and
`pdbff_chuva` (Portuguese) datasets.

## The R package

The `bdffpRain` R package contains cleaned daily precipitation data from
8 rain gauges at the Biological Dynamics of Forest Fragments Project
between 1987 and 2010.  
To install the package run:

``` r
install.packages("remotes")
remotes::install_github("BrunaLab/bdffpRain")
```

The data is in `bdffp_rain`, which looks like this:

``` r
library(bdffpRain)
data("bdffp_rain")
head(bdffp_rain)
#>   site   lat    lon       date doy  time observer precip notes flag
#> 1 km37 -2.43 -59.79 2004-10-04 278 14:20  Rogerio   14.0  <NA> <NA>
#> 2 km37 -2.43 -59.79 2004-10-05 279  <NA>     <NA>     NA  <NA> <NA>
#> 3 km37 -2.43 -59.79 2004-10-06 280 07:30  Rogerio    2.6  <NA>    U
#> 4 km37 -2.43 -59.79 2004-10-07 281  <NA>     <NA>     NA  <NA> <NA>
#> 5 km37 -2.43 -59.79 2004-10-08 282 12:30 Apostolo   36.8  <NA>    U
#> 6 km37 -2.43 -59.79 2004-10-09 283 07:30  Rogerio   14.8  <NA> <NA>
```

Check the help file for detailed metadata with `?bdffp_rain`.

## Raw data and wrangling code

If you are interested in the raw data or the code used to clean and
wrangle those data, you can fork this repository, or download it with
the green “Code” button on this page. You’ll find the raw data in a
series of .XLS files in the `"data_raw"` directory and annotated
wrangling code in the `"wrangling"` directory.

## Data usage

If you wish to use this data for a publication, please cite:

<!-- insert zenodo citation -->

The vignette for the package shows an example of how to use imputation
to “fill in” missing observations and produce a complete dataset that
can be used to produce figures and summary statistics for monthly
precipitation at BDFFP.

Additionally, there is old, probably broken code in the `"notes"`
directory that may be useful.

## Contributing

If you find mistakes or issues or would like to suggest improvements,
please file an issue.
