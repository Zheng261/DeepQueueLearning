from matplotlib import pyplot

from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import mean_squared_error
from keras.models import Sequential
from keras.layers import *
from keras.callbacks import EarlyStopping

import numpy as np
import pandas as pd
 

seed = 221
np.random.seed(221)

train_arr = ["./../Datasets/Regular/CS107Autumn2017dataset.csv", "./../Datasets/Regular/CS107Autumn2018dataset.csv", \
"./../Datasets/Regular/CS107Spring2017dataset.csv", "./../Datasets/Regular/CS107Winter2018dataset.csv", \
"./../Datasets/Regular/CS110Autumn2018dataset.csv", "./../Datasets/Regular/CS110Spring2018dataset.csv", \
"./../Datasets/Regular/CS161Autumn2017dataset.csv", "./../Datasets/Regular/CS161Spring2017dataset.csv", \
"./../Datasets/Regular/CS229Autumn2018dataset.csv"
]

test_arr = ["./../Datasets/Regular/CS107Spring2018dataset.csv"]


# 111.155
 
def load_data(arr, train=True):
	if train:
		list_ = []
		for i, file_ in enumerate(arr):

		    df = pd.read_csv(file_,index_col=0, header=0)
		    list_.append(df)

		dataset = pd.concat(list_, axis = 0, ignore_index = True)
		return dataset
	else:
		return pd.read_csv(arr[0],index_col=0, header=0)

def preprocess(data):

	to_exclude = ["sign_ups","serves", "servers", "average_wait_time","average_serve_time","day","avgDayServeTime",\
	"daysAfterPrevAssnDue","daysUntilNextAssnDue","daysTilExam","hourOfDay","isFirstOHWithinLastThreeHour",\
	"isFirstOHWithinLastSixHour","isLastOHWithinNextThreeHour","isLastOHWithinNextSixHour"]
	for exc in to_exclude:
		data.drop(exc, axis=1, inplace=True)

	load_influx_idx = list(data).index("loadInflux")
	df = data[["loadInflux"] + list(data)[:load_influx_idx] + list(data)[load_influx_idx+1:]]
	return df


def create_windows(data, train=True):

	values = data.values
	print ("Original shape:")

	toReturn = np.zeros((values.shape[0]-1, values.shape[1]+1))

	for i in range(values.shape[0] - 1):
		toReturn[i][:-1] = values[i]
		toReturn[i][-1] = values[i+1][0]
		if not train:
			if i != 0:
				toReturn[i][0] = 0.

	return toReturn


def create_model(train_X):
	print (train_X.shape)
	model = Sequential()
	model.add(LSTM(50, input_shape=(train_X.shape[1], train_X.shape[2])))
	model.add(Dense(1))
	model.compile(loss='mse', optimizer='adam')
	return model


def plot_loss_diagram(history):

	pyplot.plot(history.history['loss'], label='train')
	pyplot.plot(history.history['val_loss'], label='test')
	pyplot.legend()
	pyplot.show()




if __name__ == "__main__":

	raw_train_data = load_data(train_arr, train=True)
	raw_test_data = load_data(test_arr, train=False)

	train_data = preprocess(raw_train_data)
	test_data = preprocess(raw_test_data)

	# frame as supervised learning
	train_windows = create_windows(train_data, train=True)
	true_test_windows = create_windows(test_data, train=True)
	train_X, train_y = train_windows[:, :-1], train_windows[:, -1]
	true_test_X, true_test_y = true_test_windows[:, :-1], true_test_windows[:, -1]

	# normalize features
	scaler = MinMaxScaler(feature_range=(0, 1))
	scaler.fit(train_X)
	train_X_scaled = scaler.transform(train_X)
	true_test_X_scaled = scaler.transform(true_test_X)

	# reshape input to be 3D [samples, timesteps, features]
	train_X_scaled = train_X_scaled.reshape((train_X.shape[0], 1, train_X.shape[1]))
	true_test_X_scaled = true_test_X_scaled.reshape((true_test_X_scaled.shape[0], 1, true_test_X_scaled.shape[1]))
	
	# fit network
	model = create_model(train_X_scaled)
	earlystop = EarlyStopping(monitor='val_loss', min_delta=0.0001, patience=7, \
	                          verbose=1, mode='auto')
	history = model.fit(train_X_scaled, train_y, epochs=1000, batch_size=128, callbacks = [earlystop], validation_data=(true_test_X_scaled, true_test_y), verbose=2, shuffle=False)

	plot_loss_diagram(history)

	yhat = []
	test_X = create_windows(test_data, train=False)[:, :-1]


	for i in range(len(test_X)):
		test_X_scaled = scaler.transform(test_X)
		test_X_scaled = test_X_scaled.reshape((test_X_scaled.shape[0], 1, test_X_scaled.shape[1]))
		predicted = model.predict(test_X_scaled[i].reshape((1, test_X_scaled.shape[1], test_X_scaled.shape[2])))[0][0]
		yhat.append(predicted)
		if i < len(test_X_scaled) - 1:
			test_X[i+1][0] = predicted

	# calculate RMSE

	rmse = np.sqrt(mean_squared_error(yhat, true_test_y))
	print('Test RMSE: %.3f' % rmse)
