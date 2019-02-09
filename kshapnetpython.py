# -*- coding: utf-8 -*-
"""
Created on Fri Feb  1 13:24:03 2019

@author: KATE
"""

import networkx as nx #network 분석 함수 라이브러리
import pandas as pd #데이터프레임 만드는 라이브러리

table = pd.read_excel('kshapnet.xlsx') #데이터 읽기
net1 = nx.Graph() #대상간 방향성을 고려하는 경우=nx.DiGraph, 일방향인 경우=nx.Graph

net1 = nx.Graph()
for index, row in table.iterrows():
    ego=int(row['nid'])
    net1.add_node(ego) 

len(net1.nodes)
for index, row in table.iterrows():
    ego=int(row['nid'])
    for i in range(1,7):
        try:
            alter= int(row['n_nid_'+str(i)])
            net1.add_edge(ego, alter)
        except ValueError:
            i=+1

len(net1.nodes)
nx.write_pajek(net1,'newnet.net')
