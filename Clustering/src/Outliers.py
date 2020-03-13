from sklearn.neighbors import LocalOutlierFactor
import pandas as pd

df = pd.read_csv("../data/raw/source.csv")
df.drop(["Channel", "Region"], inplace=True, axis=1)

lof = LocalOutlierFactor(n_neighbors=2)

lof.fit_predict(df)

print(lof.negative_outlier_factor_)
