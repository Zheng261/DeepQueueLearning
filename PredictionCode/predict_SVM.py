import csv
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn import metrics
from sklearn.model_selection import KFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.svm import SVC

seed = 221
np.random.seed(221)

NUM_BINS = 20

train_arr = ["./../Datasets/Regular/CS107Autumn2017dataset.csv", "./../Datasets/Regular/CS107Autumn2018dataset.csv", \
"./../Datasets/Regular/CS107Spring2017dataset.csv", "./../Datasets/Regular/CS107Winter2018dataset.csv", "./../Datasets/Regular/CS107Spring2018dataset.csv"
]


def read_dataset(arr):
	X, y = [], []
	for q, quarter in enumerate (arr):

		f = open(quarter, 'r')
		reader = csv.reader(f)
		raw_data = [row for row in reader]
		key = {k:v for k, v in enumerate(raw_data[0])}

		# removes 0, sign_ups, serves, avg_wait_time, avg_serve_time, avg_day_serve_time, load_influx
		toRemove = [0, 1, 2, 4, 5, 7, 8]
		for index in toRemove:
			del key[index]

		for i, d in enumerate(raw_data):
			if i == 0:
				continue	

			load_influx = float(d[8]) 
			y.append(load_influx)
			X.append([float(d[f]) for f in key.keys()])

		# for i, j in enumerate(raw_data[0]):
		# 	print (i, j)
	X, y = np.asarray(X), np.asarray(y).reshape((-1, 1))
	return X, y


# Logspace from 1 to 1024, 10 bins

if __name__ == "__main__":
	X, y_continuous = read_dataset(train_arr)

	bins = np.logspace(0, 10, num=NUM_BINS, base = 2)
	print (bins)
	y = np.digitize(y_continuous, bins)

	y = y.reshape((-1, ))

	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=221)

	clf = SVC(C=1, gamma='auto')
	clf.fit(X_train, y_train)
	predicted = clf.predict(X_test)

	print ("Predicted:")
	print (predicted)

	print ("Accuracy score:")
	print (metrics.accuracy_score(predicted, y_test))
	
	cm = metrics.confusion_matrix(y_test, predicted)
	print("Confusion matrix:\n%s" % cm)

