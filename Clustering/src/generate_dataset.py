# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 15:52:50 2020

@author: resu
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import LocalOutlierFactor
from sklearn.ensemble import IsolationForest

df = pd.read_csv("../data/raw/source.csv")

df = pd.get_dummies(df, columns=["Channel", "Region"])

scaler = StandardScaler()
df[:] = scaler.fit_transform(df)

pca = PCA(n_components=2, random_state=2834)
data = pca.fit_transform(df)

clf = IsolationForest(max_samples=10, random_state=8345723) # Fit outlier detection
clf.fit(df)
pred = clf.predict(df)

for i in range(len(pred)):
    if pred[i] == 1:
        plt.scatter(data[i, 0], data[i, 1], c="blue")
    else:
        plt.scatter(data[i, 0], data[i, 1], c="green")


inliers_df = pd.DataFrame()
outliers_df = pd.DataFrame()

for i in range(len(df)):
    if pred[i] == -1:
        outliers_df = outliers_df.append(df.loc[i, :])
    else:
        inliers_df = inliers_df.append(df.loc[i, :])

print(len(outliers_df))
print(len(inliers_df))

plt.waitforbuttonpress()
inliers_df.to_csv("../data/interim/no_outliers_scaled.csv", index=False)