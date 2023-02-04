# Analiza URL.
# Na podstawie: E. Tsukerman: Machine Learning for Cybersecurity Cookbook. Packt Publishing 2019.
# Pliki do wykorzystania: test.csv i train. csv

pip install sklearn pandas

import pandas as pd
import sklearn

# Wczytanie plików train.csv i test.csv
from google.colab import files
uploaded=files.upload()

train_CSV = ("train.csv")
test_CSV = ("test.csv")

train_df = pd.read_csv(train_CSV)
test_df = pd.read_csv(test_CSV)

# Pobranie danych treningowych i testowych z kolumny "target" i zapisanie ich jako wartości zmiennych y_train i y_test.
y_train = train_df.pop("target").values
y_test = test_df.pop("target").values

# Tworzy dwie zmienne X_train i X_test. Zmienne te są ustawiane na wartości zwracane przez funkcje train_df.values i test_df.values.
X_train = train_df.values
X_test = test_df.values

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix

# Wykorzystanie lasu losowego do przewidywania klas dla danych testowych. Pokazuje dokładność przewidywania oraz macierz błędów.
clf = RandomForestClassifier()
clf.fit(X_train, y_train)
y_test_pred = clf.predict(X_test)
print(accuracy_score(y_test, y_test_pred))
print(confusion_matrix(y_test, y_test_pred))
