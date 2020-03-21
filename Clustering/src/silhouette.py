# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 16:34:31 2020

@author: resu
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import LocalOutlierFactor
from sklearn.ensemble import IsolationForest
from sklearn.cluster import DBSCAN
from sklearn.metrics import silhouette_score

from scipy.optimize import minimize

euclidean_eps = {   2: 1.9,
                    4: 2.0,
                    6: 2.1,
                    8: 2.15,
                    10: 2.15,
                    12: 2.3,
                    14: 2.4,
                    16: 2.5,
                    18: 2.5,
                    20: 2.6,
                    22: 2.4,
                    24: 2.5,
                    26: 3.2,
                    28: 3.3,
                    30: 2.7
        }


chebyshev_eps = {   2: 1.4,
                    4: 1.6,
                    6: 2.1,
                    8: 2.15,
                    10: 2.15,
                    12: 2.15,
                    14: 2.15,
                    16: 2.15,
                    18: 2.15,
                    20: 2.15,
                    22: 2.15,
                    24: 2.15,
                    26: 2.15,
                    28: 2.15,
                    30: 2.15
        }

def cluster(df, minpts, eps, metric):    
    
    db = DBSCAN(eps=eps, min_samples=minpts, metric=metric).fit_predict(df)
    
    try:
        sil = silhouette_score(df, db)
    except:
        sil = -1
    return sil


df = pd.read_csv("../data/interim/no_outliers_scaled.csv")

best_sil = -1
best_idx = 0
best_metric = None
for metric in ["euclidean", "chebyshev"]:
    for i in range(2, 30, 2):
        if metric == "euclidean":
            eps = euclidean_eps[i]
        else:
            eps = chebyshev_eps[i]
            
        sil = cluster(df, i, eps, metric)
        
        print("Metric: {}  minpts: {}  eps: {}  silhouette: {}".format(metric, i, eps, sil))
        
        if sil > best_sil:
            best_sil = sil
            best_idx = i
            best_metric = metric