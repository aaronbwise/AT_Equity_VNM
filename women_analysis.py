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



### --- OUTCOME VARIABLES --- ###

def generate_str_replace_dict(df, country, year, cat_var):
    """
    Find and generate str_replace_dict based on cat_var
    """
    if cat_var == "anc_4_visits":
        str_replace_dict = {
            config_data[country][year]["anc_4_visits"]["col_names"][0]: 
            config_data[country][year]["anc_4_visits"]["convert_values"]
            }
    elif cat_var == "pnc_mother":
        str_replace_dict = {
            config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_num"]["col_names"][0]:
            config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_num"]["convert_values"]
            }
    elif cat_var == "low_bw":
        str_replace_dict = {
            config_data[country][year]["low_bw"]["col_names"][0]: 
            config_data[country][year]["low_bw"]["convert_values"]
            }
    elif cat_var == "early_bf":
        str_replace_dict = {
            config_data[country][year]["early_bf"]["time_num"]["col_names"][0]: 
            config_data[country][year]["early_bf"]["time_num"]["convert_values"]
            }
    else:
        pass

    return str_replace_dict


def create_anc_4_visits(df, country, year):
    """
    Function to create ANC 4+ visits variable [anc_4_visits]
    """
    # :: COL_NAMES
    var_anc_4 = config_data[country][year]["anc_4_visits"]["col_names"][0]

    ## Cast categorical values with str
    df[var_anc_4] = df[var_anc_4].astype(str)

    ## Replace str value with values
    str_replace_dict = generate_str_replace_dict(df, country, year, "anc_4_visits")
    df = df.replace(str_replace_dict)

    ## Cast str values to float
    df[var_anc_4] = pd.to_numeric(df[var_anc_4], errors="coerce")

    # Create indicator
    df["anc_4_visits"] = np.where((df[var_anc_4] >= 4) & (df[var_anc_4] < 99), 100, 0)

    return df


def create_anc_3_components(df, country, year):
    """
    Function to create ANC 3 components variable [anc_3_components]
    """
    # :: COL_NAMES
    var_anc_3_comp_1 = config_data[country][year]["anc_3_components"]["col_names"][0]
    var_anc_3_comp_2 = config_data[country][year]["anc_3_components"]["col_names"][1]
    var_anc_3_comp_3 = config_data[country][year]["anc_3_components"]["col_names"][2]

    var_anc_3_comp_cols = [var_anc_3_comp_1, var_anc_3_comp_2, var_anc_3_comp_3]

    # :: VALUES
    anc_3_comp_values = config_data[country][year]["anc_3_components"]["values"]

    # Create indicator
    df["anc_3_components"] = np.where(
        df[var_anc_3_comp_cols].isin(anc_3_comp_values).all(axis=1), 100, 0
    )

    return df


def create_inst_delivery(df, country, year):
    """
    Function to create institutional delivery variable [inst_delivery]
    """
    # :: COL_NAMES
    var_inst_delivery = config_data[country][year]["inst_delivery"]["col_names"][0]

    # :: VALUES
    inst_delivery_values = config_data[country][year]["inst_delivery"]["values"]

    # -- Create indicator
    df["inst_delivery"] = np.where(
        df[var_inst_delivery].isin(inst_delivery_values), 100, 0
    )

    return df


def create_caesarean_del(df, country, year):
    """
    Function to create caesarean delivery variable [caesarean_del]
    """
    # :: COL_NAMES
    var_caesarean_del = config_data[country][year]["caesarean_del"]["col_names"][0]

    # :: VALUES
    caesarean_del_values = config_data[country][year]["caesarean_del"]["values"]

    # Create indicator
    df["caesarean_del"] = np.where(df[var_caesarean_del].isin(caesarean_del_values), 100, 0)

    return df


