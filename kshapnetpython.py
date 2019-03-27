# -*- coding: utf-8 -*-
"""
Created on Fri Feb  1 13:24:03 2019

@author: KATE
"""

import networkx as nx #network 분석 함수 라이브러리
nx.__version__
import pandas as pd #데이터프레임 만드는 라이브러리
import os
from networkx.algorithms import community

os.chdir('D:\\SNA tutorials')
table = pd.read_csv('kshapnet4.csv') #데이터 읽기
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


communities_generator = community.girvan_newman(net1)
top_level_communities = next(communities_generator)
next_level_communities = next(communities_generator)
sorted(map(sorted, top_level_communities))


nid = []
comm=  []
for i in next_level_communities:
    for k in i:
        nid.append(k)
        comm.append(len(i))
        k=+1
    i=+1
        
nidcoms = []
nids = []
for i in table['nid']:
    for j in range(len(nid)):
        ego = nid[j]
        if i==ego:
            nidcoms.append(comm[j])
            nids.append(i)
            i=+1

import collections
counter=collections.Counter(nidcoms)
print(counter)
import numpy as np
np.savetxt("commsw4.csv",np.column_stack((nids, nidcoms)), delimiter=",", fmt='%s')

nx.number_connected_components(net1)
nx.connected_components(net1)
nx.kamada_kawai_layout(net1)
net1.nodes.data()
import matplotlib.pyplot as plt
nx.draw(net1)
options = { 'node_color': 'black','node_size': 50,'width': 3}
nx.draw(net1, **options)
bb = nx.betweenness_centrality(net1)
community = {}
for j in range(len(nid)):
        community[nid[j]] =  comm[i]
        
from itertools import count
nx.set_node_attributes(net1, community, 'community')
groups = set(nx.get_node_attributes(net1,'community').values())
mapping = dict(zip(sorted(comm),count()))
nodes = net1.nodes()
colors = [mapping[net1.node[n]['community']] for n in net1.nodes()]
pos = nx.spring_layout(net1)
ec = nx.draw_networkx_edges(net1, pos, alpha=1)
nc = nx.draw_networkx_nodes(net1, pos, nodelist=nodes, node_color=comm, 
                            with_labels=False, node_size=5, cmap=plt.cm.jet)

plt.colorbar(nc)
plt.axis('off')
plt.show()

color = nx.get_node_attributes(net1, 'between')
between = []
for k in color.values():
    between.append(k)
    k=+1

nx.periphery(net1)






