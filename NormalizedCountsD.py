import pandas as pd
import numpy as np
import os

"""
dictionary used to identify which position a 
certain gene is supposed to be in
"""
pos_dict = {}

validPos1 = ['BMP2', 'AXIN2', 'CDX2']
validPos2 = ['SFRP4', 'CDX1', 'APC']
validPos3 = ['SFRP2', 'WIF1', 'cdkn2a']
validPos4 = ['BMP5', 'SOX17', 'P53']

pos_dict.update(dict.fromkeys(validPos1, '1'))
pos_dict.update(dict.fromkeys(validPos2, '2'))
pos_dict.update(dict.fromkeys(validPos3, '3'))
pos_dict.update(dict.fromkeys(validPos4, '4'))
pos_dict['-mixed'] = '0'
pos_dict['SCRAMB'] = '-3'
pos_dict['ACTB'] = '-3'
pos_dict['SCRAMA'] = '-3'
pos_dict['-line-blank'] = '-1'


# D and DS version
valid_guides = ['BMP2', 'AXIN2', 'APC', 'SFRP4', 'CDX1', 'CDX2', 'SFRP2', 'WIF1', 'cdkn2a', 'BMP5', 'SOX17', 'P53']

directory = 'TEMP'
dir_list = os.listdir(directory)
excel_names = dir_list

def findValidCombos(excel_name):
    """Takes excel name and isolates valid array combinations
    Args:
        excel_name (str): The name of the excel sheet to be used
    Returns:
        pd.DataFrame object: 81 x 3 table with abbrev,
            counts, and ranks
    """
    
    raw_data = pd.read_excel(directory+'/'+excel_name, usecols="A:J")
    processed_data = pd.DataFrame(columns=['abbrev', 'pos1', 'pos2', 'pos3', 'pos4', 'counts', 'rank'])
    
    for index, row in raw_data.iterrows():
        pos4_valid = not pd.isna(raw_data.iloc[index, 4]) 
        pos5_valid = pd.isna(raw_data.iloc[index, 5])
        
        if (pos4_valid and pos5_valid):
            read_order = ""
            read_abbrev = ""
            
            for pos in range(1, 5):
                read_order += pos_dict[raw_data.iloc[index, pos]]
                read_abbrev += raw_data.iloc[index, pos]
                if pos != 4:
                    read_abbrev += "-"
            
            # accounts for completely forward and completely reverse arrays
            if read_order == "1234" or read_order == "4321":
                pos = read_abbrev.split('-')
                valid_read = pd.Series({'abbrev': read_abbrev, 'pos1':pos[0], 'pos2':pos[1], 'pos3':pos[2], 'pos4':pos[3], 'counts': raw_data.iloc[index, 0], "rank" : 0})
                processed_data = pd.concat([processed_data, valid_read.to_frame().T], ignore_index=True)
    
    processed_data['counts'] = pd.to_numeric(processed_data['counts'])
    processed_data['rank'] = pd.to_numeric(processed_data['rank'])
    processed_data.sort_values("counts", ascending=False, inplace=True)
    i = 1
    
    # labels each row with the appropriate rank by counts
    for index, row in processed_data.iterrows():
        processed_data.loc[index, "rank"] = i
        i += 1
    # processed_data.to_csv('excel_nam')
    total = processed_data['counts'].sum()
    d = {"counts":total}
    new_row = pd.DataFrame(data=d, index=["sum"])
    processed_data = pd.concat([processed_data, new_row])
    processed_data["norm counts"] = processed_data['counts'].div(total)
    
    return processed_data

def populateCombinedData(combined_data, excel_names):
    for name in excel_names:
        print(name)
        processed_data = findValidCombos(name)
        new_name = name[:-5] 
        new_rank = new_name + " rank"
        new_counts = new_name + " counts"
        new_norm_counts = new_name + " norm counts"
        processed_data.rename(columns={"rank":new_rank}, inplace=True)
        processed_data.rename(columns={"counts":new_counts}, inplace=True)
        processed_data.rename(columns={"norm counts":new_norm_counts}, inplace=True)
        processed_data.sort_values(new_rank, ascending=False, inplace=True)
        print(processed_data)
        processed_data.to_csv(new_name + 'colsep_normalized.csv')
        combined_data = combined_data.merge(processed_data, how="outer", on="abbrev")
    return combined_data

def mergeNormalizedReads(excel_name):
    """Takes excel name and isolates valid array combinations
    Args:
        excel_name (str): The name of the excel sheet to be used
    Returns:
        pd.DataFrame object: 81 x 3 table with abbrev,
            counts, and ranks
    """
    
    raw_data = pd.read_excel(directory+'/'+excel_name, usecols="A:J")
    processed_data = pd.DataFrame(columns=['abbrev', 'pos1', 'pos2', 'pos3', 'pos4', 'counts', 'rank'])
    
    for index, row in raw_data.iterrows():
        pos4_valid = not pd.isna(raw_data.iloc[index, 4]) 
        pos5_valid = pd.isna(raw_data.iloc[index, 5])
        
        if (pos4_valid and pos5_valid):
            read_order = ""
            read_abbrev = ""
            
            for pos in range(1, 5):
                read_order += pos_dict[raw_data.iloc[index, pos]]
                read_abbrev += raw_data.iloc[index, pos]
                if pos != 4:
                    read_abbrev += "-"
            
            # accounts for completely forward and completely reverse arrays
            if read_order == "1234" or read_order == "4321":
                pos = read_abbrev.split('-')
                valid_read = pd.Series({'abbrev': read_abbrev, 'pos1':pos[0], 'pos2':pos[1], 'pos3':pos[2], 'pos4':pos[3], 'counts': raw_data.iloc[index, 0], "rank" : 0})
                processed_data = pd.concat([processed_data, valid_read.to_frame().T], ignore_index=True)
    
    processed_data['counts'] = pd.to_numeric(processed_data['counts'])
    processed_data['rank'] = pd.to_numeric(processed_data['rank'])
    processed_data.sort_values("counts", ascending=False, inplace=True)
    i = 1
    
    # labels each row with the appropriate rank by counts
    for index, row in processed_data.iterrows():
        processed_data.loc[index, "rank"] = i
        i += 1
    # processed_data.to_csv('excel_nam')
    total = processed_data['counts'].sum()
    d = {"counts":total}
    new_row = pd.DataFrame(data=d, index=["sum"])
    processed_data = pd.concat([processed_data, new_row])
    processed_data["norm counts"] = processed_data['counts'].div(total)
    
    return processed_data

def populatedCombinedNormReads(merged_data, excel_names):
    for name in excel_names:
        print(name)
        excel_data = pd.read_csv(directory+'/'+name, usecols=[1, 8])
        merged_data = merged_data.merge(excel_data, how="left", on="abbrev")
    return merged_data

validCombos = []

# populate merged data with the right abbrevs
for pos1 in validPos1:
    for pos2 in validPos2:
        for pos3 in validPos3:
            for pos4 in validPos4:
                string = f'{pos1}-{pos2}-{pos3}-{pos4}'
                validCombos.append(string)
                

merged_data = pd.DataFrame(columns=["abbrev"], data=validCombos)

merged_data = populatedCombinedNormReads(merged_data, excel_names)
print(merged_data)
merged_data.to_csv("merged_norm_reads.csv", index=False)


# combined_data = pd.DataFrame(columns=["abbrev"])

# combined_data = populateCombinedData(combined_data, excel_names)

# combined_data.to_excel("combined_data_oldseqs.xlsx", index=False)
