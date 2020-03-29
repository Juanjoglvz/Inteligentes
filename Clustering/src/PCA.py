import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import MinMaxScaler
from sklearn.ensemble import IsolationForest


def hito1():
    # Load data
    df = pd.read_csv("../data/raw/source.csv")
    df.drop(["Channel", "Region"], inplace=True, axis=1)

    # Apply scaling if needed
    scaler = MinMaxScaler()
    data = scaler.fit_transform(df)

    # Apply PCA
    pca = PCA(n_components=2)
    data = pca.fit_transform(data)
    clf = IsolationForest(max_samples=10)  # Fit outlier detection
    clf.fit(df)
    pred = clf.predict(df)

    # Plot data. Different color for outliers
    for i in range(len(pred)):
        if pred[i] == 1:
            plt.scatter(data[i, 0], data[i, 1], c="blue")
        else:
            plt.scatter(data[i, 0], data[i, 1], c="green")

    # Print if needed
    # plt.scatter(data[:, 0], data[:, 1])
    # For non spyder environments
    # plt.waitforbuttonpress()

def hito2():
    # Load data
    df = pd.read_csv("../data/interim/groups_a_priori.csv")

    # Apply scaling if needed
    scaler = MinMaxScaler()
    data = df.copy() # Save original data for groups coloring
    data.drop(["Group"], axis=1, inplace=True)
    data = scaler.fit_transform(data)

    # Apply PCA
    pca = PCA(n_components=2)
    data = pca.fit_transform(data)

    print(pca.explained_variance_ratio_)

    # Plot. Use group for coloring
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

    # For non-spyder environments
    # plt.waitforbuttonpress()


if __name__ == "__main__":
    # Control variable
    hito_a_realizar = 1

    if hito_a_realizar = =1:
        hito1()
    else:
        hito2()
