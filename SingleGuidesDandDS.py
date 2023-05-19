# -*- coding: utf-8 -*-
"""
Created on Mon May  1 12:28:47 2023

@author: crose
"""

import pandas as pd
import numpy as np
import os

"""
dictionary used to identify which position a 
certain gene is supposed to be in
"""
pos_dict = {}

pos_dict.update(dict.fromkeys(['BMP2', 'AXIN2', 'CDX2'], '1'))
pos_dict.update(dict.fromkeys(['SFRP4', 'CDX1', 'APC'], '2'))
pos_dict.update(dict.fromkeys(['SFRP2', 'WIF1', 'cdkn2a'], '3'))
pos_dict.update(dict.fromkeys(['BMP5', 'SOX17', 'P53'], '4'))

# D and DS version
valid_guides = ['BMP2', 'AXIN2', 'APC', 'SFRP4', 'CDX1', 'CDX2', 'SFRP2', 'WIF1', 'cdkn2a', 'BMP5', 'SOX17', 'P53']
new_valid_guides = ['BMP2', 'AXIN2', 'APC', 'SFRP4', 'CDX1', 'CDX2', 'SFRP2', 'WIF1', 'CDKN2A', 'BMP5', 'SOX17', 'TRP53']

directory = 'TEMP'
dir_list = os.listdir(directory)
excel_names = dir_list
 
def findSingleGuides(excel_name):
    """Takes excel name and isolates valid array combinations
    Args:
        excel_name (str): The name of the excel sheet to be used
    Returns:
        pd.DataFrame object: 81 x 3 table with abbrev,
            counts, and ranks
    """    
    df = pd.read_excel(directory+'/'+excel_name, usecols="A:J")
    processed_data = pd.DataFrame(columns=valid_guides)
    processed_data.insert(0, "sample_name", True)
    df = df.loc[(df["position 1"].isin(valid_guides)) & (pd.isna(df["position 2"]))]
    df = df.pivot(index="position 2", columns="position 1", values="counts")
    df.reset_index(inplace=True)
    df.drop(columns=["position 2"], inplace=True)
    df.rename(columns={"cdkn2a":"CDKN2A", "P53":"TRP53"}, inplace=True)
    df.rename(index={0:excel_name[0:excel_name.find(".")]}, inplace=True)
    return df

def populateCombinedDataSingleGuides(combined_data, excel_names):
    for name in excel_names:
        print(name)
        processed_data = findSingleGuides(name)
        combined_data = pd.concat([combined_data, processed_data])
    return combined_data

combined_data = pd.DataFrame(columns=new_valid_guides)

combined_data = populateCombinedDataSingleGuides(combined_data, excel_names)

combined_data.to_excel("SingleGuides_DandDS.xlsx")
