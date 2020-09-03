library(readr)
library(here)

df <- read_csv(here("data_cleaned", "mon_precip_spi_imputed.csv"))

test_that("imputed output is well formed", {
  expect_false(any(is.infinite(df$spi)))
  expect_false(any(is.infinite(df$spei)))
  expect_false(anyNA(df$precip_tot))
  expect_false(any(is.infinite(df$precip_tot)))
})

df2 <- read_csv(here("data_cleaned", "mon_precip_spi_repl.csv"))

test_that("replacement output is well formed", {
  expect_false(any(is.infinite(df2$spi)))
  expect_false(any(is.infinite(df2$spei)))
  expect_false(anyNA(df2$precip_tot))
  expect_false(any(is.infinite(df2$precip_tot)))
})