# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from sklearn.cluster import DBSCAN
from sklearn.metrics import silhouette_score

euclidean_eps = {   2: 1.2,
                    4: 1.32,
                    6: 1.35,
                    8: 1.5,
                    10: 1.8,
                    12: 1.7,
                    14: 1.6,
                    16: 1.7,
                    18: 1.8,
                    20: 1.65,
                    22: 1.8,
                    24: 1.7,
                    26: 1.9,
                    28: 1.95,
                    30: 1.9
                }


chebyshev_eps = {   2: 1.0,
                    4: 1.2,
                    6: 1.3,
                    8: 1.3,
                    10: 1.5,
                    12: 1.5,
                    14: 1.55,
                    16: 1.65,
                    18: 1.7,
                    20: 1.6,
                    22: 1.7,
                    24: 1.7,
                    26: 2.0,
                    28: 2.0,
                    30: 2.0
                }

def cluster(df, minpts, eps, metric):
    db = DBSCAN(eps=eps, min_samples=minpts, metric=metric).fit_predict(df)
    
    db = [None if d == -1 else d for d in db]
    
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