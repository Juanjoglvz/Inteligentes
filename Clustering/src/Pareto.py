import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 24})

df = pd.read_csv("../data/interim/no_outliers.csv")

df["Total"] = df.sum(axis=1) # Get the total expenditure of each client

df = df.sort_values(by=["Total"], ascending=False)

totals = df["Total"].values
total_sum = df["Total"].sum() # Total expenditure of the dataset

n_samples = len(totals)

x = np.arange(0,1,0.005) # Check the ratio every 0.5% of selected clients
pareto = []

for i in x:
    percent = totals[:int(n_samples*i)] # Get the selected clients based on the percentage stored in "i"
    percent_sum = np.sum(percent)
    income_percent = percent_sum/total_sum
    
    pareto.append(income_percent)
    
    print("Percentage of clients: {} -> Percentage of income: {}".format(i, income_percent))
    

fig, ax = plt.subplots()

ax.plot(x, pareto, linewidth=2.5)
ax.axvline(0.2, color="black")

ax.grid(True)

plt.xticks(np.arange(0, 1.01, step=0.1))
plt.yticks(np.arange(0, 1.01, step=0.1))

ax.set_xlabel("Porcentaje de clientes")
ax.set_ylabel("Porcentaje de ingresos")

fig.set_size_inches(15.5, 8.5, forward=True)
