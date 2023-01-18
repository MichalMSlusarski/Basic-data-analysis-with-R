# Na podstawie: F. Nwanganga, M. Chapple: Praktyczne uczenie maszynowe w języku R. Gliwice 2022.
# Plik do wykorzystania: email.csv

library(tidyverse)
install.packages("e1071")

# Wgrywanie pliku z danymi i podgląd danych

email <- read_csv("email.csv")
head(email)

# Przekształcenie zmiennej email_label w zmienną typu factor 
email <- email %>%
  mutate(message_label = as.factor(message_label))

# Przestawienie danych z kolumn w wiersze
email %>%
  gather(word, count,-message_index, -message_label)

# Tworzenie zbioru danych treningowych i testowych
set.seed(1234)
sample_set <- sample(nrow(email), round(nrow(email)*.75), replace = FALSE)
email_train <- email[sample_set, ]
email_test <- email[-sample_set, ]

# Rozkład klas dla zbiorów danych
round(prop.table(table(select(email, message_label))),2)
round(prop.table(table(select(email_train, message_label))),2)
round(prop.table(table(select(email_test, message_label))),2)

# Załadowanie pakietu 
library(e1071)

# Użycie funkcji naiveBayes z pakietu e1071
email_mod <-
  naiveBayes(message_label ~ . - message_index,
             data = email_train,
             laplace = 1)

# Funkcja predict() służy do przewidywania klasy na podstawie danych testowych. 
email_pred <- predict(email_mod, email_test, type = "class")
head(email_pred)


# Macierz pomyłek
email_pred_table <- table(email_test$message_label, email_pred)
email_pred_table

# Dokładność predykcji
sum(diag(email_pred_table)) / nrow(email_test)
