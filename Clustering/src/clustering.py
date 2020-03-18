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

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)

scaler = MinMaxScaler()
data = scaler.fit_transform(df) # Scale data

clf = IsolationForest(max_samples=100) # Fit outlier detection
clf.fit(data)
pred = clf.predict(data)

for i in range(len(df)): # Drop outliers
    if pred[i] == -1:
        df.drop(index=i, axis=0, inplace=True)

data = df.values
scaler = MinMaxScaler()
data = scaler.fit_transform(df) # Scale the outlier-less dataset

for i in np.arange(0.1, 0.25, step = 0.005):
    db = DBSCAN(eps=i, min_samples=3).fit_predict(data)
    print("EPS: " + str(i) + "   "  + str(collections.Counter(db)))