def create_pnc_mother(df, country, year):
    """
    Function to create Post-natal Health Check (mother) [pnc_mother]
    """

    # --- 1. Health check by health provider after birth & a) before leaving facility or b) before health provider left home

    # :: COL NAMES

    var_after_birth_facility = config_data[country][year]["pnc_mother"]["sub_indicators"]["health_check_after_birth"]["col_names"][0]
    var_after_birth_home = config_data[country][year]["pnc_mother"]["sub_indicators"]["health_check_after_birth"]["col_names"][1]

    # :: VALUES

    after_birth_values = config_data[country][year]["pnc_mother"]["sub_indicators"]["health_check_after_birth"]["values"]

    ## Create sub-indicator
    df["health_check_after_birth"] = np.where(((df[var_after_birth_facility].isin(after_birth_values)) | \
        (df[var_after_birth_home].isin(after_birth_values))), 100, 0)

    # --- 2. Post-natal care visit within 2 days

    # :: COL NAMES
    var_time_cat = config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_cat"]["col_names"][0]
    var_time_num = config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_num"]["col_names"][0]
    var_pnc_health_provider = config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["pnc_health_provider"]["col_names"]

    ## Cast categorical values with str
    df[var_time_num] = df[var_time_num].astype(str)

    ## Replace str value with values
    str_replace_dict = generate_str_replace_dict(df, country, year, "pnc_mother")
    df = df.replace(str_replace_dict)

    ## Cast str values to float
    df[var_time_num] = pd.to_numeric(df[var_time_num], errors="coerce")

    # :: VALUES
    time_cat_days_values = config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_cat"]["values"][0]
    time_cat_hours_values = config_data[country][year]["pnc_mother"]["sub_indicators"]["pnc_2_days"]["time_cat"]["values"][1]

    ## Create sub-indicator
    df["pnc_2_days"] = np.where(((df[var_time_cat] == time_cat_hours_values) | ((df[var_time_cat] == time_cat_days_values) & (df[var_time_num] <= 2))), 100, 0)

    # > Set value pnc_2_days to 0 IF check was not done by health provider

    df["pnc_health_provider"] = np.where(df[var_pnc_health_provider].isnull().all(axis=1), 0, 100)

    df["pnc_2_days"] = np.where((df["pnc_health_provider"] == 100), df["pnc_2_days"], 0)

    # Create indicator
    df["pnc_mother"] = np.where((df["health_check_after_birth"] == 100) | (df["pnc_2_days"] == 100), 100, 0)

    return df


def create_low_bw(df, country, year):
    """
    Function to create Low Birthweight [low_bw]
    """
    # :: COL_NAMES
    var_low_bw = config_data[country][year]["low_bw"]["col_names"][0]

    ## Cast categorical values with str
    df[var_low_bw] = df[var_low_bw].astype(str)

    ## Replace str value with values
    str_replace_dict = generate_str_replace_dict(df, country, year, "low_bw")
    df = df.replace(str_replace_dict)

    ## Cast str values to float
    df[var_low_bw] = pd.to_numeric(df[var_low_bw], errors="coerce")

    # Create indicator
    df["low_bw"] = np.where(df[var_low_bw] < 2.5, 100, 0)

    return df


def create_early_bf(df, country, year):
    """
    Function to create Early Initiation BF [early_bf]
    """
    # Update variables for consistency between years
    df = update_early_bf_variables(df, country, year)

    # :: COL_NAMES
    var_time_cat = config_data[country][year]["early_bf"]["time_cat"]["col_names"][0]
    var_time_num = config_data[country][year]["early_bf"]["time_num"]["col_names"][0]

    ## Cast categorical values with str
    df[var_time_num] = df[var_time_num].astype(str)

    ## Cast str values to float
    df[var_time_num] = pd.to_numeric(df[var_time_num], errors="coerce")

    # :: VALUES
    time_cat_immediately_values = config_data[country][year]["early_bf"]["time_cat"]["values"][0]
    time_cat_hours_values = config_data[country][year]["early_bf"]["time_cat"]["values"][1]
    time_cat_minute_values = config_data[country][year]["early_bf"]["time_cat"]["values"][2]

    # Create indicator
    df["early_bf"] = np.where((df[var_time_cat] == time_cat_immediately_values) | \
         ((df[var_time_cat] == time_cat_hours_values) & (df[var_time_num] < 1)) | \
            ((df[var_time_cat] == time_cat_minute_values) & (df[var_time_num] < 60)), 100, 0)

    return df

def create_low_bw(df, country, year):
    """
    Function to create Mother education [mother_edu]
    """

    # :: COL_NAMES
    var_birth_size = config_data[country][year]["low_bw"]["birth_size"]["col_names"][0]
    var_birth_weight = config_data[country][year]["low_bw"]["birth_weight"]["col_names"][0]

    ## Cast categorical values with str
    df[var_birth_weight] = df[var_birth_weight].astype(str)

    ## Cast str values to float
    df[var_birth_weight] = pd.to_numeric(df[var_birth_weight], errors="coerce")

    # If 2000, divide bw by 1000 (convert g to kg)
    df = convert_bw_g_to_kg(df, country, year)

    # Combine groups if any less than 25                 ---------------- WAIT ON JOEL/ROBERT REPLY


    # Create bw_less_25 variable
    df['bw_less_25'] = np.where(df[var_birth_weight] < 2.5, 1, 0)
    # Create bw_equal_25 variable
    df['bw_equal_25'] = np.where(df[var_birth_weight] == 2.5, 1, 0)
    
    # Create agg_value_prop_dict
    agg_value_prop_dict = calc_low_bw_props(df, var_birth_size, 'bw_less_25', 'bw_equal_25')

    print(f"agg_value_prop_dict is: \n {agg_value_prop_dict}")

    # Create indicator
    df['low_bw'] = [agg_value_prop_dict[x] * 100 for x in df[var_birth_size]]

    return df


