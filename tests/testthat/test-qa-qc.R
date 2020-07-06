library(readr)
library(tsibble)
library(lubridate)

bdffp <- read_csv(here("data_cleaned", "daily_precip.csv"), col_types = cols(site = col_character()))

test_that("precip values are sensible", {
  expect_true(all(bdffp$precip[!is.na(bdffp$precip)] < 1000))
  expect_true(all(bdffp$precip[!is.na(bdffp$precip)] >= 0))
})

test_that("dates are correct", {
  #any duplicated?
  expect_false(is_duplicated(bdffp, key = site, index = date))
  #are dates in order and continuous?
  skip("This is actually too strict because legit gaps in measurment will cause it to fail")
  expect_true(all(bdffp$date == lag(bdffp$date) + 1, na.rm = TRUE))
})

