# MCQ data
setwd('C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_raw/Medical_Conditions')

library(haven)
library(dplyr)

mcq_l <- read_xpt("MCQ_L.xpt")
glimpse(mcq_l)

clean_mcq <- function(path, cycle_label){
  
  read_xpt(path) %>%
    mutate(
      comorbidity =
        rowSums(
          select(., starts_with("MCQ160")) == 1,
          na.rm = TRUE
        ),
      cycle = cycle_label
    ) %>%
    select(
      pid = SEQN,
      comorbidity, 
      cycle
    )
}

mcq_all <- bind_rows(
  clean_mcq("MCQ_I.xpt","2015-2016"),
  clean_mcq("P_MCQ.xpt","2017-2020"),
  clean_mcq("MCQ_L.xpt","2021-2023")
)

saveRDS(mcq_all,"C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/mcq_all.rds")
