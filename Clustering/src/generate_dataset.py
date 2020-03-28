# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 15:52:50 2020

@author: resu
"""

import pandas as pd
import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import LocalOutlierFactor
from sklearn.ensemble import IsolationForest

import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 24})

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], axis=1, inplace=True) # Drop non-useful columns

df_scaled = df.copy()

scaler = StandardScaler()
df_scaled[:] = scaler.fit_transform(df) # Scale the dataset so the epsilon knee method is easier to see

pca = PCA(n_components=2, random_state=2834) # Apply PCA to the scaled dataset
data = pca.fit_transform(df_scaled)

clf = IsolationForest(max_samples=10, random_state=8345723) # Fit outlier detection
clf.fit(df_scaled)
pred = clf.predict(df_scaled)

fig, ax = plt.subplots()
for i in range(len(pred)): # Plot PCA points differentiating between inliers and outliers
    if pred[i] == 1:
        ax.scatter(data[i, 0], data[i, 1], c="blue")
    else:
        ax.scatter(data[i, 0], data[i, 1], c="green")
        
fig.set_size_inches(15.5, 8.5, forward=True)

ax.set_xlabel("PC1")
ax.set_ylabel("PC2")
print("Explained variance ratio: {}".format(pca.explained_variance_ratio_))
  
outliers_df_scaled = pd.DataFrame()
inliers_df_scaled = pd.DataFrame()
outliers_df = pd.DataFrame()
inliers_df = pd.DataFrame()

for i in range(len(df)): # Create new datasets for inliers and outliers
    if pred[i] == -1:
        outliers_df = outliers_df.append(df.loc[i, :])
        outliers_df_scaled = outliers_df_scaled.append(df_scaled.loc[i, :])
    else:
        inliers_df = inliers_df.append(df.loc[i, :])
        inliers_df_scaled = inliers_df_scaled.append(df_scaled.loc[i, :])

print(len(outliers_df))
print(len(inliers_df))

# Save the datasets
inliers_df_scaled.to_csv("../data/interim/no_outliers_scaled.csv", index=False)
inliers_df.to_csv("../data/interim/no_outliers.csv", index=False)

outliers_df = outliers_df.sort_values(by=list(outliers_df.columns))

inliers_desc = inliers_df.describe()
outliers_desc = outliers_df.describe()
print(inliers_df.describe())
print(outliers_df.describe())