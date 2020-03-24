import pandas as pd

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

# apply groupings function to crete the group of each row
df["Group"] = df.apply(groupings, axis=1)

# save to csv
df.to_csv("../data/interim/groups_a_priori.csv", index=False)


