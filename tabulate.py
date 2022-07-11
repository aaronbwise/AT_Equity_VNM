"""
Helper functions for data analysis of women's file
"""
import json
from pathlib import Path

import numpy as np
import pandas as pd

# # -- Read in survey configuration information -- #
# config_path = Path.cwd().joinpath("women_config.json")
# config_data = json.load(open(config_path))

# Data directory folder
data_dir = Path.cwd().joinpath('analyzed')


def read_csv_file(country, year, recode):
    """
    Function to read in specified file.
    """

    ## Generate filename
    fn = country + '_' + recode + '_' + year + '_working' + '.csv'

    ## Generate full data file path
    file_path = data_dir / fn

    df = pd.read_csv(file_path)

    print(f"The file -- {fn} -- has the following shape: Rows: {df.shape[0]}; Columns: {df.shape[1]}")

    return df

def concatenate_dfs(df):
    """
    Function to concatenate analyzed dfs into combined file for tabulation
    """
    