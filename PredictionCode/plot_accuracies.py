import numpy as np
import matplotlib.pyplot as plt
 



def plot_classification():
	accuracies = [
		0.355,
		0.383,
		0.422,
		0.389,
		0.368,
		# rf
		0.326,
		0.342,
		0.342,
		0.359,
		0.350
		]
	model = [
		"svm_0.01c",
		"svm_0.1c",
		"svm_1c",
		"svm_10c",
		"svm_100c",
		"rf_1",
		"rf_10",
		"rf_100",
		"rf_1000",
		"rf_10000",

		]

	y_pos = np.arange(len(model))
	 
	plt.bar(y_pos, accuracies, align='center', alpha=0.5)
	plt.xticks(y_pos, model)
	plt.xticks(rotation=45)
	plt.ylabel('Accuracies')
	plt.title('Classification Baseline Accuracies')
	plt.ylim(ymin=0.25) 
	plt.show()



plot_classification()