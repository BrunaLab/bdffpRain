library(readr)
library(here)

df <- read_csv(here("data_cleaned", "mon_precip_spi_imputed.csv"))

test_that("imputed output is well formed", {
  expect_false(any(is.infinite(df$spi)))
  expect_false(any(is.infinite(df$spei)))
  expect_false(anyNA(df$precip_tot))
})
