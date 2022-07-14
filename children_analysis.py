"""
Helper functions for data analysis of children's file
"""
import json
from pathlib import Path

import numpy as np
import pandas as pd

from women_analysis import create_mother_edu

# -- Read in survey configuration information -- #
config_path = Path.cwd().joinpath("children_config.json")
config_data = json.load(open(config_path))



### MOM'S ID TO MERGE EDU DATA FROM HL FILE

def generate_MOMID(df, country, year):
    """
    Function takes a dataframe to generate unique MOMID to
    facilitate merging data between recodes.
    """
    
    # -- Create unique MOMID -- #
    momid = config_data[country][year]["momid"]["col_names"][0]

    df[momid] = df[momid].apply(lambda x: str(x).strip().replace(".", "-").replace("-0", "").zfill(3))

    df["MOMID"] = df["HHID"] + df[momid]

    if df["MOMID"].nunique() == df.shape[0]:
        print("MOMID is unique")
    else:
        print("MOMID is NOT unique")



def merge_mother_edu(df, country, year):
    """
    For use on Child files.

    Function to merge mother edu data into Child file.
    """

    recode = "merge"

    ## Generate merge filenames
    mom_edu_fn = config_data[country][year]["mom_edu_fn"]

    ## Generate full data file path
    mom_edu_file_path = Path.cwd() / "data" / year / recode / mom_edu_fn

    # Read in data
    mom_edu_df = pd.read_csv(mom_edu_file_path, dtype={"MEMID": "string"})

    df = (
        df[:]
        .merge(mom_edu_df, left_on="MOMID", right_on="MEMID", how="left")
    )

    df = df.drop(columns=['MEMID'])

    return df



def create_sex_ch(df, country, year):
    """
    Function to create child sex variable [sex_ch]
    """
    # :: COL_NAMES
    var_sex_ch = config_data[country][year]["sex_ch"]["col_names"][0]

    # :: VALUES
    sex_ch_male_values = config_data[country][year]["sex_ch"]["values"]["male"][0]

    # Create indicator
    df["sex_ch"] = np.where(df[var_sex_ch] == sex_ch_male_values, 'Male', 'Female')

    return df



def create_ch_age_cat(df, country, year):
    """
    Function to create child age categories variable [ch_age_cat]
    """
    # :: COL_NAMES
    var_ch_age_cat = config_data[country][year]["ch_age_cat"]["col_names"][0]

    # Create indicators
    df["ch_age_cat_0_5"] = np.where(df[var_ch_age_cat] <= 5, 100, 0)
    df["ch_age_cat_6_8"] = np.where((df[var_ch_age_cat] >= 6) & (df[var_ch_age_cat] <= 8), 100, 0)
    df["ch_age_cat_9_23"] = np.where((df[var_ch_age_cat] >= 9) & (df[var_ch_age_cat] <= 23), 100, 0)
    df["ch_age_cat_12_23"] = np.where((df[var_ch_age_cat] >= 12) & (df[var_ch_age_cat] <= 23), 100, 0)
    df["ch_age_cat_6_23"] = np.where((df[var_ch_age_cat] >= 6) & (df[var_ch_age_cat] <= 23), 100, 0)

    return df



def create_excl_bf(df, country, year):
    """
    Function to create Exclusive Breasftfeed variable [excl_bf]
    """
    # :: COL_NAMES
    var_breastmilk = config_data[country][year]["excl_bf"]["breastmilk"]["col_names"][0]
    var_liquids = config_data[country][year]["excl_bf"]["liquids"]["col_names"]
    var_solids = config_data[country][year]["excl_bf"]["solids"]["col_names"]

    # :: VALUES
    breastmilk_yes_values = config_data[country][year]["excl_bf"]["breastmilk"]["values"][0]
    liquids_yes_values = config_data[country][year]["excl_bf"]["liquids"]["values"][0]
    solids_yes_values = config_data[country][year]["excl_bf"]["solids"]["values"][0]

    ## Create sub-indicators
    df['breastmilk'] = np.where(df[var_breastmilk] == breastmilk_yes_values, 100, 0)

    ## No liquids sub-indicator
    df['liquids_none'] = np.where(df[var_liquids].ne(liquids_yes_values).all(axis = 1), 100, 0)

    ## No solids sub-indicator
    df['solids_none'] = np.where(df[var_solids].ne(solids_yes_values).all(axis = 1), 100, 0)

    # Create indicator
    df['excl_bf'] = np.where((df['breastmilk'] == 100) & (df['liquids_none'] == 100) & (df['solids_none'] == 100), 100, 0)
    df['excl_bf'] = np.where(df['ch_age_cat_0_5'] == 0, np.nan, df['excl_bf'])

    return df


