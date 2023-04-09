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

x = readLines(here("data/questionposts.csv"))

split = strsplit(x, ",")

col_names = split[[1]]

ids <- c()
state <- c()
question_id <- c()
posts <- c()
date <- c()

for (i in 2:406189) {
  print(i/406189)
  if (split[[i]][1] %in% 1:406189) {
    ids <- append(ids, split[[i]][1])
    state <- append(state, split[[i]][2])
    question_id <- append(question_id, split[[i]][3])
    posts <- append(posts, split[[i]][4])
    last <- length(split[[i]])
    date <- append(date, split[[i]][last])
    if (last > 5) {
      for (k in 5:(last-1)) {
        if (!is.na(split[[i]][k])) {
          posts[i-1] <- paste0(posts[i-1], " ", split[[i]][k])
        }
      }
    }
  }
}

y = gsub('\",\"', "\',\'", x)
y = gsub('\"\n', "\',\'", y)
# replace double quotes for each field
#y = gsub('^"|"$', "'", x) # replace trailing and leading double quotes
z = paste(y, collapse='\n') # turn it back into a table for fread to read
# df = data.table::fread(z, quote="'", comment)
# df
question_posts <-read_tsv(here("data/questionposts.csv"), quote = "\"", comment.char = "@")

p <- question_posts |>
  mutate(row = 1:nrow(question_posts)) |>
  ifelse(Id != row)
  
write_lines(y, here("data/bs.csv"))
df <- read.csv2(here("data/bs.csv"), quote = "\'", sep = ",", comment.char = "@")
  
col <- colnames(df)
df |>
  separate(col = !! sym(col), sep = ",")


df |> col_names
df |>
  separate("1", )
questions <- import(here("data/questions.csv"))
state_sites <- import(here("data/statesites.csv"))
sub_categories <- import(here("data/subcategories.csv"))