library(tm)
library(dplyr) 
library(tidyr)
library(readr)
library(data.table)
library(ggplot2)
library(ggthemes)
library(rtweet)
library(wordcloud)
library(lubridate)
library(syuzhet)
library(scales)
options(max.print=100000)

CorpusCleanup <- function(userstopwords = '') {

  mainFile = read_csv(file.choose(), T)
  
  #Create stopwords
  stopwords <- stopwords("en")
  stopwords_all <- c(stopwords, userstopwords)
  
  #Build corpus
  corpus <- iconv(mainFile$text, to = "utf-8")
  corpus <- Corpus(VectorSource(corpus))
  
  #Clean text
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  cleanset <- tm_map(corpus, removeWords, stopwords_all)
  
  removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
  cleanset <- tm_map(cleanset, content_transformer(removeURL))
  cleanset <- tm_map(cleanset, stripWhitespace)
  
  return(cleanset)
}

frequencyBarPlot <- function(cleanset) {

  #Term document matrix
  tdm <- TermDocumentMatrix(cleanset)
  tdm <- as.matrix(tdm)
  
  #Bar plot
  w <- rowSums(tdm)
  w <- subset(w, w>=160)
  
  barplot(w,
          las = 1,
          col = rainbow(50))
  w < as.data.frame(w, row.names = NULL, optional = TRUE)
  
}

#sentiFile = read_csv(file.choose(), T)

bagOfWordsSentiment <- function(plotTitle = '') {

  sentiFile = read_csv(file.choose(), T)
  # Read file
  sentiment <- sentiFile
  sentimentText <- iconv(sentiment$text, to = 'utf-8')
  
  # Obtain sentiment scores
  s <- get_nrc_sentiment(sentimentText)
  get_nrc_sentiment('delay')
  
  # Bar plot
  barplot(colSums(s),
          las = 2,
          col = rainbow(10),
          ylab = 'Count',
          main = plotTitle)
  
}
