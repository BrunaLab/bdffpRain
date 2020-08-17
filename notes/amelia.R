library(tidyverse)
library(here)
library(conflicted)
library(Amelia)
library(parallel)
library(janitor)
library(tsibble)
library(lubridate)
library(tictoc)
conflict_prefer("filter", "dplyr")

bdffp <- read_csv(here("data_cleaned", "daily_precip.csv"))
sa <- read_csv(here("data_cleaned", "sa_daily_1x1.csv"))
xa <- read_csv(here("data_cleaned", "xavier_daily_0.25x0.25.csv"))
manaus <- read_csv(here("data_cleaned", "manaus_weather.csv"))

#remove accumulations
bdffp2 <-
  bdffp %>% 
  filter(!flag %in% c("A", "U"))

#spread and fill in dates
bdffp_wide <- 
  bdffp2 %>% 
  #complete all the dates
  as_tsibble(key = site, index = date) %>% 
  fill_gaps() %>% 
  select(date, site, precip) %>% 
  as_tibble() %>% 
  pivot_wider(names_from = site, values_from = precip) %>% 
  clean_names()

#Cluster sites to reduce missingness
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

#Impute
all_cols <- colnames(select(full_wide, -year, -doy, -date))

##eto normality improved by sqrt
sqrt_cols <- colnames(full_wide %>% select(starts_with("eto_")))

##variables with log-normal-ish distributions
log_cols <- all_cols[!all_cols %in% c("rh", "temp_mean", sqrt_cols)]
tic()
imp <- 
  amelia(
    as.data.frame(full_wide),
    p2s = 0,
    m = 5,
    ts = "doy",
    cs = "year",
    intercs = TRUE,
    polytime = 3,
    logs = log_cols,
    sqrts = sqrt_cols,
    idvars = c("date"),
    empri = .01 * nrow(precip_wide) #ridge penalty because of high degree of missingness
  )
toc()

imp_spi <- 
  map(imp$imputations, ~{
    .x %>% 
      select(date, dimona, porto_alegre, colosso_clust, km_clust) %>% 
      mutate(yearmonth = tsibble::yearmonth(date)) %>% 
      group_by(yearmonth) %>% 
      summarize(across(-date, ~sum(.x, na.rm = TRUE))) %>% 
      mutate(across(-yearmonth, ~as.numeric(SPEI::spi(.x, scale = 3)$fitted))) %>%
      filter(complete.cases(.))
  }) %>% 
  bind_rows(.id = "imp")

imp_spi_long <-
  imp_spi %>% 
  pivot_longer(dimona:km_clust, names_to = "site", values_to = "spi") %>% 
  mutate(date = as_date(yearmonth))

imp_mean <-
  imp_spi_long %>% 
  group_by(yearmonth, site) %>% 
  summarize(spi_mean = mean(spi)) %>% 
  mutate(date = as_date(yearmonth))

imp_mean
