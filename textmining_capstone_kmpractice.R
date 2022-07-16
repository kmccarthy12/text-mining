library(tidyverse)
library(tidymodels)
library(textrecipes)
library(discrim) #naive Bayes model is available in the tidymodels package discrim.

library(readr)
crs <- read_csv("~/Desktop/cr_all_LASER/crs_overallscore.csv") %>%
  select(SelfExplanation, overall)

crs$overall <- factor(crs$overall, 
                      levels = c(0,1,2,3), 
                      labels = c("poor", "fair", "good", "great"))

# split into training/test
crs_split <- initial_split(crs, strata = overall)
crs_train <- training(crs_split)
crs_test <- testing(crs_split)

# check the dimensions of the two splits with the function `dim()`
dim(crs_train)
dim(crs_test)
