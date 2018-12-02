from keras.utils import plot_model
from keras.models import Sequential
from keras.layers import *
from keras.callbacks import EarlyStopping
from keras import optimizers

from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import MinMaxScaler

import csv
import matplotlib.pyplot as plt
import numpy as np

seed = 221
np.random.seed(221)

train_arr = ["./../Datasets/Regular/CS107Autumn2017dataset.csv", "./../Datasets/Regular/CS107Autumn2018dataset.csv", \
"./../Datasets/Regular/CS107Spring2017dataset.csv", "./../Datasets/Regular/CS107Winter2018dataset.csv"
]

test_arr = ["./../Datasets/Regular/CS107Spring2018dataset.csv"]


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


def create_model():
	model = Sequential()
	model.add(Dense(15, input_dim=14, kernel_initializer='he_normal', activation='relu'))
	#model.add(BatchNormalization())
	model.add(Dense(8, kernel_initializer='he_normal', activation='relu'))
	#model.add(BatchNormalization())
	model.add(Dense(1, activation='linear'))
	model.summary()

	# adam = optimizers.Adam(lr=0.001, decay=0.01)
	model.compile(loss='mse', optimizer='adam', metrics=['mse'])
	return model


if __name__ == "__main__":

	X_train, y_train = read_dataset(train_arr)
	X_test, y_test = read_dataset(test_arr)

	# normalizes input
	scaler = MinMaxScaler()
	scaler.fit(X_train)
	X_train_scaled = scaler.transform(X_train)
	X_test_scaled = scaler.transform(X_test)

	# creates model
	model = create_model()

	# trains model
	earlystop = EarlyStopping(monitor='val_loss', min_delta=0.0001, patience=7, \
                          verbose=1, mode='auto')
	history = model.fit(X_train_scaled, y_train, epochs=300, batch_size=64, callbacks = [earlystop], verbose=1, validation_split=0.05)

	# evaluates model
	score = model.evaluate(X_test_scaled, y_test, verbose=0)
	print('Test loss:', score[0])
	print('load influx diff:', np.sqrt(score[0]))

	# Plots training loss
	plt.plot(history.history['loss'])
	plt.plot(history.history['val_loss'])
	plt.title('model loss')
	plt.ylabel('loss')
	plt.xlabel('epoch')
	plt.legend(['train', 'validation'], loc='upper left')
	plt.show()

# 1. no dropout, 15, 8, 3, 1: 9553, 11504
# 2. no dropout, 15, 8, 1: 9413, 11428 --> so far best
# 2b. with dropout: 12259, 14018 --> nice graph.
# 2c. with batchnorm: 7375, 15611
# 3. no dropout, 15, 4, 1: 9683, 11778