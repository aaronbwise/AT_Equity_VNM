import json
from pathlib import Path

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
import seaborn as sns

### Set seaborn parameters
sns.set_theme(style="whitegrid", palette="pastel")

from aw_analytics import mean_wt

# -- Read in survey configuration information -- #
config_path = Path.cwd().joinpath("charts_config.json")
config_data = json.load(open(config_path))

def generate_charts(df, var_dep, ind_var, recode):
    """
    Function to generate charts
    """
    if recode == 'women':
        weight = 'wmweight'
    else:
        weight = 'chweight'

    titles_dict = config_data[recode]["titles_dict"]
    ind_vars_dict = config_data[recode]["ind_vars_dict"]

    # Remove rows if data for var_dep is missing
    df = df.dropna(subset=[var_dep])

    # Get Year info for dynamically setting params
    num_years = df['Year'].nunique()

    year_list = ['2000', '2005', '2010', '2015', '2020']

    year_range = year_list[-(num_years):]

    print(f"year_range is: {year_range} and num_years is: {num_years}")

    ## Generate chart
    fig, ax = plt.subplots(figsize=(7, 5))

    ax = sns.lineplot(
        x = 'Year',
        y = var_dep,
        data = df.groupby(['Year', ind_var]).apply(mean_wt, var_dep, wt = weight).to_frame(var_dep),
        hue = ind_var,
        palette = "deep",
        linewidth = 3,
        marker='o'
        )


    # Title/subtitle settings
    title_string = f'{titles_dict[var_dep]} {ind_vars_dict[ind_var]}'
    ax.set_title(title_string, loc="left", fontsize = 12)

    # Axis labels
    ax.set_xlabel('', fontsize = 10)
    ax.set_ylabel('Percentage (%)', fontsize = 10)

    # Dynamically set ticks
    # ax.set_xticks(np.arange((int(year_range[0])), int((year_range[-1])), (num_years+1)), labels = year_range)

    ax.legend(bbox_to_anchor=(1.05, 1), fontsize=8)

    out_fn = var_dep.upper() + "_" + ind_var + ".svg"
    out_path = Path.cwd() / "output" / "charts" / recode / out_fn

    fig.savefig(out_path, transparent=False, dpi=300, bbox_inches="tight")
    plt.close()