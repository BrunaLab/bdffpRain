library(tidyverse)
library(here)
library(conflicted)
library(Amelia)
library(parallel)
library(janitor)
library(tsibble)
library(lubridate)

conflict_prefer("filter", "dplyr")


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

# SPI calculations --------------------------------------------------------

# Calculate SPI on each of the imputations, then combine
imp_spi <- 
  map(imp$imputations, ~{
    .x %>% 
      select(date, dimona, porto_alegre, colosso_clust, km_clust) %>% 
      mutate(yearmonth = tsibble::yearmonth(date)) %>% 
      group_by(yearmonth) %>% 
      summarize(across(-date, ~sum(.x, na.rm = TRUE))) %>% 
      mutate(across(-yearmonth, ~as.numeric(SPEI::spi(.x, scale = 3)$fitted),
                    .names = "{col}.spi"))
  }) %>% 
  bind_rows(.id = "imp")


# SPEI calculations -------------------------------------------------------

# Match ETo values to sites and calculate climate balance (precip - ETo)

imp_eto <- map(imp$imputations, ~{
  .x %>% 
  mutate(cb_dimona = dimona - eto_2_375_60_125) %>% 
  mutate(across(.cols = c(porto_alegre, colosso_clust),
                .fns = ~.x - eto_2_375_59_875, .names = "cb_{col}")) %>% 
  mutate(cb_km_clust = km_clust - eto_2_375_59_625)
})

imp_spei <- 
  map(imp_eto, ~{
    .x %>% 
      select(date, starts_with("cb_")) %>% 
      mutate(yearmonth = tsibble::yearmonth(date)) %>% 
      group_by(yearmonth) %>% 
      summarize(across(starts_with("cb_"), ~sum(.x, na.rm = TRUE))) %>% 
      mutate(across(-yearmonth, ~as.numeric(SPEI::spei(.x, scale = 3)$fitted),
                    .names = "{col}.spei")) %>%
      filter(complete.cases(.))
  }) %>% 
  bind_rows(.id = "imp")


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

# Combine multiply imputed SPI and SPEI results by taking mean

imp_spi_long <-
  imp_spi %>% 
  rename_with(~paste0(., ".precip"), dimona:km_clust) %>% 
  pivot_longer(dimona.precip:km_clust.spi, names_to = c("site", "var"),
               names_sep = "\\.") %>% 
  pivot_wider(values_from = value, names_from = var)

imp_mon_mean <-
  imp_spi_long %>% 
  group_by(yearmonth, site) %>% 
  summarize(spi = mean(spi),
            precip = mean(precip)) %>% 
  mutate(date = as_date(yearmonth))

imp_spei_long <-
  imp_spei %>% 
    select(imp, yearmonth, ends_with(".spei")) %>% 
    pivot_longer(ends_with(".spei"), names_to = "site",
                 names_pattern = "cb_(.+)\\.spei",
                 values_to = "spei")

imp_mon_mean_spei <- 
  imp_spei_long %>% 
  group_by(yearmonth, site) %>% 
  summarize(spei = mean(spei)) %>% 
  mutate(date = as_date(yearmonth))

imp_spi_out <-
  full_join(imp_mon_mean, imp_mon_mean_spei, by = c("yearmonth", "site", "date")) %>% 
  arrange(site, date) %>% 
  ungroup() %>% 
  select(date, site, precip_tot = precip, spi, spei)

write_csv(imp_spi_out, here("data_cleaned", "mon_precip_spi_imputed.csv"))



