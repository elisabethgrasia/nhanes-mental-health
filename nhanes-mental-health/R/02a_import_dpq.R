# DPQ data
setwd('C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_raw/Mental_Health')

library(haven)
library(dplyr)

dpq_l <- read_xpt("DPQ_L.xpt")
glimpse(dpq_l)

# Create Depression Score
clean_dpq <- function(path, cycle_label) {
  
  read_xpt(path) %>%
    mutate(
      phq9 = rowSums(
        select(., starts_with("DPQ")),
        na.rm = TRUE
      ),
      depressed = if_else(phq9 >= 10, 1, 0),
      cycle = cycle_label
    ) %>%
    transmute(
      pid = SEQN,
      phq9,
      depressed,
      cycle
    )
}

# Combine the Cycles
dpq_all <- bind_rows(
  clean_dpq("DPQ_I.xpt", "2015-2016"),
  clean_dpq("P_DPQ.xpt", "2017-2020"),
  clean_dpq("DPQ_L.xpt", "2021-2023")
)

glimpse(dpq_all)

saveRDS(dpq_all, "C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/dpq_all.rds")