import pandas as pd

from sklearn.ensemble import IsolationForest

# Definition of groups depending on location and channel
def groupings(row):
    if int(row["Channel"]) == 1 and int(row["Region"]) == 1:
        return 0
    elif int(row["Channel"]) == 2 and int(row["Region"]) == 1:
        return 1
    elif int(row["Channel"]) == 1 and int(row["Region"]) == 2:
        return 2
    elif int(row["Channel"]) == 2 and int(row["Region"]) == 2:
        return 3
    elif int(row["Channel"]) == 1 and int(row["Region"]) == 3:
        return 4
    elif int(row["Channel"]) == 2 and int(row["Region"]) == 3:
        return 5


df = pd.read_csv("../data/raw/source.csv")

clf = IsolationForest(max_samples=10, random_state=8345723) # Fit outlier detection
clf.fit(df)
pred = clf.predict(df)


inliers_df = pd.DataFrame()
outliers_df = pd.DataFrame()

for i in range(len(df)):
    if pred[i] == -1:
        outliers_df = outliers_df.append(df.loc[i, :])
    else:
        inliers_df = inliers_df.append(df.loc[i, :])

print(len(outliers_df))
print(len(inliers_df))

# apply groupings function to crete the group of each row
inliers_df["Group"] = inliers_df.apply(groupings, axis=1)

# save to csv
df.to_csv("../data/interim/groups_a_priori.csv", index=False)


