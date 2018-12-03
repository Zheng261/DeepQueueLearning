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
"./../Datasets/Regular/CS107Spring2017dataset.csv", "./../Datasets/Regular/CS107Winter2018dataset.csv"]

test_arr = ["./../Datasets/Regular/CS107Spring2018dataset.csv"]

scaler = None
 
def load_data():
	list_, test = [], None
	for i, file_ in enumerate(train_arr):

	    df = pd.read_csv(file_,index_col=0, header=0)
	    list_.append(df)
	    if i == 4:
	    	print ("Length of test set:")
	    	print (len(df))

	train = pd.concat(list_, axis = 0, ignore_index = True)

	for file_ in test_arr:
		test = pd.read_csv(file_,index_col=0, header=0)
	return train, test

def preprocess(data):
	to_exclude = ["sign_ups","serves", "servers", "average_wait_time","average_serve_time","avgDayServeTime"]
	for exc in to_exclude:
		data.drop(exc, axis=1, inplace=True)

	n_vars = 1 if type(data) is list else data.shape[1]
	df = data[["loadInflux", 'day', 'hourOfDay', 'weekNum', 'daysAfterPrevAssnDue', 'daysUntilNextAssnDue', 'daysTilExam', 'isFirstOHWithinLastThreeHour', 'NumStudents', 'InstructorRating', 'AvgHrsSpent', 'ProportionFrosh', 'ProportionGrads', 'ProportionPhDs']]
	
	return df


def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):

	n_vars = 1 if type(data) is list else data.shape[1]
	cols, names = [], []
	df = pd.DataFrame(data)

	# input sequence (t-n, ... t-1)
	for i in range(n_in, 0, -1):
		cols.append(df.shift(i))
		names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
	# forecast sequence (t, t+1, ... t+n)
	for i in range(0, n_out):
		cols.append(df.shift(-i))
		if i == 0:
			names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
		else:
			names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
	# put it all together
	agg = pd.concat(cols, axis=1)
	agg.columns = names
	# drop rows with NaN values
	if dropnan:
		agg.dropna(inplace=True)
	return agg


train_raw, test_raw = load_data()

train_data = preprocess(train_raw)
test_data = preprocess(test_raw)

scaler = MinMaxScaler(feature_range=(0, 1))
scaled = scaler.fit_transform(train_data.values)

n_look_back = 4
n_features = 14
reframed = series_to_supervised(scaled, n_look_back, 1)

# drop columns we don't want to predict
reframed.drop(reframed.columns[[15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]], axis=1, inplace=True)

# split into train and test sets
values = reframed.values
n_test = 340
train = values[:-n_test, :]
test = values[-n_test:, :]
# split into input and outputs
n_obs = n_look_back * n_features
train_X, train_y = train[:, :n_obs], train[:, -n_features]
test_X, test_y = test[:, :n_obs], test[:, -n_features]
#print(train_X.shape, len(train_X), train_y.shape)
# reshape input to be 3D [samples, timesteps, features]
train_X = train_X.reshape((train_X.shape[0], n_look_back, n_features))
test_X = test_X.reshape((test_X.shape[0], n_look_back, n_features))
#print(train_X.shape, train_y.shape, test_X.shape, test_y.shape)
 
# design network
model = Sequential()
model.add(LSTM(50, input_shape=(train_X.shape[1], train_X.shape[2])))
model.add(Dense(1))
model.compile(loss='mse', optimizer='adam')
# fit network

earlystop = EarlyStopping(monitor='val_loss', min_delta=0.0001, patience=5, \
                          verbose=1, mode='auto')

history = model.fit(train_X, train_y, epochs=200, batch_size=128, callbacks = [earlystop], validation_data=(test_X, test_y), verbose=2, shuffle=False)
# plot history
pyplot.plot(history.history['loss'], label='train')
pyplot.plot(history.history['val_loss'], label='test')
pyplot.legend()
pyplot.show()
 
# make a prediction
yhat = model.predict(test_X)
test_X = test_X.reshape((test_X.shape[0], -1))
# invert scaling for forecast
inv_yhat = np.concatenate((yhat, test_X[:, -13:]), axis=1)

inv_yhat = scaler.inverse_transform(inv_yhat)
inv_yhat = inv_yhat[:,0]
# invert scaling for actual
test_y = test_y.reshape((len(test_y), 1))
inv_y = np.concatenate((test_y, test_X[:, -13:]), axis=1)
inv_y = scaler.inverse_transform(inv_y)
inv_y = inv_y[:,0]
# calculate RMSE
rmse = np.sqrt(mean_squared_error(inv_y, inv_yhat))
# print ("Predicted:")
# print (inv_yhat)
print('Test RMSE: %.3f' % rmse)