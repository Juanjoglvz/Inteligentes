import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import MinMaxScaler

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)

scaler = MinMaxScaler()
data = scaler.fit_transform(df)

pca = PCA(n_components=2)
data = pca.fit_transform(data)

plt.scatter(data[:, 0], data[:, 1])
plt.waitforbuttonpress()

