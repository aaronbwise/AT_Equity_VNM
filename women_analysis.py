"""
Helper functions for data analysis of women's file
"""
import json
from pathlib import Path

import numpy as np
import pandas as pd

# -- Read in survey configuration information -- #
config_path = Path.cwd().joinpath("women_config.json")
config_data = json.load(open(config_path))


def create_anc_4_visits(df, country, year):
    """
    Function to create ANC 4+ visits variable [anc_4_visits]
    """
    # Get ANC 4+:: COL NAMES
    var_anc_4 = config_data[country][year]["anc_4_visits"]["col_name"]

    # Convert categorical column to int

    ## Convert DK and NaN to 99
    df[var_anc_4] = np.where(df[var_anc_4] == "DK", "99.0", df[var_anc_4])

    ## Cast value to float
    df[var_anc_4] = df[var_anc_4].astype(float)

    # Create categories
    conditions = [
        (df[var_anc_4] == 0),
        ((df[var_anc_4] >= 1) & (df[var_anc_4] <= 3)),
        (df[var_anc_4] >= 4) & (df[var_anc_4] < 99),
        (df[var_anc_4] >= 99),
    ]
    choices = ["None", "1-3 visits", "4+ visits", "DK/Missing"]
    df["anc_no_visits"] = np.select(conditions, choices)

    # Create indicator
    df["anc_4_visits"] = np.where(df.anc_no_visits == "4+ visits", 100, 0)


def create_anc_3_components(df, country, year):
    """
    Function to create ANC 3 components variable [anc_3_components]
    """
    # Get ANC components :: COL NAMES
    anc_3_dict = config_data[country][year]["anc_3_components"]["col_name"]

    anc_3_comps_list = list(anc_3_dict.keys())

    anc_3_comps_col_name_list = [
        list(anc_3_dict[comp].keys()) for comp in anc_3_comps_list
    ]

    anc_3_comps_col_name_list = list(np.concatenate(anc_3_comps_col_name_list))

    # Get ANC components :: VALUE
    anc_3_comps_value_list = [
        list(anc_3_dict[comp].values()) for comp in anc_3_comps_list
    ]

    anc_3_comps_value_list = list(np.concatenate(anc_3_comps_value_list))

    # Create indicator
    df["anc_3_components"] = np.where(
        (df[anc_3_comps_col_name_list[0]] == anc_3_comps_value_list[0])
        & (df[anc_3_comps_col_name_list[1]] == anc_3_comps_value_list[1])
        & (df[anc_3_comps_col_name_list[2]] == anc_3_comps_value_list[2]),
        100,
        0,
    )


def create_inst_delivery():
    """
    Function to create institutional delivery variable [inst_delivery]
    """
