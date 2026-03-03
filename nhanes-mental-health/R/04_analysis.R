analysis_data <- readRDS("C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/data_clean/analysis_data.rds")

glm(
  depressed ~ poverty_ratio + age + sex,
  data = analysis_data,
  family = binomial
)

colSums(is.na(analysis_data))

# Model Comparison
m0 <- glm(depressed ~ 1, data=analysis_data, family=binomial)

m1 <- glm(depressed ~ poverty_ratio + age + sex,
          data=analysis_data, family=binomial)

m2 <- glm(depressed ~ poverty_ratio + age + sex +
            comorbidity + uninsured,
          data=analysis_data, family=binomial)

AIC(m0, m1, m2)

# the AIC comparison shows that the different dataset is used because of the missing values. Thus, AIC comparison is not fair.

# Comparing the models with same dataset
analysis_complete <- analysis_data %>%
  select(
    depressed,
    poverty_ratio,
    age,
    sex,
    comorbidity,
    uninsured
  ) %>%
  na.omit()

m0 <- glm(depressed ~ 1,
          data = analysis_complete,
          family = binomial)

m1 <- glm(depressed ~ poverty_ratio + age + sex,
          data = analysis_complete,
          family = binomial)

m2 <- glm(depressed ~ poverty_ratio + age + sex +
            comorbidity + uninsured,
          data = analysis_complete,
          family = binomial)

AIC(m0, m1, m2)

## RESULT TABLES
library(broom)
library(dplyr)

results <- tidy(m2) # I use the best model
results

# Converting the results to odds ratios
or_table <- tidy(m2, conf.int = TRUE) %>%
  mutate(
    odds_ratio = exp(estimate),
    conf.low = exp(conf.low),
    conf.high = exp(conf.high)
  ) %>%
  select(
    term,
    odds_ratio,
    conf.low,
    conf.high,
    p.value
  )

or_table

or_table <- or_table %>%
  mutate(
    term = recode(term,
                  poverty_ratio = "Income-to-poverty ratio",
                  age = "Age",
                  sexFemale = "Female (vs Male)",
                  comorbidity = "Number of chronic conditions",
                  uninsured = "Uninsured"
    )
  )

write.csv(
  or_table,
  "C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/outputs/logistic_regression_results.csv",
  row.names = FALSE
)

# Visualization
library(ggplot2)

plot_data <- or_table %>%
  filter(term != "(Intercept)")

ggplot(plot_data,
       aes(x = odds_ratio,
           y = reorder(term, odds_ratio))) +
  
  geom_point(size = 3) +
  
  geom_errorbarh(
    aes(xmin = conf.low,
        xmax = conf.high),
    height = 0.2
  ) +
  
  geom_vline(xintercept = 1,
             linetype = "dashed") +
  
  labs(
    title = "Factors Associated with Depression",
    x = "Odds Ratio (95% CI)",
    y = ""
  ) +
  
  theme_minimal()


ggsave(
  "C:/Users/elisa/OneDrive/Documents/nhanes-mental-health/outputs/depression_odds_ratio_plot.png",
  width = 8,
  height = 5,
  dpi = 300
)
