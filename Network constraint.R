# Remove everything in our workspace so we can start with a clean slate:
rm(list = ls())

#install.packages( "sna")

#install.packages("igraph")
#install.packages("statnet")
#nstall.packages("tidyverse")

library(statnet)
library(igraph)
library(sna)

set.seed(12345)
library(tidyverse)


# Create a 5 x 5 matrix (of 30 rows and 30 columns)
edge_list <- tibble(from = c(1,1,1,1,2,2,3,4,4,5,5,5), to = c(2,3,4,5,1,5,1,1,5,1,2,4))
node_list <- tibble(id = 1:5)
net <- graph_from_data_frame(d=edge_list, vertices = node_list, directed=T) 
mymat = get.adjacency(net, names = TRUE)
mymat

#Dyadic constraint = (c[i,j] + c[i,q]*c[q,j], q in c[i], q != i,j )^2, j in c[i], j != i)
#Constraint = c-size(p[i, j]^2) + c-density[2*p[i,j]*sum(p[i,q]*p[q,i])+c-hierarchy((sum(p[i,q]*p[q,i])^2]

#1.Compute proportion of relations in a matrix for the each node 
adjgr = as.matrix(mymat)
tadjgr = t(adjgr)
num = adjgr+tadjgr
p <- num/rowSums(num)
p
adjgr
dim(p)
class(p)
#2.Compute indirect investment of each node with the 2-step path distance 

indir = p%*%p
for(i in 1:dim(indir)[1]) {
  for(j in 1:dim(indir)[2]){
    if (i==j) {
      indir[i,j] = 0
    }
  }
}

#fast way to compute constraint
indir+p
(indir+p)^2
rowSums((indir+p)^2)


#3.Compute c-size according to Burt's formula --> c-size=p[i, j]^2

c_size = apply(p, c(1,2), function(x) x^2)
c_size

#4. Compute c-density 
c_density=2*p*indir
c_density

#4. Compute c-hierarchy
c_hierarchy = indir^2
c_hierarchy

#5.Constraint 

constraint = c_size+c_density+c_hierarchy
constraint
