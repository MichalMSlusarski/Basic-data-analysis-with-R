library(tm)
library(dplyr) 
library(tidyr)
library(readr)
library(data.table)
library(rtweet)
options(max.print=100000)

basicCleanup <- function(dateFrom = "20221201",dateTo = "20221201", minFavourite = 0, minRetweet = 0) {

  #1. Merge ALL files form path
  obs <- list.files(path=readline(), T, full.names = TRUE) %>% lapply(read_csv) %>% bind_rows 

  #1.5 Select needed dates.
  obs <- filter(obs, created_at < dateTo)

  #1.6 Remove retweets
  obs <- filter(obs, is_retweet == FALSE)

  #2. Remove Duplicated 
  obs <- obs %>% distinct(status_id, .keep_all = TRUE)

  #2.25 Filter by favorite_count count and retweet_count
  obs <- filter(obs, favorite_count > minFavourite | retweet_count > minRetweet)

  #2.3 Select distinct by text so that there are no two identical tweets.
  obs <- obs %>% distinct(text, .keep_all = TRUE)

  #2.4 Select by users
  obs <- obserwacje_all_distinct %>% distinct(user_id, .keep_all = TRUE)

  #3. Select needed variables
  obs <- obs %>% dplyr::select(user_id, status_id, created_at, screen_name, text)

  #4. CSV for export
  write_as_csv(obs, file = "obserwacje_reference", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

}




