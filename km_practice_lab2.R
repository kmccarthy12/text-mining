library(tidyverse)
library(tidytext)
library(readxl)

################
## Data Wrangling
################

ngss_tweets <- read_xlsx("lab-2/data/ngss_tweets.xlsx")
ccss_tweets <- read_xlsx("lab-2/data/csss_tweets.xlsx")

#ngss_tweets <- read_xlsx("data/ngss_tweets.xlsx")
#ccss_tweets <- read_xlsx("data/csss_tweets.xlsx")

#select and filter relevant columns
ngss_text <-
  ngss_tweets %>%
  filter(lang == "en") %>%
  select(screen_name, created_at, text) %>%
  mutate(standards = "ngss") %>%
  relocate(standards)

#select and filter relevant columns
ccss_text <-
  ccss_tweets %>%
  filter(lang == "en") %>%
  select(screen_name, created_at, text) %>%
  mutate(standards = "ccss") %>%
  relocate(standards)

#bind
tweets <- bind_rows(ngss_text, ccss_text)

################
## Tokenizing & Prep
################

#tokenize at the word level
tweet_tokens <- 
  tweets %>%
  unnest_tokens(output = word, 
                input = text, 
                token = "tweets")

#remove stop words
tidy_tweets <-
  tweet_tokens %>%
  anti_join(stop_words, by = "word") %>% #remove stop words
  filter(!word == "amp") #remove html residue

################
## Get Sentiment Dictionaries
################

#read in dictionaries
afinn <- get_sentiments("afinn")
bing <- get_sentiments("bing")
nrc <- get_sentiments("nrc")
loughran <- get_sentiments("loughran")

#match common words from tweet df and afinn dictionary
sentiment_afinn <- inner_join(tidy_tweets, afinn, by = "word")

sentiment_afinn #check values

# same (innerjoin) with bing dictionary
sentiment_bing <- inner_join(tidy_tweets, bing, by = "word")

sentiment_bing

#same innerjoin with nrc dictionary
sentiment_nrc <- inner_join(tidy_tweets, nrc, by = "word")

sentiment_nrc

#same for loughran
sentiment_loughran <- inner_join(tidy_tweets, loughran, by = "word")

sentiment_loughran

################
## Sentiment Analysis: Bing
################

summary_bing <- sentiment_bing %>% 
  group_by(standards) %>% #compare groups
  count(sentiment, sort = TRUE) %>% #count frequency
  mutate(lexicon = "bing") %>% #add variable to identify lexicon/dictionary
  relocate(lexicon) #moves lexicon to first col position

summary_bing

################
## Sentiment Analysis: afinn
################

summary_afinn <- 
  sentiment_afinn %>% 
  mutate(sentiment = ifelse(value < 0, "negative", "positive")) %>% #create categorical valence
  group_by(standards) %>%
  count(sentiment, sort = TRUE) %>%
  mutate(lexicon = "afinn") %>% #add variable to identify lexicon/dictionary
  relocate(lexicon)
  
summary_afinn %>%
  m

################
## Sentiment Analysis: nrc
################

summary_nrc <-
  sentiment_nrc %>%
  filter(sentiment == "positive"|sentiment == "negative") %>% #select only pos and sentiments
  group_by(standards) %>%
  count(sentiment, sort = TRUE) %>%
  mutate(lexicon = "nrc") %>% #add varible to identify lexicon/dictionary
  relocate(lexicon) #moves lexicon to first col position

summary_nrc


################
## Sentiment Analysis: loughran
################
  
summary_loughran <-
  sentiment_loughran %>%
  filter(sentiment == "positive"|sentiment == "negative") %>%
  group_by(standards) %>%
  count(sentiment, sort = TRUE) %>%
  mutate(lexicon = "loughran") %>%
  relocate(lexicon)
  
summary_loughran

################
## Visualization
################

#create main file

sentiment_all <- bind_rows(summary_afinn, summary_bing, summary_nrc, summary_loughran)

sentiment_all <- sentiment_all %>%
  mutate(sentiment = as.factor(sentiment))
str(sentiment_all)

ggplot(sentiment_all, aes(x = standards, y = n, fill = sentiment)) +
         geom_col(position = "dodge") +
  facet_wrap(~lexicon) 

