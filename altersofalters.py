# -*- coding: utf-8 -*-
"""
Created on Wed Mar 27 19:53:11 2019

@author: KATE
"""

import pandas as pd
import os 


os.chdir('D:\\Yonsei\\2018년 2학기\\Mortality and providing social support')
table = pd.read_stata('w1.dta') #데이터 읽기
nids = table[['nid', 'n_nid_1','n_nid_2','n_nid_3', 'n_nid_4', 'n_nid_5', 'n_nid_6', 'n_nid_7','wave','komsano', 'n_komsa_1', 'n_komsa_2','n_komsa_3','n_komsa_4','n_komsa_5','n_komsa_6','n_komsa_7']]
newdf = nids
komsa = table[[]]


df = pd.DataFrame({'nid': [], 'n_nid_1': [], 'n_nid_2': [],'n_nid_3': [], 'n_nid_4': [], 'n_nid_5': [],'n_nid_6': [],'n_nid_7': [], 'n_nid_11': [],  'n_nid_12': [],  'n_nid_13': [],  'n_nid_14': [],  'n_nid_15': [],  'n_nid_16': [], 
                    'n_nid_17': [], 'n_nid_21': [], 'n_nid_22': [], 'n_nid_23': [], 'n_nid_24': [], 'n_nid_25': [], 'n_nid_26': [],
                     'n_nid_27': [],  'n_nid_31': [], 'n_nid_32': [], 'n_nid_33': [], 'n_nid_34': [], 'n_nid_35': [], 'n_nid_36': [],
                      'n_nid_37': [], 'n_nid_41': [], 'n_nid_42': [], 'n_nid_43': [], 'n_nid_44': [], 'n_nid_45': [], 'n_nid_46': [],
                       'n_nid_47': [], 'n_nid_51': [], 'n_nid_52': [], 'n_nid_53': [], 'n_nid_54': [], 'n_nid_55': [], 'n_nid_56': [],
                        'n_nid_57': [],  'n_nid_61': [], 'n_nid_62': [], 'n_nid_63': [], 'n_nid_64': [], 'n_nid_65': [] ,'n_nid_66': [], 'n_nid_67': [],
                         'n_nid_71': [],   'n_nid_72': [], 'n_nid_73': [], 'n_nid_74': [], 'n_nid_75': [], 'n_nid_76': [], 'n_nid_77': []})

dfkomsa = pd.DataFrame({'nid': [], 'n_nid_1': [], 'n_nid_2': [],'n_nid_3': [], 'n_nid_4': [], 'n_nid_5': [],'n_nid_6': [],'n_nid_7': [], 'n_nid_11': [],  'n_nid_12': [],  'n_nid_13': [],  'n_nid_14': [],  'n_nid_15': [],  'n_nid_16': [], 
                    'n_nid_17': [], 'n_nid_21': [], 'n_nid_22': [], 'n_nid_23': [], 'n_nid_24': [], 'n_nid_25': [], 'n_nid_26': [],
                     'n_nid_27': [],  'n_nid_31': [], 'n_nid_32': [], 'n_nid_33': [], 'n_nid_34': [], 'n_nid_35': [], 'n_nid_36': [],
                      'n_nid_37': [], 'n_nid_41': [], 'n_nid_42': [], 'n_nid_43': [], 'n_nid_44': [], 'n_nid_45': [], 'n_nid_46': [],
                       'n_nid_47': [], 'n_nid_51': [], 'n_nid_52': [], 'n_nid_53': [], 'n_nid_54': [], 'n_nid_55': [], 'n_nid_56': [],
                        'n_nid_57': [],  'n_nid_61': [], 'n_nid_62': [], 'n_nid_63': [], 'n_nid_64': [], 'n_nid_65': [] ,'n_nid_66': [], 'n_nid_67': [],
                         'n_nid_71': [],   'n_nid_72': [], 'n_nid_73': [], 'n_nid_74': [], 'n_nid_75': [], 'n_nid_76': [], 'n_nid_77': []})

for index,row in newdf.iterrows():
    ego = int(row['nid'])
    komsa = int(row['komsano'])
    number = row.name
    df.set_value(number, 'nid', ego)
    dfkomsa.set_value(number, 'nid', komsa)
    for i in range(1,8):
        try:
            alter= int(row['n_nid_'+str(i)])
            alterkomsa = int(row['n_komsa_'+str(i)])
            try:
                num = newdf[newdf['nid']==alter].index.item()
                newego = int(newdf.iloc[num]['nid'])
                newkomsa = int(newdf.iloc[num]['n_komsa_'+str(i)])
                df.set_value(number, 'n_nid_'+str(i), newego)
                dfkomsa.set_value(number,'n_nid_'+str(i),newkomsa )
                for k in range(1, 8):
                        try:
                            newalter = int(newdf.iloc[num]['n_nid_'+str(k)])
                            if newalter==ego:
                                k=+1
                            else:
                                newalterkomsa= int(newdf.iloc[num]['n_komsa_'+str(k)])
                                df.set_value(number, 'n_nid_'+str(i)+str(k), newalter)
                                dfkomsa.set_value(number,'n_nid_'+str(i)+str(k),newalterkomsa )
                        except ValueError:
                                k=+1
            except ValueError:
                df.set_value(number, 'n_nid_'+str(i), alter)
                dfkomsa.set_value(number,'n_nid_'+str(i),alterkomsa)
                for k in range(1, 7):
                        try:
                            newalter = int(newdf.iloc[num]['n_nid_'+str(k)])
                            if newalter==ego:
                                k=+1
                            else:
                                newalterkomsa= int(newdf.iloc[num]['n_komsa_'+str(k)])
                                df.set_value(number, 'n_nid_'+str(i)+str(k), newalter)
                                dfkomsa.set_value(number,'n_nid_'+str(i)+str(k),newalterkomsa )
                        except ValueError:
                                k=+1
        except ValueError:
            i=+1

df.to_csv('altersofalters.csv', index=False)    
