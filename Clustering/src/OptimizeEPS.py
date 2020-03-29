# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances

import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 24})


df = pd.read_csv("../data/interim/no_outliers_scaled.csv")

dist_matrix = pairwise_distances(df, df, metric="euclidean") # Compute distance matrix

k = 12
distances_to_k = [0] * len(dist_matrix)

for i in range(len(dist_matrix)):
    distances = dist_matrix[i, :]
    distances = np.sort(distances) # Sort distances
    distances_to_k[i] = distances[k] # Get the k-neighbor

distances_to_k.sort()


fig, ax = plt.subplots()

plt.plot(distances_to_k)

ax.grid(True)
plt.yticks(np.arange(0, 6, step=0.4))

ax.set_ylabel("Distancia al k-ésimo vecino k={}".format(k))

fig.set_size_inches(15.5, 8.5, forward=True)

