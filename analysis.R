# PURPOSE: Data Exlporation


# Load packages -----------------------------------------------------------
library(here)
library(rio)
library(tidyverse)

# Load data ---------------------------------------------------------------

attorneys <- import(here("data/attorneys.csv"))
attorney_time_entries <- import(here("data/attorneytimeentries.csv"))
categories <- import(here("data/categories.csv"))
clients <- import(here("data/clients.csv"))
question_posts <- read.csv(here("data/questionposts.csv"), quote = "\"\"", text=csv, header=TRUE, sep=",", comment.char = '@')
  
import(here("data/questionposts.csv"), comment.char = "@")
  
  data.table::fread(here("data/questionposts.csv"), quote = "")
questions <- import(here("data/questions.csv"))
state_sites <- import(here("data/statesites.csv"))
sub_categories <- import(here("data/subcategories.csv"))