def create_cont_1223_bf(df):
    """
    Function to create Continued BF 12-23 months variable [cont_1223_bf]
    """

    # Create indicator
    df['cont_1223_bf'] = np.where(df['breastmilk'] == 100, 100, 0)
    df['cont_1223_bf'] = np.where(df['ch_age_cat_12_23'] == 0, np.nan, df['cont_1223_bf'])

    return df


def create_mdd_ch(df, country, year):
    """
    Function to create Minimum Dietary Diversity variable [mdd_ch]
    """
    # :: COL_NAMES
    var_grains = config_data[country][year]["mdd_ch"]["grains"]["col_names"]
    var_legumes = config_data[country][year]["mdd_ch"]["legumes"]["col_names"]
    var_dairy = config_data[country][year]["mdd_ch"]["dairy"]["col_names"]
    var_flesh = config_data[country][year]["mdd_ch"]["flesh"]["col_names"]
    var_eggs = config_data[country][year]["mdd_ch"]["eggs"]["col_names"]
    var_vitaminA = config_data[country][year]["mdd_ch"]["vitaminA"]["col_names"]
    var_other = config_data[country][year]["mdd_ch"]["other"]["col_names"]

    # :: VALUES
    grains_values = config_data[country][year]["mdd_ch"]["grains"]["values"][0]
    legumes_values = config_data[country][year]["mdd_ch"]["legumes"]["values"][0]
    dairy_values = config_data[country][year]["mdd_ch"]["dairy"]["values"][0]
    flesh_values = config_data[country][year]["mdd_ch"]["flesh"]["values"][0]
    eggs_values = config_data[country][year]["mdd_ch"]["eggs"]["values"][0]
    vitaminA_values = config_data[country][year]["mdd_ch"]["vitaminA"]["values"][0]
    other_values = config_data[country][year]["mdd_ch"]["other"]["values"][0]

    ## Create sub-indicators
    df['grains'] = np.where(df[var_grains].eq(grains_values).any(axis = 1), 100, 0)
    df['legumes'] = np.where(df[var_legumes].eq(legumes_values).any(axis = 1), 100, 0)
    df['dairy'] = np.where(df[var_dairy].eq(dairy_values).any(axis = 1), 100, 0)
    df['flesh'] = np.where(df[var_flesh].eq(flesh_values).any(axis = 1), 100, 0)
    df['eggs'] = np.where(df[var_eggs].eq(eggs_values).any(axis = 1), 100, 0)
    df['vitaminA'] = np.where(df[var_vitaminA].eq(vitaminA_values).any(axis = 1), 100, 0)
    df['other'] = np.where(df[var_other].eq(other_values).any(axis = 1), 100, 0)

    # Create indicator
    food_groups = ['breastmilk', 'grains', 'legumes', 'dairy', 'flesh', 'eggs', 'vitaminA', 'other']

    df['mdd_ch'] = np.where(df[food_groups].apply(sum, axis = 1) >= 500, 100, 0)
    df['mdd_ch'] = np.where(df['ch_age_cat_6_23'] == 0, np.nan, df['mdd_ch'])

    return df



