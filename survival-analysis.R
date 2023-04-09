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

glmme_q_times <- glmer(difference_days ~ state_abbr + subcategory +
       state_abbr*sub_categories + (1 | taken_by_attorney_uno),
     data = questions, family = exponential(link = log))
                                
mod <- survreg(Surv(difference_days, delta) ~ subcategory,
               data = questions |> filter(state_abbr == "TX"),
               cluster = taken_by_attorney_uno, dist = "exponential")
summary(mod)
                                