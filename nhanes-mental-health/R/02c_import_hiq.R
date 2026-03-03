# DPQ data
setwd('C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_raw/Health_Insurance')

library(haven)
library(dplyr)

hiq_l <- read_xpt("HIQ_L.xpt")
glimpse(hiq_l)

clean_hiq <- function(path, cycle_label){
  
  read_xpt(path) %>%
    mutate(
      uninsured = if_else(HIQ011 == 2, 1, 0),
      cycle = cycle_label
    ) %>%
    transmute(
      pid = SEQN,
      uninsured,
      cycle
    )
}

hiq_all <- bind_rows(
  clean_hiq("HIQ_I.xpt","2015-2016"),
  clean_hiq("P_HIQ.xpt","2017-2020"),
  clean_hiq("HIQ_L.xpt","2021-2023")
)

saveRDS(hiq_all,"C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/hiq_all.rds")