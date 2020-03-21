# -*- coding: utf-8 -*-
"""
Created on Wed Mar  4 23:05:27 2020

@author: resu
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import LocalOutlierFactor
from sklearn.ensemble import IsolationForest
from sklearn.cluster import DBSCAN
import collections

df_raw = pd.read_csv("../data/raw/source.csv")
df_raw.drop(["Channel", "Region"], inplace=True, axis=1)

df = pd.read_csv("../data/interim/no_outliers_scaled.csv")


i = 2.1
#for i in np.arange(0.1, 2.4, step = 0.005):
db = DBSCAN(eps=2.1, min_samples=6, metric="chebyshev").fit_predict(df)
print("EPS: " + str(i) + "   "  + str(collections.Counter(db)))

noise_df = pd.DataFrame()
noice_df = pd.DataFrame()
for i in range(len(db)):
    if db[i] == -1:
        noise_df = noise_df.append(df_raw.loc[i, :])
    else:
        groups_df = noice_df.append(df_raw.loc[i, :])
    
print(noise_df.describe())
print(groups_df.describe())