import csv
import numpy as np
import matplotlib.pyplot as plt
from pandas import read_csv
import math
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
from tqdm import tqdm

"""
look back: 7, units: 4
Train Score: 94.17 RMSE
Test Score: 156.02 RMSE

look back: 5, units: 4
Train Score: 92.97 RMSE
Test Score: 153.98 RMSE

200 epochs, LSTM with memory between batches
Train Score: 89.96 RMSE
Test Score: 150.66 RMSE

200 epochs, 2 stacked LSTM with memory between batches
Train Score: 87.00 RMSE
Test Score: 167.80 RMSE

200 epochs, 3 stacked LSTM with memory between batches
Train Score: 74.78 RMSE
Test Score: 159.67 RMSE
"""

seed = 221
np.random.seed(221)

quarters = ["Datasets/CS107Autumn2017dataset.csv", "Datasets/CS107Autumn2018dataset.csv", \
"Datasets/CS107Spring2017dataset.csv", "Datasets/CS107Spring2018dataset.csv", "Datasets/CS107Winter2018dataset.csv"]

curr_quarter = quarters[0]

def read_dataset():
	loadInflux = []
	for i, quarter in enumerate(quarters):
		if i < 4:
			continue
		f = open(quarter, 'r')
		reader = csv.reader(f)
		raw_data = [row for row in reader]

		for i, d in enumerate(raw_data):
			if i == 0:
				continue			
			loadInflux.append([float(d[8])])

	loadInflux = np.asarray(loadInflux).reshape((-1, 1))

	return loadInflux

def create_dataset(dataset, look_back=1):
	dataX, dataY = [], []
	for i in range(len(dataset)-look_back-1):
		a = dataset[i:(i+look_back), 0]
		dataX.append(a)
		dataY.append(dataset[i + look_back, 0])
	return np.array(dataX), np.array(dataY)

if __name__ == '__main__':

	dataset = read_dataset()
	scaler = MinMaxScaler(feature_range=(0, 1))
	dataset = scaler.fit_transform(dataset)

	# split into train and test sets
	train_size = int(len(dataset) * 0.9)
	test_size = len(dataset) - train_size
	train, test = dataset[0:train_size,:], dataset[train_size:len(dataset),:]

	# reshape into X=t and Y=t+1
	look_back = 4
	trainX, trainY = create_dataset(train, look_back)
	testX, testY = create_dataset(test, look_back)

	# reshape input to be [samples, time steps, features]
	trainX = np.reshape(trainX, (trainX.shape[0], trainX.shape[1], 1))
	testX = np.reshape(testX, (testX.shape[0], testX.shape[1], 1))

	batch_size = 1
	model = Sequential()
	model.add(LSTM(4, batch_input_shape=(batch_size, look_back, 1), stateful=True, return_sequences=True))
	model.add(LSTM(4, batch_input_shape=(batch_size, look_back, 1), stateful=True, return_sequences=True))
	model.add(LSTM(4, batch_input_shape=(batch_size, look_back, 1), stateful=True))
	model.add(Dense(1))
	model.compile(loss='mean_squared_error', optimizer='adam')
	for i in tqdm(range(300)):
		model.fit(trainX, trainY, epochs=1, batch_size=batch_size, verbose=1, shuffle=False)
		model.reset_states()

	# make predictions
	trainPredict = model.predict(trainX, batch_size=batch_size)
	model.reset_states()
	testPredict = model.predict(testX, batch_size=batch_size)

	# invert predictions
	trainPredict = scaler.inverse_transform(trainPredict)
	trainY = scaler.inverse_transform([trainY])
	testPredict = scaler.inverse_transform(testPredict)
	testY = scaler.inverse_transform([testY])

	# calculate root mean squared error
	trainScore = math.sqrt(mean_squared_error(trainY[0], trainPredict[:,0]))
	print('Train Score: %.2f RMSE' % (trainScore))
	testScore = math.sqrt(mean_squared_error(testY[0], testPredict[:,0]))
	print('Test Score: %.2f RMSE' % (testScore))

	# shift train predictions for plotting
	trainPredictPlot = np.empty_like(dataset)
	trainPredictPlot[:, :] = np.nan
	trainPredictPlot[look_back:len(trainPredict)+look_back, :] = trainPredict

	# shift test predictions for plotting
	testPredictPlot = np.empty_like(dataset)
	testPredictPlot[:, :] = np.nan
	testPredictPlot[len(trainPredict)+(look_back*2)+1:len(dataset)-1, :] = testPredict

	# plot baseline and predictions
	plt.plot(scaler.inverse_transform(dataset))
	plt.plot(trainPredictPlot)
	plt.plot(testPredictPlot)
	plt.show()