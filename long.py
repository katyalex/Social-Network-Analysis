# -*- coding: utf-8 -*-
"""
Created on Wed Mar 20 21:18:58 2019

@author: KATE
"""
import pandas as pd
import os

os.chdir('C:\\Users\\KATE\\Documents\\카카오톡 받은 파일')


data = pd.read_excel('데이터.xlsx', sheet_name='nid') 
name = pd.read_excel('데이터.xlsx', sheet_name = 'name')



nid1 = []
ego1 = []
age1 = []
sex1 = []


for index, row in data.iterrows():
    ego=int(row['nid'])
    for i in range(1,7):
        try:
            nid = int(row['n_nid_'+str(i)])
            age = row['n_age_'+str(i)]
            sex = row['n_sex_'+str(i)]
            nid1.append(nid)
            ego1.append(ego)
            age1.append(age)
            sex1.append(sex)
            i=+1
        except ValueError:
            nid = row['n_nid_'+str(i)]
            nid1.append(nid)
            i=+1

name1 = []
ri1 = []
ri2 = []
for index, row in name.iterrows():
    for i in range(1,7):
        n = row['n_name_'+str(i)]
        name1.append(n)
        ri = row['n_ri1_'+str(i)]
        ri_i = row['n_ri2_'+str(i)]
        ri2.append(ri_i)
        ri1.append(ri)
        i=+1
        
df = pd.DataFrame(
    {'ego_nid': ego1,
     'n_nid': nid1,
     'n_name': name1,
     'n_sex' : sex1, 
     'n_age' : age1,
     'n_ri1' : ri1,
     'n_ri2': ri2
    })

    
df.to_csv('buleundata.csv', sep='\t', encoding='utf-8')
