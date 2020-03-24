import pandas as pd

pd.options.mode.chained_assignment = None  # default='warn'

df = pd.read_csv("../data/interim/groups_a_priori.csv")

groups = []
groups_cuant = []
centroids = []


# Split data into cualitative and cuantitative data and generate centroids using median
for g in df["Group"].unique():
    current_group = df[df["Group"] == g]
    centroids.append(current_group.median())

    groups_cuant.append(current_group[["Region", "Channel"]].copy())

    current_group.drop(["Channel", "Region"], inplace=True, axis=1)
    groups.append(current_group)



print(centroids)

# Watch effect of Region and Channel in groups
for g in df["Group"].unique():
    current_group = groups_cuant[int(g)]

    print("Group {}".format(int(g)))
    print("Region:\n{}\n".format(current_group["Region"].value_counts()))
    print("Channel:\n{}\n\n".format(current_group["Channel"].value_counts()))


# Watch total and mean spends for each group
for g in df["Group"].unique():
    current_group = groups[int(g)]

    current_group["Total"] = current_group.sum(axis=1)
    total_sum = current_group["Total"].sum()


    print("Group {}".format(int(g)))
    print("Total spends: {}".format(total_sum))
    print("Mean spends:  {}".format(total_sum/len(current_group)))


# Watch mean and median spends for each group, each product
for g in df["Group"].unique():
    current_group = groups[int(g)]
    variables = ["Delicassen", "Detergents_Paper", "Fresh", "Frozen", "Grocery", "Milk"];

    print("Group {}".format(int(g)))
    for variable in variables:
        print("{} mean: {}".format(variable, current_group[variable].mean()))
        print("{} median: {}".format(variable, current_group[variable].median()))

