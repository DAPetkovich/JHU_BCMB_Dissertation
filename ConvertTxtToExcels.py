# -*- coding: utf-8 -*-
"""
Created on Wed Mar 15 15:01:08 2023

@author: crose
"""
import pandas as pd
import os

directory = 'TXT_FILES'
dir_list = os.listdir(directory)

def line_prepender(filename, line):
    with open(filename, 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write(line.rstrip('\r\n') + '\n' + content)

def line_remover(filename):
    with open(filename, 'r+') as f: # open file in read / write mode
        f.readline() 
        data = f.read() 
        f.seek(0) 
        f.write(data) 
        f.truncate() 
 
# makes the appropriate amount of columns at top of txt file
for file in dir_list:
        if file.endswith('txt'):
            line_prepender(directory+'/'+file, '1 2 3 4 5 6 7 8 9 10 11')
    
#modifies it to csv
for file in dir_list:
    if file.endswith('txt'):
        index = file.find('_')
        sample_name = file[0:index]
        read_txt = pd.read_csv(directory+'/'+file, delim_whitespace=(True), header=None)
        read_txt.drop(index=read_txt.index[0], axis=0, inplace=True)
        read_txt.to_excel(sample_name+'.xlsx', header=['counts', 'position 1', 'position 2', 'position 3', 'position 4', 'position 5', 'position 6', 'position 7', 'position 8', 'position 9', 'position 10'], index=False)
        line_remover(directory+'/'+file)

print('finished converting files')