test_that("translated data is identical", {
  expect_equivalent(pdbff_chuva, bdffp_rain)
})

test_that("column headings are different", {
  #this could be a better test, but it's just a reminder to check that the translations are still in place
  expect_false(all(colnames(pdbff_chuva) == colnames(bdffp_rain)))
})
