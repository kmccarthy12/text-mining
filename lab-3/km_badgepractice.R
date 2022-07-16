library(readr)
library(tidyverse)
library(tidytext)
library(SnowballC)
library(topicmodels) #LDA algo
library(stm) # for lda viz
library(ldatuning)
library(knitr)
library(LDAvis) #also lda viz

#read in df that shows forum discussions
ts_forum_data <- read_csv("lab-3/data/ts_forum_data.csv", 
                          col_types = cols(course_id = col_character(),
                                           forum_id = col_character(), 
                                           discussion_id = col_character(), 
                                           post_id = col_character()
                          )
)

#tokenize the forum data
forums_tidy <- ts_forum_data %>%
  unnest_tokens(output = word, input = post_content) %>%
  anti_join(stop_words, by = "word")

forums_tidy