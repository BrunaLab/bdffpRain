ts <- manaus_ts
interp_test <- function(ts) {
  ts[is.na(ts)] <- 5
  return(ts)
}

interp_mice <- function(ts) {
  full <- as_tsibble(ts) %>% as_tibble() %>% left_join(bdffp_test, ., by = c("date" = "index"))
  x <- mice(full, printFlag = FALSE, maxit = 1)
  out <- complete(x) %>% select(date, value) %>% as_tsibble(index = date) %>% as.ts()
  return(out)
}

interp_mtsdi <- function(ts) {
  full <- as_tsibble(ts) %>% as_tibble() %>% left_join(., bdffp_test, by = c("index" = "date"))
  f <- ~ dimona + porto_alegre + km_clust + colosso_clust + value
  b <- as.character(year(full$index))
  ii <- mnimput(f, full, log = TRUE, ts = TRUE, method = "spline")
  fit <- predict(ii)
  out <-bind_cols(date = full$index, value = fit$value) %>% as_tsibble(index = index) %>% as.ts()
  return(out)
}
