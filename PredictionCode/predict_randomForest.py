import csv
import itertools
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn import metrics
from sklearn.model_selection import KFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import make_classification

seed = 221
np.random.seed(221)

NUM_BINS = 7

train_arr = ["./../Datasets/Regular/CS107Autumn2017dataset.csv", "./../Datasets/Regular/CS107Autumn2018dataset.csv", \
"./../Datasets/Regular/CS107Spring2017dataset.csv", "./../Datasets/Regular/CS107Winter2018dataset.csv", \
"./../Datasets/Regular/CS110Autumn2018dataset.csv", "./../Datasets/Regular/CS110Spring2018dataset.csv", \
"./../Datasets/Regular/CS161Autumn2017dataset.csv", "./../Datasets/Regular/CS161Spring2017dataset.csv", \
"./../Datasets/Regular/CS229Autumn2018dataset.csv", "./../Datasets/Regular/CS107Spring2018dataset.csv"
]


def read_dataset(arr):
	X, y = [], []
	for q, quarter in enumerate (arr):

		f = open(quarter, 'r')
		reader = csv.reader(f)
		raw_data = [row for row in reader]
		key = {k:v for k, v in enumerate(raw_data[0])}

		# removes 0, sign_ups, serves, avg_wait_time, avg_serve_time, avg_day_serve_time, load_influx
		toRemove = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 37, 38, 39, 40]
		for index in toRemove:
			del key[index]

		for i, d in enumerate(raw_data):
			if i == 0:
				continue	

			load_influx = float(d[8]) 
			y.append(load_influx)
			X.append([float(d[f]) for f in key.keys()])

		for i, j in enumerate(raw_data[0]):
			print (i, j)
	X, y = np.asarray(X), np.asarray(y).reshape((-1, 1))
	return X, y


def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.tight_layout()


# Logspace from 1 to 1024, 10 bins

if __name__ == "__main__":
	X, y_continuous = read_dataset(train_arr)
	print (np.max(y_continuous))

	bins = np.logspace(0, 10, num=NUM_BINS, base = 2)

	print ("Bins:")
	print (bins)
	y = np.digitize(y_continuous, bins)

	y = y.reshape((-1, ))

	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=221)

	clf = RandomForestClassifier(n_estimators=10000, random_state=221)
	clf.fit(X_train, y_train)

	# print ("Important features:")
	# for i, e in clf.feature_importances_:
	# 	print (i, e)
	# print(clf.feature_importances_)

	print ("Predicted:")
	predicted = clf.predict(X_test)
	print (predicted)

	print ("Accuracy score:")
	print (metrics.accuracy_score(predicted, y_test))
	raise
	cm = metrics.confusion_matrix(y_test, predicted)
	print("Confusion matrix:\n%s" % cm)
	np.set_printoptions(precision=2)

	# Plot non-normalized confusion matrix
	plt.figure()
	plot_confusion_matrix(cm, classes=np.around(bins, decimals=1),
	                      title='RF Confusion matrix, without normalization')

	# Plot normalized confusion matrix
	plt.figure()
	plot_confusion_matrix(cm, classes=np.around(bins, decimals=1), normalize=True,
	                      title='Normalized RF confusion matrix')

	plt.show()


