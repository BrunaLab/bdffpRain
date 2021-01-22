library(pointblank)
library(readr)

bdffp <- read_csv(here("data_cleaned", "daily_precip.csv"), col_types = cols(site = col_character()))

# scan_data(bdffp)
al <- action_levels(warn_at = 0.1, stop_at = 0.2)
bdffp_agent <-
  bdffp %>% 
  create_agent(actions = al) %>% 
  col_is_date(vars(date)) %>% 
  col_is_character(vars(site, observer, notes, flag)) %>% 
  col_is_numeric(vars(doy, precip)) %>% 
  col_vals_expr(~hms::is_hms(time)) %>% 
  col_vals_in_set(vars(flag), c("A", "U", "T", "E", NA)) %>% #shit, I can't remember what these mean
  col_vals_expr(
    ~case_when(
      flag != "A" ~ between(precip, 0, 300)
    ),
    label = "Is rainfall ever above 300mm in a single day?"
  ) %>% 
  col_vals_between(
    vars(doy), 1, 366
  ) %>% 
  #are sites at least moderately correlated?
  col_vals_gt(
    vars(cor), 0.4,
    label = "Is precipitation among sites at least moderately correlated?",
    preconditions = ~. %>% 
      pivot_wider(date, names_from = site, values_from = precip) %>% 
      select(-date) %>% 
      cor(use = "pairwise.complete.obs", method = "spearman") %>% 
      as_tibble(rownames = "site") %>% 
      pivot_longer(-site, names_to = "site2", values_to = "cor"),
    na_pass = TRUE
  ) %>% 
  col_vals_equal(
    vars(duped), FALSE,
    preconditions = ~. %>% group_by(site) %>% mutate(duped = duplicated(date)) %>% ungroup(),
    label = "Are any dates duplicated within a site?"
  )
  
interrogate(bdffp_agent)
