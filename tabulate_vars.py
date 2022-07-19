"""
Helper functions for data analysis of women's file
"""
from pathlib import Path

import numpy as np
import pandas as pd

import statsmodels.api as sm

from aw_analytics import mean_wt



def read_csv_file(country, recode, year=None, file_type='combined'):
    """
    Function to read in specified file.
    """

    ## Generate filename
    if file_type == 'working':
        data_dir = Path.cwd().joinpath('working')
        fn = country + '_' + recode + '_' + year + '_working' + '.csv'
        
    elif file_type == 'combined':
        data_dir = Path.cwd().joinpath('combined')
        fn = country + '_' + recode + '_combined' + '.csv'

    else:
        pass

    ## Generate full data file path
    file_path = data_dir / fn

    if file_type == 'working':
        df = pd.read_csv(file_path, dtype={"WMID": "string"})
    else:
        df = pd.read_csv(file_path)

    print(f"The file -- {fn} -- has the following shape: Rows: {df.shape[0]}; Columns: {df.shape[1]}")

    df = rename_weight(df, recode, year)

    return df



def concatenate_dfs(list_of_dfs):
    """
    Function to concatenate analyzed dfs into combined file for tabulation
    """

    # Concat them vertically
    df = pd.concat(list_of_dfs, ignore_index=True)

    return df



def save_combined(df, country, recode):

    out_fn = country + "_" + recode + "_combined" + ".csv"

    file_path = Path.cwd() / "combined" / out_fn

    df.to_csv(file_path, index=False)



## Top level function
def extract_regression_params(df, var_dep, ind_var, recode):
    """
    Top level function to get regression params for bivariate stats
    """
    # Convert string inputs to list for compatability with functions below
    var_dep = [var_dep]
    ind_var = [ind_var]

    # Set year and weight vars
    var_year = ['Year']
    if recode == 'women':
        weight = ['wmweight']

    else:
        weight = ['chweight']

    df, year_min_max_list = create_reduced_df(df, var_dep, ind_var, var_year, weight)

    dummies, int_col_name = generate_dummies(df, ind_var, var_year, year_min_max_list)

    output_dict = run_linear_regression(df, var_dep, dummies, int_col_name, weight)

    return output_dict



def create_reduced_df(df, var_dep, ind_var, var_year, weight):
    """
    Function to create reduced df for regression analysis and charts
    """
    temp = df

    keep_col = var_dep + weight + var_year + ind_var

    temp = temp[keep_col].dropna(subset=[var_dep[0]])

    # Identify year_min, year_max
    year_min = temp[var_year[0]].min()
    year_max = temp[var_year[0]].max()

    year_min_max_list = [year_min, year_max]

    # Keep only min, max years
    temp = temp[temp[var_year[0]].isin(year_min_max_list)]

    # Remove wealth middle categories
    temp = drop_wealth_middle_cats(temp, var_dep)

    # Remove region middle categories
    temp = drop_region_middle_cats(temp, var_dep, ind_var, year_min, weight)

    return temp, year_min_max_list


def generate_dummies(df, ind_var, var_year, year_min_max_list):
    """
    Function to generate dummy vars and interaction term for linear regression
    """

    temp = df

    year_max = year_min_max_list[1]

    ## Create Dummy vars
    dummy_vars = var_year + ind_var

    # Get dummies
    for var in dummy_vars:
        temp = temp.join(pd.get_dummies(temp[var], drop_first=False, prefix=str(var)))

    # Get all dummies
    dummy_idx1 = temp.columns.get_loc((dummy_vars[-1])) + 1

    dummies = temp.iloc[:, dummy_idx1:]

    ## Generate interaction term

    ### Get col_names programatically
    int_col_name = 'int_' + str(year_max) + '_' + temp[ind_var[0]].unique()[0]

    year_col_name = 'Year_' + str(year_max)

    ind_vars_col_name = ind_var[0] + '_' + temp[ind_var[0]].unique()[0]

    ### Create interaction term
    dummies[int_col_name] = dummies[year_col_name] * dummies[ind_vars_col_name]

    ### Drop unwanted cols
    dummies_keep = [int_col_name, year_col_name, ind_vars_col_name]

    dummies = dummies[dummies_keep]

    # print(f"The dummies (final) are:\n {dummies}")

    return dummies, int_col_name


def run_linear_regression(df, var_dep, dummies, int_col_name, weight):
    # --- Run Linear Regression (statsmodel OLS)

    temp = df

    ## Set parameters
    y = temp[var_dep]

    X = dummies

    # Add ones to features
    X.insert(0, 'intercept', 1)

    weights = temp[weight]

    ## Run regression
    mod_wls = sm.WLS(y, X, weights = weights)
    res_wls = mod_wls.fit()

    # print(f"Summary of OLS: \n {print(res_wls.summary())}")

    # Get regression outputs: coeff, tvalue, pvalue
    coef = res_wls.t_test([int_col_name]).summary_frame()['coef']
    t_value = res_wls.t_test([int_col_name]).summary_frame()['t']
    p_value = res_wls.t_test([int_col_name]).summary_frame()['P>|t|']

    output_dict = {int_col_name: [coef, t_value, p_value]}
    
    return output_dict


def drop_wealth_middle_cats(df, ind_var):
    """
    Function to drop middle weath categories if var_dep == wealth_q
    """
    temp = df

    if ind_var[0] == 'wealth_q':
        bottom_top_values = ['Poorest', 'Richest']
        temp = temp[temp[ind_var[0]].isin(bottom_top_values)]

    else:
        pass

    return temp

def drop_region_middle_cats(df, var_dep, ind_var, year_min, weight):
    """
    Function to identify best/worst region and subset df
    """
    temp = df
    
    if ind_var[0] == 'region':

        # Identify worst and best region in year_min (using weighted mean)
        worst_region = df[df['Year'] == year_min].groupby(ind_var[0]).apply(mean_wt, var_dep[0], wt=weight[0]).sort_values().index[0]
        best_region = df[df['Year'] == year_min].groupby(ind_var[0]).apply(mean_wt, var_dep[0], wt=weight[0]).sort_values().index[-1]

        # Subset df
        best_worst_values = [worst_region, best_region]
        # print(f"Best and worst regions are: {best_worst_values}")
        temp = temp[temp[ind_var[0]].isin(best_worst_values)]

    else:
        pass

    return temp


def create_bivariate_var_dep(df):
    """
    Function to create bivariate var_dep for analysis
    1. Mother's Education
    2. Ethnicity HoH
    """
    temp = df
    
    # 1. Mother's Education
    none_prim_values = ['Mother Edu: None/ECE', 'Mother Edu: Primary']
    temp['mother_edu_biv'] = np.where(temp['mother_edu'].isin(none_prim_values), 'None_Primary', 'Secondary_Higher')

    # 2. Ethnicity HoH
    kinh_hoa_values = ['Kinh and Hoa']
    temp['eth_hoh_biv'] = np.where(temp['eth_hoh'].isin(kinh_hoa_values), 'Kinh_Hoa', 'Non-Kinh_Hoa') 

    return temp





## --- Helper functions to make comparable across surveys
def rename_weight(df, recode, year):
    """
    Rename WMWEIGHT and CHWEIGHT in 2000 file
    """
    if year == '2000':
        if recode == 'women':
            df.rename(columns = {'WMWEIGHT': 'wmweight'}, inplace = True)
        else:
            df.rename(columns = {'CHWEIGHT': 'chweight'}, inplace = True)
    else:
        pass

    return df