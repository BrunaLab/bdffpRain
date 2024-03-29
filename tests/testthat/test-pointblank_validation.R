# Generated by pointblank
library(pointblank)

test_that("column `date` is of type: Date", {

  expect_col_is_date(
    bdffp_rain,
    columns = vars(date),
    threshold = 1
  )
})

test_that("column `site` is of type: character", {

  expect_col_is_character(
    bdffp_rain,
    columns = vars(site),
    threshold = 1
  )
})

test_that("column `observer` is of type: character", {

  expect_col_is_character(
    bdffp_rain,
    columns = vars(observer),
    threshold = 1
  )
})

test_that("column `notes` is of type: character", {

  expect_col_is_character(
    bdffp_rain,
    columns = vars(notes),
    threshold = 1
  )
})

test_that("column `flag` is of type: character", {

  expect_col_is_character(
    bdffp_rain,
    columns = vars(flag),
    threshold = 1
  )
})

test_that("column `doy` is of type: numeric", {

  expect_col_is_numeric(
    bdffp_rain,
    columns = vars(doy),
    threshold = 1
  )
})

test_that("column `precip` is of type: numeric", {

  expect_col_is_numeric(
    bdffp_rain,
    columns = vars(precip),
    threshold = 1
  )
})


test_that("values in `flag` should be in the set of `A`, `U`, `T` (and 2 more)", {

  expect_col_vals_in_set(
    bdffp_rain,
    columns = vars(flag),
    set = c("A", "U", "T", "E", NA),
    threshold = 0.2
  )
})

test_that("precip values are reasonable", {

  expect_col_vals_between(
    bdffp_rain,
    columns = precip,
    left = 0,
    right = 300,
    na_pass = TRUE,
    #only for days that aren't multi-day accumulations
    preconditions = ~. %>% dplyr::filter(!flag %in% c("A", "U") | is.na(flag)),
    threshold = 0.2
  )
})

test_that("values in `doy` should be between `1` and `366`", {

  expect_col_vals_between(
    bdffp_rain,
    columns = vars(doy),
    left = 1,
    right = 366,
    threshold = 0.2
  )
})

test_that("check that rainfall is at least moderately correlated among sites", {

  expect_col_vals_gt(
    bdffp_rain,
    columns = vars(cor),
    value = 0.4,
    na_pass = TRUE,
    preconditions = ~. %>%
      tidyr::pivot_wider(date, names_from = site, values_from = precip) %>%
      dplyr::select(-date) %>%
      #remove sites with very sparse data
      dplyr::select(-florestal, -`cabo frio`, -km37, -gaviao) %>%
      cor(use = "pairwise.complete.obs", method = "spearman") %>%
      tibble::as_tibble(rownames = "site") %>%
      tidyr::pivot_longer(-site, names_to = "site2", values_to = "cor")
  )
})

test_that("any duplicate dates within sites?", {

  expect_col_vals_equal(
    bdffp_rain,
    columns = vars(duped),
    value = "FALSE",
    preconditions = ~. %>%
      dplyr::group_by(site) %>%
      dplyr::mutate(duped = duplicated(date)) %>%
      dplyr::ungroup()
  )
})

