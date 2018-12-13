import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# dataset_name = "CS224NWinter2018"
# data_path = "../Datasets/fullDataToPredict/Full" + dataset_name + "dataset.csv"
# actual = pd.read_csv(data_path, usecols = ["loadInflux"], squeeze = True)

# preds_path = "CS224NWinter2018dataset.npy"
# preds = np.load(preds_path)
# t_slots = np.array([i for i in range(preds.shape[0])])

# plt.figure()
# plt.plot(t_slots, preds, 'b-', t_slots, actual, 'r-', linewidth = 1.0)
# plt.legend(('Predicted L.I.', 'Actual L.I.'))
# plt.grid(True)
# plt.title("Predicted and actual load influx, quarter: " + dataset_name)
# plt.xlabel("Time slots through the quarter")
# plt.ylabel("Load influx")

# plt.savefig("preds_v_actual.png")
# plt.close()

def sqHuber(x, delta=18):
	print(delta*(np.abs(x)-0.5*delta))
	return np.where(np.abs(x) < delta,.5*(x)**2 , np.sqrt(np.abs(delta*(np.abs(x)-0.5*delta))))

x = np.arange(-50, 50)
loss_func = sqHuber(x)

plt.plot(x, loss_func, 'k-', linewidth = 1.0)
plt.legend(('Shrug loss'))
plt.grid(True)
plt.ylabel("$\it{L_{shrug}(y, \hat{y})}$")
plt.xlabel("$y - \hat{y}$")
plt.title("Shrug loss")
plt.show()

plt.savefig("shrug_loss.png")
