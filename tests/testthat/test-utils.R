library(tsibble)
library(dplyr)
library(tibble)
library(lubridate)
source(here::here("R", "utils.R"))

set.seed(100)
precip <- rpois(15, 10)
precip[10] <- sum(precip[6:10])
precip[6:9] <- NA

precip[15] <- sum(precip[13:15])
precip[13:14] <- NA
# precip[1] <- NA

df <- as_tibble(list(precip = precip))
ts <-
  df %>% 
  add_column(date = as_date(today():(today() + nrow(df) - 1))) %>% 
  as_tsibble(index = date)

# precip

correct <- c(8, 10, 9, 12, 10, 9.8, 9.8, 9.8, 9.8, 9.8, 11, 12, 8.666666667, 8.666666667, 8.666666667)

test_that("spread_back works on vectors", {
  expect_equivalent(spread_back(precip), correct)
})

test_that("spread_back works with tibbles", {
  x <- df %>% 
    mutate(test = spread_back(precip))
  expect_equivalent(pull(x, test), correct)
})

test_that("spread_back works with tsibbles", {
  x <- ts %>% 
    mutate(test = spread_back(precip))
  expect_equivalent(pull(x, test), correct)
})
