library(tidyverse)
library(here)
library(conflicted)
library(Amelia)
library(parallel)
library(janitor)
library(tsibble)
library(lubridate)

conflict_prefer("filter", "dplyr")

# Note: This script is not currently reproducible because set.seed() doesn't
# work with amelia() when run in parallel on multiple cores
# (https://github.com/IQSS/Amelia/issues/21)

# Load Data ---------------------------------------------------------------
bdffp <- read_csv(here("data_cleaned", "daily_precip.csv"))
sa <- read_csv(here("data_cleaned", "sa_daily_1x1.csv"))
xa <- read_csv(here("data_cleaned", "xavier_daily_0.25x0.25.csv"))
manaus <- read_csv(here("data_cleaned", "manaus_weather.csv"))


# Prep data for imputation ------------------------------------------------

# remove accumulations
bdffp2 <-
  bdffp %>% 
  filter(!flag %in% c("A", "U"))

# spread and fill in dates
bdffp_wide <- 
  bdffp2 %>% 
  #complete all the dates
  as_tsibble(key = site, index = date) %>% 
  fill_gaps() %>% 
  select(date, site, precip) %>% 
  as_tibble() %>% 
  pivot_wider(names_from = site, values_from = precip) %>% 
  clean_names()

# Cluster sites to reduce missingness
bdffp_wide2 <-
  bdffp_wide %>% 
  rowwise() %>% 
  mutate(colosso_clust = mean(c(colosso, florestal, cabo_frio, gaviao), na.rm = TRUE),
         km_clust = mean(c(km37, km41), na.rm = TRUE)) %>% 
  mutate(across(colosso_clust:km_clust, ~ifelse(is.nan(.x), NA, .x))) %>% 
  select(-cabo_frio, -colosso, -florestal, -gaviao, -km37, -km41)

# add additional data
xa_wide <-
  xa %>% 
  mutate(xa_latlon = paste(lat, lon, sep = ", "), lat = NULL, lon = NULL) %>% 
  pivot_wider(names_from = xa_latlon, values_from = c(precip, eto)) %>%
  clean_names()

full_wide <-
  left_join(bdffp_wide2, rename(manaus, manaus = precip), by = "date") %>%
  left_join(select(sa, date, sa = precip), by = "date") %>% 
  left_join(xa_wide, by = "date") %>% 
  mutate(year = year(date), doy = yday(date)) %>%
  select(year, doy, everything()) %>%
  select(-temp_max, -temp_min, -sun_time)

# Impute missing data -----------------------------------------------------
# round(runif(1, 1, 1000))
set.seed(937)
all_cols <- colnames(select(full_wide, -year, -doy, -date))

# eto normality improved by sqrt
sqrt_cols <- colnames(full_wide %>% select(starts_with("eto_")))

# variables with log-normal-ish distributions
log_cols <- all_cols[!all_cols %in% c("rh", "temp_mean", sqrt_cols)]

imp <- 
  amelia(
    as.data.frame(full_wide),
    p2s = 0,
    m = 10,
    ts = "doy",
    cs = "year",
    intercs = TRUE,
    polytime = 3,
    logs = log_cols,
    sqrts = sqrt_cols,
    idvars = c("date"),
    parallel = "multicore",
    ncpus = detectCores() - 1,
    empri = .01 * nrow(full_wide) #ridge penalty because of high degree of missingness
  )

# SPI and SPEI calculations --------------------------------------------------------

# Calculate SPI and SPEI on each of the imputations, then combine
# TODO: - I don't trust this ET0 value.  It is super different that one calculated using thornthwaite()
# Regardless, you need ET0 on a monthly basis.  Might be better to just use calculated from manaus data

# Aggregate by month
imp_mon <-
  map(imp$imputations, ~{
    .x %>% 
      rename_with(~paste0(., ".precip"), c(dimona, porto_alegre, colosso_clust, km_clust)) %>% 
      select(date, ends_with(".precip"), starts_with("eto_")) %>% 
      mutate(yearmonth = tsibble::yearmonth(date)) %>% 
      group_by(yearmonth) %>% 
      summarize(across(-date, ~sum(.x, na.rm = TRUE))) %>% 
      #remove first and last month, as they aren't complete
      slice(-1, -nrow(.))
  })
# Match ETo values to sites and calculate climate balance (precip - ETo)

imp_mon <-
  map(imp_mon, ~{
  .x %>% 
    mutate(dimona.cb = dimona.precip - eto_2_375_60_125) %>% 
    mutate(across(c(porto_alegre.precip, colosso_clust.precip),
                  ~.x - eto_2_375_59_875,
                  .names = "{str_remove(col, '.precip')}.cb")) %>% 
    mutate(km_clust.cb = km_clust.precip - eto_2_375_59_625)
})

# Calculate SPI and SPEI

imp_spei <-
  map(imp_mon, ~{
  .x %>% 
    mutate(across(ends_with(".precip"),
                  ~as.numeric(SPEI::spi(.x, scale = 3)$fitted),
                  .names = "{str_remove(col, '.precip')}.spi")) %>% 
    mutate(across(ends_with(".cb"), ~as.numeric(SPEI::spei(.x, scale = 3)$fitted),
                  .names = "{str_remove(col, '.cb')}.spei")) %>%
      select(yearmonth, ends_with(c(".precip", ".spi", ".spei")))
}) 


# Combine multiply imputed SPI and SPEI results by taking mean
mean_spei <- 
  imp_spei %>%
  bind_rows(.id = "imp") %>% 
  #replace any infinite values with NAs
  mutate(across(everything(), ~ ifelse(is.infinite(.x), NA, .x))) %>% 
  group_by(yearmonth) %>% 
  summarize(across(where(is.numeric), ~mean(., na.rm = TRUE))) %>% 
  #replace NaN's with NAs
  mutate(across(everything(), ~ ifelse(is.nan(.x), NA, .x)))

# Ouput data --------------------------------------------------------------

# Imputed daily precip

daily_mean <-
  imp$imputations %>%
  map(as_tibble) %>% 
  bind_rows(.id = "imp") %>% 
  select(imp:km_clust) %>% 
  pivot_longer(dimona:km_clust, names_to = "site", values_to = "precip") %>% 
  group_by(site, date) %>% 
  summarize(precip = mean(precip))

write_csv(daily_mean, here("data_cleaned", "daily_imputed.csv"))

# Long version of SPI and SPEI

spei_long <-
  mean_spei %>% 
  pivot_longer(-yearmonth, names_to = c("site", "var"), names_sep = "\\.") %>% 
  filter(var != "cb") %>% 
  pivot_wider(names_from = var, values_from = value) %>% 
  mutate(date = as_date(yearmonth)) %>% 
  select(date, site, precip_tot = precip, spi, spei) %>% 
  arrange(site, date)

#test
# imp_spei %>% bind_rows(.id = "imp") %>% filter(is.infinite(colosso_clust.spei))


write_csv(spei_long, here("data_cleaned", "mon_precip_spi_imputed.csv"))
