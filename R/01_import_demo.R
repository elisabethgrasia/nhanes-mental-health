library(haven)

# Demographic data
setwd('C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_raw/Demographic')

# first try for DEMO_L dataset 
demo <- read_xpt('DEMO_L.xpt')
class(demo)

View(demo)

library(dplyr)

demo2 <- demo %>%
  mutate(age_group = case_when(
    RIDAGEYR < 18 ~ "child",
    RIDAGEYR < 65 ~ "adult",
    TRUE ~ "older"
  ))

glimpse(demo2)
summary(demo2$age_group)

demo_clean <- demo2 %>%
  select(
    SEQN,
    RIAGENDR,
    RIDAGEYR,
    RIDRETH1,
    DMDEDUC2,
    INDFMPIR,
    WTMEC2YR,
    age_group
  )

demo_clean <- demo_clean %>%
  rename(
    pid = SEQN,
    sex = RIAGENDR,
    age = RIDAGEYR,
    education = DMDEDUC2,
    poverty_ratio = INDFMPIR,
    ethnicity = RIDRETH1,
    weight = WTMEC2YR
  )

# selecting the adult and older group only
demo_clean <- demo_clean %>%
  filter(age >= 18)

# grouping the income group
demo_clean <- demo_clean %>%
  mutate(
    income_group = case_when(
      poverty_ratio < 1 ~ "Below poverty",
      poverty_ratio < 2 ~ "Low income",
      poverty_ratio < 4 ~ "Middle income",
      TRUE ~ "High income"
    )
  )

# convert the sex
demo_clean <- demo_clean %>%
  mutate(
    sex = factor(sex,
                 levels = c(1, 2),
                 labels = c("Male", "Female"))
  )

# convert the education
demo_clean <- demo_clean %>%
  mutate(
    education = factor(education)
  )


glimpse(demo_clean)

# Combining with two other datasets (2015-2020 dataset)
clean_demo <- function(path, cycle_label) {
  read_xpt(path) %>%
    transmute(
      pid           = SEQN,
      sex           = RIAGENDR,
      age           = RIDAGEYR,
      ethnicity     = RIDRETH1,
      education     = DMDEDUC2,
      poverty_ratio = INDFMPIR,
      cycle         = cycle_label
    ) %>%
    mutate(
      age_group = case_when(
        age < 18 ~ "child",
        age < 65 ~ "adult",
        TRUE ~ "older"
      ),
      income_group = case_when(
        is.na(poverty_ratio) ~ NA_character_,
        poverty_ratio < 1 ~ "Below poverty",
        poverty_ratio < 2 ~ "Low income",
        poverty_ratio < 4 ~ "Middle income",
        TRUE ~ "High income"
      ),
      sex = factor(sex,
        levels = c(1, 2),
        labels = c("Male", "Female")
      ),
      education = factor(education),
    )
}

demo_all <- bind_rows(
  clean_demo("DEMO_I.xpt", "2015-2016"),
  clean_demo("P_DEMO.xpt", "2017-2020"),
  clean_demo("DEMO_L.xpt", "2021-2023")
)

glimpse(demo_all)

saveRDS(demo_all, "C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/demo_all.rds")
