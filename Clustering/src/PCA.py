import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import LocalOutlierFactor
from sklearn.ensemble import IsolationForest

df = pd.read_csv("../data/raw/source.csv")
#df = pd.read_csv("../data/interim/groups_a_priori.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)


scaler = MinMaxScaler()
data = scaler.fit_transform(df)

pca = PCA(n_components=2)
data = pca.fit_transform(data)
clf = IsolationForest(max_samples=10) # Fit outlier detection
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

#plt.scatter(data[:, 0], data[:, 1])
#plt.waitforbuttonpress()


'''
scaler = MinMaxScaler()
data = df.copy()
data.drop(["Group"], axis=1, inplace=True)
data = scaler.fit_transform(data)

pca = PCA(n_components=2)
data = pca.fit_transform(data)

print(pca.explained_variance_ratio_)

for i, row in df.iterrows():
    if row["Group"] == 0:
        plt.scatter(data[i, 0], data[i, 1], c="blue")
    elif row["Group"] == 1:
        plt.scatter(data[i, 0], data[i, 1], c="green")
    elif row["Group"] == 2:
        plt.scatter(data[i, 0], data[i, 1], c="cyan")
    elif row["Group"] == 3:
        plt.scatter(data[i, 0], data[i, 1], c="red")
    elif row["Group"] == 4:
        plt.scatter(data[i, 0], data[i, 1], c="magenta")
    elif row["Group"] == 5:
        plt.scatter(data[i, 0], data[i, 1], c="black")

plt.waitforbuttonpress()
'''