def create_mother_edu(df, country, year):
    """
    Function to create Mother education [mother_edu]
    """
    # If 2000, convert None to NaN
    df = mother_edu_none_to_null(df, country, year)

    # :: COL_NAMES
    var_mother_edu = config_data[country][year]["mother_edu"]["col_names"][0]

    # :: VALUES
    mother_edu_primary_values = config_data[country][year]["mother_edu"]["values"]["primary"]
    mother_edu_secondary_values = config_data[country][year]["mother_edu"]["values"]["secondary"]
    mother_edu_higher_values = config_data[country][year]["mother_edu"]["values"]["higher"]
    mother_edu_missing_values = config_data[country][year]["mother_edu"]["values"]["DK"]

    df["mother_edu"] = np.where(df[var_mother_edu].isnull(), "Mother Edu: None",
                        np.where(df[var_mother_edu].isin(mother_edu_primary_values), "Mother Edu: ECE/Primary",
                        np.where(df[var_mother_edu].isin(mother_edu_secondary_values), "Mother Edu: Secondary",
                        np.where(df[var_mother_edu].isin(mother_edu_higher_values), "Mother Edu: Higher", "Missing"))))

    return df

def subset_women_file(df, country, year):
    """
    Function to subset women file for 1. Complete and 2. birth in past 2 years
    """
    # :: COL_NAMES
    var_women_complete = config_data[country][year]["women_file_subset"]["col_names"]["quest_complete"][0]
    var_birth_2_years = config_data[country][year]["women_file_subset"]["col_names"]["birth_2_years"][0]

    # :: VALUES
    women_complete_values = config_data[country][year]["women_file_subset"]["values"]["quest_complete"][0]
    birth_2_years_values = config_data[country][year]["women_file_subset"]["values"]["birth_2_years"][0]

    # Subset df
    df = df[(df[var_women_complete] == women_complete_values) & \
         (df[var_birth_2_years] == birth_2_years_values)]

    print(f"The number of mothers with a birth in the past two years is: {df.shape[0]}")

    return df


## --- Helper functions to fix differences between survey years

def update_early_bf_variables(df, country, year):
    """
    Function to update early bf variables to work with function above
    """
    if year == '2006':

        # :: COL_NAMES
        var_time_cat = config_data[country][year]["early_bf"]["time_cat"]["col_names"][0]
        var_time_num = config_data[country][year]["early_bf"]["time_num"]["col_names"][0]

        df[var_time_cat] = np.where(df[var_time_num] == "Immediately", "Immediately", df[var_time_cat])

    else:
        pass

    return df


def calc_low_bw_props(df, agg_value_col, group_col_1, group_col_2):
    """
    Calculate proportions by group for two columns
    """
    agg_value_list = list(df[agg_value_col].unique())        ##### TRY DROPPING DK/MISSING !!!!

    agg_value_prop_dict = {}

    for agg_value in agg_value_list:
        agg_value_prop_dict[agg_value] = (((df.loc[df[agg_value_col] == agg_value][group_col_1].sum()) + \
            ((df.loc[df[agg_value_col] == agg_value][group_col_2].sum() * 0.25))) / ((df[agg_value_col] == agg_value).sum()))

    return agg_value_prop_dict

def convert_bw_g_to_kg(df, country, year):
    """
    Function to update early bf variables to work with function above
    """
    if year == '2000':

        # :: COL_NAMES
        var_birth_weight = config_data[country][year]["low_bw"]["birth_weight"]["col_names"][0]

        df[var_birth_weight] = df[var_birth_weight] / 1000

    else:
        pass

    return df

def mother_edu_none_to_null(df, country, year):
    """
    Function to convert None to NaN for survey year 2000
    """
    # :: COL_NAMES
    var_mother_edu = config_data[country][year]["mother_edu"]["col_names"][0]

    if year == '2000':
        df[var_mother_edu] = np.where(df[var_mother_edu] == 'None', np.nan, df[var_mother_edu])

    else:
        pass

    return df