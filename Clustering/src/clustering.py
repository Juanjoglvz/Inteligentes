# -*- coding: utf-8 -*-
"""
Created on Wed Mar  4 23:05:27 2020

@author: resu
"""

import pandas as pd
from sklearn.cluster import DBSCAN
import collections

df_raw = pd.read_csv("../data/raw/source.csv")

df = pd.read_csv("../data/interim/no_outliers_scaled.csv")

eps = 1.7
db = DBSCAN(eps=1.7, min_samples=12, metric="euclidean").fit_predict(df) # Clusterize
print("EPS: " + eps + "   "  + str(collections.Counter(db))) # Print the groups and the number of members of each group

noise_df = pd.DataFrame()
groups_df = pd.DataFrame()
for i in range(len(db)): # Create new datasets that hold the noise and the group data
    if db[i] == -1:
        noise_df = noise_df.append(df_raw.loc[i, :])
    else:
        row = df_raw.loc[i, :]
        group = pd.Series(db[i], index=["Group"])
        row = row.append(group)
        groups_df = groups_df.append(row, ignore_index=True)
    
print(noise_df.describe())
print(groups_df.describe())
groups_df.to_csv("../data/interim/groups.csv", index=False) # Save the groups dataset
