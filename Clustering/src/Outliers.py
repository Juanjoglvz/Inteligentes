import pandas as pd
from sklearn.neighbors import LocalOutlierFactor
from sklearn.cluster import DBSCAN
from sklearn.preprocessing import MinMaxScaler
from sklearn.ensemble import IsolationForest

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)

scaler = MinMaxScaler()
data = scaler.fit_transform(df)

lof = LocalOutlierFactor(n_neighbors=2, contamination=0.1)

pred = lof.fit_predict(df)

print(pred)

clf = IsolationForest(max_samples=10)
clf.fit(df)

y_pred_train = clf.predict(df)

print(y_pred_train)