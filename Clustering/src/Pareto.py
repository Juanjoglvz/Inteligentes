import pandas as pd
import numpy as np

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)

df["Total"] = df.sum(axis=1)

totals = df["Total"].values
totals = np.flip(np.sort(totals))
total_sum = df["Total"].sum()

n_samples = len(totals)

for i in np.arange(0,1,0.01):
    percent = totals[:int(n_samples*i)]
    percent_sum = np.sum(percent)

    print("Percentage: {} -> {}".format(i, percent_sum/total_sum))
