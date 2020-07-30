library(readr)
library(tidyr)
library(dplyr)
library(tsibble)
library(lubridate)
library(here)

bdffp <- read_csv(here("data_cleaned", "daily_precip.csv"), col_types = cols(site = col_character()))

test_that("non-accumulated precip values are sensible", {
  expect_true(all(bdffp$precip[!is.na(bdffp$precip) & is.na(bdffp$flag)] < 500))
})

test_that("all precip values are positive", {
  expect_true(all(bdffp$precip[!is.na(bdffp$precip)] >= 0))
})

test_that("dates are correct", {
  #any duplicated?
  expect_false(is_duplicated(bdffp, key = site, index = date))
  #are dates in order and continuous?
  skip("This is actually too strict because legit gaps in measurement will cause it to fail")
  expect_true(all(bdffp$date == dplyr::lag(bdffp$date) + 1, na.rm = TRUE))
})

test_that("correlations among sites are within tolerance", {
  #I don't know if this is sensible.  Just an idea borrowed from Durre et al. 2013
  bdffp_wide <- bdffp %>% 
    pivot_wider(matches("date"), names_from = site, values_from = precip)

  cors <- cor(select(bdffp_wide, -date), use = "pairwise.complete.obs", method = "spearman")
  expect_false(any(cors < 0.1, na.rm = TRUE))
})