def create_mmf_ch(df, country, year):
    """
    Function to create Minimum Meal Frequency variable [mmf_ch]
    """
    # :: COL_NAMES
    var_formula_times = config_data[country][year]["mmf_ch"]["formula_times"]["col_names"][0]
    var_other_milk_times = config_data[country][year]["mmf_ch"]["other_milk_times"]["col_names"][0]
    var_yogurt_times = config_data[country][year]["mmf_ch"]["yogurt_times"]["col_names"][0]
    var_solid_semi_soft_times = config_data[country][year]["mmf_ch"]["solid_semi_soft_times"]["col_names"][0]

    # :: VALUES
    num_times_cat_list = config_data[country][year]["mmf_ch"]["num_times_cat_list"]
    num_times_float_list = config_data[country][year]["mmf_ch"]["num_times_float_list"]

    ## Create sub-indicators
    num_times_dict = dict(zip(num_times_cat_list, num_times_float_list))

    df['formula_times'] = df[var_formula_times].map(num_times_dict).astype(float).fillna(0)
    df['other_milk_times'] = df[var_other_milk_times].map(num_times_dict).astype(float).fillna(0)
    df['yogurt_times'] = df[var_yogurt_times].map(num_times_dict).astype(float).fillna(0)
    df['solid_semi_soft_times'] = df[var_solid_semi_soft_times].map(num_times_dict).astype(float).fillna(0)

    # print(f"solid_semi_soft_times value_counts is: \n {df['solid_semi_soft_times'].value_counts(dropna=False)}")

    ## BREASTFED: Age 6-8 months with 2 soft, semi-soft, solid feeds
    df['mmf_bf_68'] = np.where((df['breastmilk'] == 100) & (df['solid_semi_soft_times'] >= 2), 100, 0)
    df['mmf_bf_68'] = np.where(df['ch_age_cat_6_8'] == 0, 0, df['mmf_bf_68'])

    ## BREASTFED: Age 9-23 months with 3 soft, semi-soft, solid feeds
    df['mmf_bf_923'] = np.where((df['breastmilk'] == 100) & (df['solid_semi_soft_times'] >= 3), 100, 0)
    df['mmf_bf_923'] = np.where(df['ch_age_cat_9_23'] == 0, 0, df['mmf_bf_923'])

    ## NON-BREASTFED: Age 6-23 months with 4 soft, semi-soft, solid or milk feeds (** At least 1 is semi, soft, solid)
    solid_semi_soft_milk_times = ['formula_times', 'other_milk_times', 'yogurt_times', 'solid_semi_soft_times']
    df['solid_semi_soft_milk_times'] = np.where(df[solid_semi_soft_milk_times].apply(sum, axis = 1) >= 4, 100, 0)

    df['mmf_nbf_623'] = np.where((df['breastmilk'] == 0) & (df['solid_semi_soft_milk_times'] == 100) & (df['solid_semi_soft_times'] >= 1), 100, 0)
    df['mmf_nbf_623'] = np.where(df['ch_age_cat_6_23'] == 0, 0, df['mmf_nbf_623'])
    
    # Create indicator
    mmf_cols = ['mmf_bf_68', 'mmf_bf_923', 'mmf_nbf_623']
    df['mmf_ch'] = np.where(df[mmf_cols].eq(100).any(axis = 1), 100, 0)
    df['mmf_ch'] = np.where(df['ch_age_cat_6_23'] == 0, np.nan, df['mmf_ch'])

    return df


def create_mad_ch(df):
    """
    Function to create Minimum Acceptable Diet variable [mad_ch]
    """

    ## Create sub-indicators
    ## BREASTFED: Age 6-23 months w/ mdd and mmf
    df['mad_bf_623'] = np.where((df['breastmilk'] == 100) & (df['mdd_ch'] == 100) & (df['mmf_ch'] == 100), 100, 0)

    ## NON-BREASTFED: Age 6-23 months w/ mdd and mmf and >= 2 milk feeds
    milk_times = ['formula_times', 'yogurt_times', 'other_milk_times']
    df['milk_feeds_2'] = np.where(df[milk_times].sum(axis = 1) >= 2, 100, 0)

    df['mad_nbf_623'] = np.where((df['breastmilk'] == 0) & (df['mdd_ch'] == 100) & (df['mmf_ch'] == 100) & (df['milk_feeds_2'] == 100), 100, 0)

    # Create indicator
    mad_cols = ['mad_bf_623', 'mad_nbf_623']
    df['mad_ch'] = np.where(df[mad_cols].eq(100).any(axis = 1), 100, 0)
    df['mad_ch'] = np.where(df['ch_age_cat_6_23'] == 0, np.nan, df['mad_ch'])

    return df



def subset_children_file(df, country, year):
    """
    Function to subset children file for 1. Complete 
    """
    # :: COL_NAMES
    var_children_complete = config_data[country][year]["children_file_subset"]["col_names"][0]

    # :: VALUES
    children_complete_values = config_data[country][year]["children_file_subset"]["values"][0]

    # Subset df
    df = df[(df[var_children_complete] == children_complete_values)]

    print(f"The number of children with a completed survey is: {df.shape[0]}")

    return df
