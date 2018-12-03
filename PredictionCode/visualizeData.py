from pandas import read_csv
from matplotlib import pyplot

from pylab import rcParams
rcParams['figure.figsize'] = 7, 4

# load dataset
dataset = read_csv("./../Datasets/Regular/CS107Spring2017dataset.csv", header=0, index_col=0)
values = dataset.values
# specify columns to plot
groups = [7, 0, 9, 5]
i = 1
# plot each column
pyplot.figure()
for group in groups:
	pyplot.subplot(len(groups), 1, i)
	pyplot.plot(values[:, group])
	pyplot.title(dataset.columns[group], y=0.5, loc='right')
	i += 1
pyplot.show()