# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 22:36:58 2020

@author: resu
"""

from sklearn.metrics.pairwise import euclidean_distances
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from sklearn.ensemble import IsolationForest
from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances

df = pd.read_csv("../data/interim/no_outliers_scaled.csv")

dist_matrix = pairwise_distances(df, df, metric="chebyshev")
#dist_matrix = euclidean_distances(data, data)

k = 2
distances_to_k = [0] * len(dist_matrix)

for i in range(len(dist_matrix)):
    distances = dist_matrix[i, :]
    distances = np.sort(distances)
    distances_to_k[i] = distances[k]

distances_to_k.sort()
cumdiff = [0] * len(distances_to_k)

for i in range(len(distances_to_k)):
    if i == 0:
        cumdiff[i] = 0
    else:
        cumdiff[i] = distances_to_k[i] - distances_to_k[i - 1]

fig, ax = plt.subplots()
plt.plot(distances_to_k)
ax.grid(True)
plt.yticks(np.arange(0, 4, step=0.1))

fig.set_size_inches(13.5, 7.5, forward=True)

