library(tm) # for text mining
library(dplyr) 
library(tidyr)
library(readr)
library(data.table)
library(ggplot2)
library(ggthemes)
library(rtweet)
options(max.print=100000)

#1. Merge ALL files  
obserwacje_all <- read_csv("/cloud/project/ov2_this_week.csv")
obserwacje_all <- list.files(path="/cloud/project/AnalizaSentymentu_Dane", full.names = TRUE) %>% lapply(read_csv) %>% bind_rows 

#1.5 Select needed dates. I suggest we go with 2 first weeks.
obserwacje_all_two_weeks <- filter(obserwacje_all, created_at < "2022-01-14")

#1.6 Remove retweets!
obserwacje_all_two_weeks_NRT <- filter(obserwacje_all_two_weeks, is_retweet == FALSE)

#2. Remove Duplicated 
obserwacje_all_distinct <- obserwacje_all_two_weeks_NRT %>% distinct(status_id, .keep_all = TRUE)

#2.25 Filter by favorite_count count and retweet_count // NIE RÓB TEGO, BO SĄ BRAKI!
obserwacje_filtered <- filter(obserwacje_all_distinct_by_text, favorite_count > 0 | retweet_count > 0)

#2.3 Select distinct by text so that there are no two identical tweets. //można powtórzyć po usunięciu linków
obserwacje_all_distinct_by_text <- obserwacje_all %>% distinct(text, .keep_all = TRUE)

#2.5 Select by users //niestety tu przydałoby się aby jednak wybrać tweety najlepsze danej osoby
#obserwacje_all_distinct_2 <- obserwacje_all_distinct %>% distinct(user_id, .keep_all = TRUE)
#obserwacje_filtered_distinct <- obserwacje_filtered %>% distinct(user_id, .keep_all = TRUE) #now this

#3. Select needed variables

obserwacje_ <- obserwacje_all_distinct %>% dplyr::select(user_id, status_id, created_at, screen_name, text)

write_as_csv(obserwacje_, file = "obserwacje_reference", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
#4. Remove @s, https// from tweets and tweets with no content

#Done in sheets

#5. After removing all the clutter, re-upload this csv file here

obserwacje_cleaned <- read_csv("obserwacje_all_distinct_selected_new_cleaned.csv") #jeszcze się powtarzają więc trzeba jeszcze raz text filter zrobić
obserwacje_cleaned <- obserwacje_cleaned %>% distinct(text_cleanest, .keep_all = TRUE)
obserwacje_cleaned_2 <- filter(obserwacje_cleaned, char_count > 15 & char_count < 285)
obserwacje_cleaned_3 #first export, get rid of pisorgpl bulshit

#6. Divide data for each day. TODO. But first we should get rid of even more SPAM!

obserwacje_1_01 <- filter(obserwacje_cleaned_2, created_at < "2022-01-02")
obserwacje_1_02 <- filter(obserwacje_cleaned_2, created_at > "2022-01-02" & created_at < "2022-01-03")
obserwacje_1_03 <- filter(obserwacje_cleaned_2, created_at > "2022-01-03" & created_at < "2022-01-04")
obserwacje_1_04 <- filter(obserwacje_cleaned_2, created_at > "2022-01-04" & created_at < "2022-01-05")
obserwacje_1_05 <- filter(obserwacje_cleaned_2, created_at > "2022-01-05" & created_at < "2022-01-06")
obserwacje_1_06 <- filter(obserwacje_cleaned_2, created_at > "2022-01-06" & created_at < "2022-01-07")


#CLEANUP:

obserwacje_1_01 <- NULL
obserwacje_1_02 <- NULL
obserwacje_1_03 <- NULL
obserwacje_1_04 <- NULL
obserwacje_1_05 <- NULL
obserwacje_1_06 <- NULL

obserwacje_all_distinct_selected <- NULL
obserwacje_all_two_weeks <- NULL
obserwacje_all_two_weeks_NRT <- NULL
obserwacje_all_distinct_2 <- NULL
obserwacje_all_distinct <- NULL
obserwacje_filtered <- NULL
obserwacje_filtered_distinct <- NULL
obserwacje_all <- NULL
obserwacje_all_distinct_by_text <- NULL

