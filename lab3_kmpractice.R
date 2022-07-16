library(tidyverse)
library(tidytext)
library(SnowballC)
library(topicmodels) #LDA algo
library(stm) # for lda viz
library(ldatuning)
library(knitr)
library(LDAvis) #also lda viz


#read in data
ts_forum_data <- read_csv("lab-3/data/ts_forum_data.csv", 
                          col_types = cols(course_id = col_character(),
                                           forum_id = col_character(), 
                                           discussion_id = col_character(), 
                                           post_id = col_character()
                          )
)

#tokenize
forums_tidy <- ts_forum_data %>%
  unnest_tokens(output = word, input = post_content) %>%
  anti_join(stop_words, by = "word")

forums_tidy

forum_quotes <- ts_forum_data %>%
  select(post_content) %>% 
  filter(grepl(" time ", post_content))

sample_n(forum_quotes,10)

#cast document term matrix
forums_dtm <- forums_tidy %>%
  count(post_id, word) %>%
  cast_dtm(post_id, word, n)
