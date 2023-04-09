# PURPOSE: Visualize 


# Load packages -----------------------------------------------------------

library(tidyverse)
library(rio)
library(survival)
library(here)
library(lubridate)

# Load data ---------------------------------------------------------------

i_am("survival-analysis.R")
questions <- import(here("data/questions.csv"))

# Wrangle -----------------------------------------------------------------

questions <- janitor::clean_names(questions)

questions <- questions |>
  filter(taken_on_utc != "NULL") |>
  mutate(asked = ymd_hms(asked_on_utc),
         taken = ymd_hms(taken_on_utc),
         difference_sec = (taken - asked)/dseconds(),
         difference_days = difference_sec/(60*60*24),
         delta = 1
        )

# glmme_q_times <- glmer(difference_days ~ state_abbr + subcategory +
#        state_abbr*sub_categories + (1 | taken_by_attorney_uno),
#      data = questions, family = exponential(link = log))
                                
mod <- survreg(Surv(difference_days, delta) ~ category,
               data = questions |> filter(state_abbr == "FL"),
               cluster = taken_by_attorney_uno, dist = "exponential")
summary(mod)

convert_coef <- function(coef) {
  exp(mod$coefficients[[1]] + mod$coefficients[[coef]])/exp(mod$coefficients[[1]])
}


coef_vals <- c(1, map_dbl(2:10, ~ convert_coef(.x)))
sds <- map_dbl(1:10, ~ summary(mod)$table[,2][[.x]])
cats <- sort(unique(questions$category))

coef_tbl <- tibble(coef_val = coef_vals, sds = sds, category = cats)

coef_tbl <- coef_tbl |>
  mutate(lower = coef_vals - 1.96*sds,
         upper = coef_vals + 1.96*sds) 

# Title: Health + Disability and Individual Rights Questions Take Longer
# to Get Taken On By Lawyer in Florida
hazard_plot <- ggplot(coef_tbl, aes(x = category, y = coef_val)) +
  geom_point() +
  theme_bw() +
  geom_errorbar(aes(ymin = lower, ymax = upper)) +
  geom_hline(yintercept=1, linetype='dotted', col = 'red') +
  labs(x = "Question Category", y = "Hazard Ratio") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

saveRDS(hazard_plot, "hazard-plot.Rds")
                                