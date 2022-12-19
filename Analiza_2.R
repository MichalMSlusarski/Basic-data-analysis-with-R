library(dplyr) 
library(tidyr)
library(readr)
library(data.table)
library(rtweet)
options(max.print=100000)

#1. Merge ALL files  
obserwacje_all <- list.files(path=file.choose(), T, full.names = TRUE) %>% lapply(read_csv) %>% bind_rows 

#1.5 Select needed dates. I suggest we go with 2 first weeks.
obserwacje_all_two_weeks <- filter(obserwacje_all, created_at < "2022-01-14")

#1.6 Remove retweets
obserwacje_all_two_weeks_NRT <- filter(obserwacje_all_two_weeks, is_retweet == FALSE)

#2. Remove Duplicated 
obserwacje_all_distinct <- obserwacje_all_two_weeks_NRT %>% distinct(status_id, .keep_all = TRUE)

#2.25 Filter by favorite_count count and retweet_count
obserwacje_filtered <- filter(obserwacje_all_distinct_by_text, favorite_count > 0 | retweet_count > 0)

#2.3 Select distinct by text so that there are no two identical tweets.
obserwacje_all_distinct_by_text <- obserwacje_all %>% distinct(text, .keep_all = TRUE)

#2.5 Select by users //niestety tu przydałoby się aby jednak wybrać tweety najlepsze danej osoby
obserwacje_all_distinct_2 <- obserwacje_all_distinct %>% distinct(user_id, .keep_all = TRUE)
obserwacje_filtered_distinct <- obserwacje_filtered %>% distinct(user_id, .keep_all = TRUE) #now this

#3. Select needed variables

obserwacje_ <- obserwacje_all_distinct %>% dplyr::select(user_id, status_id, created_at, screen_name, text)
write_as_csv(obserwacje_, file = "obserwacje_reference", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

#4. Remove @s, https// from tweets and tweets with no content




