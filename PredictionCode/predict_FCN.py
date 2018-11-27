from keras.utils import plot_model
import csv
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense
from tensorflow.python.keras.wrappers.scikit_learn import KerasRegressor

seed = 221
np.random.seed(221)

quarters = ["Datasets/CS107Autumn2017dataset.csv", "Datasets/CS107Autumn2018dataset.csv", \
"Datasets/CS107Spring2017dataset.csv", "Datasets/CS107Spring2018dataset.csv", "Datasets/CS107Winter2018dataset.csv"]



def read_dataset():
	X, y = [], []
	for quarter in quarters:
		f = open(quarter, 'r')
		reader = csv.reader(f)
		raw_data = [row for row in reader]
		key = {k:v for k, v in enumerate(raw_data[0])}

		toRemove = [0, 1, 2, 4, 5, 7, 8]
		for index in toRemove:
			del key[index]

		for i, d in enumerate(raw_data):
			if i == 0:
				continue			
			total_wait_time = float(d[8]) 
			assert total_wait_time >= 0
			y.append(total_wait_time)
			X.append([float(d[f]) for f in key.keys()])

		for i, j in enumerate(raw_data[0]):
			print (i, j)

	X, y = np.asarray(X), np.asarray(y).reshape((-1, 1))

	return X, y

def normalize_input(X, y):
	scaler = MinMaxScaler()
	print(scaler.fit(X))
	print(scaler.fit(y))
	xscale=scaler.transform(X)
	yscale=scaler.transform(y)
	return xscale, yscale

def baseline_model():
	# create model
	model = Sequential()
	model.add(Dense(13, input_dim=17, kernel_initializer='he_normal', activation='relu'))
	model.add(Dense(1, kernel_initializer='normal'))
	# Compile model
	model.compile(loss='mean_squared_error', optimizer='adam')
	return model

if __name__ == "__main__":
	X, y = read_dataset()
	print (X.shape, y.shape)
	scaler = MinMaxScaler()
	scaler.fit(X)
	# X_scaled, y_scaled = normalize_input(X, y)
	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=221)
	#X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=221)
	X_train_scaled = scaler.transform(X_train)
	model = Sequential()
	model.add(Dense(15, input_dim=14, kernel_initializer='he_normal', activation='relu'))
	model.add(Dense(8, kernel_initializer='he_normal', activation='relu'))
	model.add(Dense(3, kernel_initializer='he_normal', activation='relu'))
	model.add(Dense(1, activation='linear'))
	model.summary()
	model.compile(loss='mse', optimizer='adam', metrics=['mse'])

	history = model.fit(X_train_scaled, y_train, epochs=300 , batch_size=64,  verbose=1, validation_split=0.05)

	X_test_scaled = scaler.transform(X_test)

	score = model.evaluate(X_test_scaled, y_test, verbose=0)
	print('Test loss:', score[0])
	print('load influx diff:', np.sqrt(score[0]))
	# predicted = model.predict(X_test)
	# print (y_test)
	# print (predicted - y_test)



	# "Loss"
	plt.plot(history.history['loss'])
	plt.plot(history.history['val_loss'])
	plt.title('model loss')
	plt.ylabel('loss')
	plt.xlabel('epoch')
	plt.legend(['train', 'validation'], loc='upper left')
	plt.show()

	# model = Sequential()
	# model.add(Dense(12, input_dim=8, activation='relu'))
	# model.add(Dense(8, activation='relu'))
	# model.add(Dense(1, activation='sigmoid'))

