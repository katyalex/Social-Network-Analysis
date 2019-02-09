rm(list = ls())
library(statnet)
library(igraph)
library(sna)
library(readxl)
library(readstata13)
setwd('D:\\SNA tutorials')

kshap1 = read.csv('kshapnet.csv')
head(kshap1['n_nid_1'])

nodes = vector()
to = vector()
from = vector()
for (row in 1:nrow(kshap1)) {
  ego = kshap1[row,1]
  for (i in 2:7) {
    alter = kshap1[row, i]
    if (is.na(alter)==FALSE){
      from =c(from, ego)
      to=c(to, alter)
      i=+1
    } else {i=+1}
    
  }
}

#data need to sort out nodes that dont live in the Township K
edges = as.data.frame(cbind(from, to))
node1 = c(from,to)
unnode = as.data.frame(sort(unique(node1)))
#People who are living in Township K have IDs less that 320000
node2 = subset(unnode, unnode$`sort(unique(node1))`<320000 )
edgestrue = as.data.frame(subset(edges, edges$to<320000 & edges$from<320000))
#Necessary to put both vertices and nodes, otherwise people without ties would be omitted
net = graph_from_data_frame(edgestrue, directed = T, vertices = node2$`sort(unique(node1))`)
net
write_graph(net, "rnet3.net", "pajek")
