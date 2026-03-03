demo_all <- readRDS("C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/demo_all.rds")
dpq_all  <- readRDS("C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/dpq_all.rds")
mcq_all  <- readRDS("C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/mcq_all.rds")
hiq_all  <- readRDS("C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/hiq_all.rds")

analysis_data <- demo_all %>%
  left_join(dpq_all, by = c("pid","cycle")) %>%
  left_join(mcq_all, by = c("pid","cycle")) %>%
  left_join(hiq_all, by = c("pid","cycle"))

analysis_data <- analysis_data %>%
  filter(age >= 18)


saveRDS(analysis_data, "C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/analysis_data.rds")