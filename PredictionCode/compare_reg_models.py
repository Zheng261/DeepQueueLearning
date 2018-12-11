# from matplotlib.ticker import FuncFormatter
import matplotlib.pyplot as plt
import numpy as np

x = np.arange(5)
rmse = [109.5, 128, 69.879, 62.607, 48.0]
models = ("seq2seq LSTM", "Autoregressive LSTM", "FCN w/ MSE", "FCN w/ Huber, $\delta$=1", "FCN w/ Shrug, $\delta$=18")


# def millions(x, pos):
#     'The two args are the value and tick position'
#     return '$%1.1fM' % (x * 1e-6)


# formatter = FuncFormatter(millions)

fig, ax = plt.subplots()
# ax.yaxis.set_major_formatter(formatter)
plt.bar(x, rmse)
plt.xticks(x, models)
plt.ylabel("RMSE error")
plt.xlabel("Regressive models tested")
plt.title("Offset of predicted L.I. from ground truth (minutes * TAs)")
plt.show()


save_path = "reg_models.png"
plt.savefig(save_path)