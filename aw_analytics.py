import numpy as np
import pandas as pd


def mean_wt(df, var, wt):
    series = df[var]
    dropped = series.dropna()
    try:
        return np.average(dropped, weights=df.loc[dropped.index, wt]).round(1)
    except ZeroDivisionError:
        return 0


def median_wt(df, var, wt):
    dropped = df.dropna(subset=[var])
    dropped_sorted = dropped.sort_values(var)

    if dropped_sorted.shape[0] == 0:
        return 0
    else:
        cumsum = dropped_sorted[wt].cumsum()
        cutoff = dropped_sorted[wt].sum() / 2.0
        return dropped_sorted[cumsum >= cutoff][var].iloc[0]


def dataframe_stack(list_of_dfs):
    """
    Takes a list of dataframes and stacks them vertically
    """
    output = pd.concat(list_of_dfs, axis=0)
    return output


def output_mean_table(df, var, ind_vars, wt):
    """Generalized function that takes in df, outcome variable, independent variable(s) and weight
    and returns a dataframe with disaggregated percentages
    - Requires import of mean_wt module -
    """

    # Create reduced dataframe
    temp = df

    ind_df = pd.DataFrame(temp[ind_vars])

    # Check if data is categorical or numeric
    if temp[var].dtypes == "object":
        var_df = pd.get_dummies(temp[var], prefix=str(var)).replace({1: 100, np.nan: 0})
    else:
        var_df = pd.DataFrame(temp[var])

    var_col_names = var_df.columns.to_list()

    # Check if analysis is to be weighted
    if wt == None:
        wt_df = pd.DataFrame(np.ones((len(df), 1)), columns=["wt"])
    else:
        wt_df = pd.DataFrame(temp[wt])
        wt_df.columns = ["wt"]

    temp = ind_df[:].join(var_df).join(wt_df)

    # Run analysis
    # List comprehension for apply
    mean_list = [
        temp.groupby(ind_vars[i]).apply(mean_wt, var_col_names[j], "wt")
        for i in range(len(ind_vars))
        for j in range(len(var_col_names))
    ]

    count_list = [
        temp.groupby(ind_vars[i])["wt"].apply(sum).round(1)
        for i in range(len(ind_vars))
    ]

    # Concat lists
    var_len = len(var_col_names)
    mean_concat = [
        pd.concat(mean_list[(i * var_len) : (i * var_len + var_len)], axis=1)
        for i in range(len(ind_vars))
    ]

    count_concat = [pd.concat([count_list[i]], axis=0) for i in range(len(ind_vars))]

    # Concat (vertical stack)
    mean_df = pd.concat(mean_concat, axis=0)
    count_df = pd.DataFrame(pd.concat(count_concat, axis=0))

    # Rename cols
    old_names = [i for i in range(len(var_col_names))]
    col_dict = dict(zip(old_names, var_col_names))
    mean_df = mean_df.rename(columns=col_dict)

    # Join count to df
    output_df = mean_df.join(count_df)

    if wt == None:
        output_df = output_df.rename(columns={"wt": "Count"})
    else:
        output_df = output_df.rename(columns={"wt": "Weighted_Count"})

    return output_df


def output_mean_tableau(df, var, ind_vars, wt):
    """Generalized function that takes in df, outcome variable, independent variable(s) and weight
    and returns a dataframe in Tableau format for export to database (.csv)

    - Requires import of mean_wt module -
    """
    temp = df
    if temp[var].dtypes == "O":
        var_string = True
    else:
        var_string = False

    # Generate var df based on categorical or numeric
    if var_string:
        var_df = pd.get_dummies(temp[var], prefix=str(var)).replace({np.nan: 0})
    else:
        var_df = pd.DataFrame(temp[var])

    # Check if analysis is to be weighted
    if wt == None:
        wt_df = pd.DataFrame(np.ones((len(df), 1)), columns=["wt"])
    else:
        wt_df = pd.DataFrame(temp[wt])
        wt_df.columns = ["wt"]

    # Combine into df for analysis
    ind_df = pd.DataFrame(temp[ind_vars])
    ind_df = ind_df.apply(lambda x: ind_df.columns + "_" + x.astype(str), axis=1)
    temp = ind_df[:].join(var_df).join(wt_df)

    # 2. Run analysis
    # Get list of var columns
    var_col_names = var_df.columns.to_list()
    # List comprehensions using apply
    mean_list = [
        temp.groupby(ind_vars[i]).apply(mean_wt, var_col_names[j], "wt")
        for i in range(len(ind_vars))
        for j in range(len(var_col_names))
    ]
    count_list = [
        temp.groupby(ind_vars[i])["wt"].apply(sum).round(1)
        for i in range(len(ind_vars))
    ]

    # Concat lists
    var_len = len(var_col_names)
    mean_concat = [
        pd.concat(mean_list[(i * var_len) : (i * var_len + var_len)], axis=1)
        for i in range(len(ind_vars))
    ]
    count_concat = [pd.concat([count_list[i]], axis=1) for i in range(len(ind_vars))]

    # Concat values
    mean_df = pd.DataFrame(pd.concat(mean_concat, axis=0))
    count_df = pd.DataFrame(pd.concat(count_concat, axis=0))

    # Unstack mean to get long form for Tableau
    mean_df = mean_df.unstack().reset_index()
    mean_df = mean_df.add_prefix("col_")

    # Merge in count data
    output_df = mean_df.merge(
        count_df, left_on="col_level_1", right_index=True
    ).sort_index()

    # Dictionary to replace level_0 values with ind_var names
    var_col_dict = dict(zip([i for i in range(len(var_col_names))], var_col_names))

    output_df["col_level_0"] = output_df["col_level_0"].replace(var_col_dict)

    # 3. Clean and tidy df based on Tableau format for export to database (.csv)
    # 3.1 Add column which identifies ind_var_name based on values in level_1
    # 3.1.1 List of unique values in ind_vars
    ind_vars_unique_list = [
        ind_df[ind_vars[i]].unique().tolist() for i in range(len(ind_vars))
    ]

    # 3.1.2 Create dict with ind_var unique values
    ind_vars_dict = {
        ind_vars_unique_list[i][j]: ind_vars[i]
        for i in range(len(ind_vars))
        for j in range(len(ind_vars_unique_list[i]))
    }
    # ind_vars_dict = {x: v for k, v in zip(ind_vars_unique_list, ind_vars) for x in k}  --> Stackoverflow solution

    # 3.1.3 List comprehension to map values
    output_df["col_level_2"] = [ind_vars_dict[x] for x in output_df.col_level_1]

    # 3.2 Rename cols
    new_names = [
        "Indicator",
        "Demograph_Value",
        "Indicator_Value",
        "Count",
        "Demograph",
    ]
    col_dict = dict(zip(output_df.columns.tolist(), new_names))
    output_df = output_df.rename(columns=col_dict)
    col_order = [
        "Demograph",
        "Demograph_Value",
        "Indicator",
        "Indicator_Value",
        "Count",
    ]
    output_df = output_df[col_order]

    # 3.3 Insert Round column
    if "Round" in ind_vars:
        output_df.insert(0, "Round", ind_df["Round"].unique()[0])
    else:
        output_df.insert(0, "Round", "MISSING")

    # 3.4 Rename Count
    if wt == None:
        output_df = output_df.rename(columns={"Count": "Count"})
    else:
        output_df = output_df.rename(columns={"Count": "Weighted_Count"})

    return output_df
