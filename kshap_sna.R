#install.packages('igraph')
#install.packages('xlsx')
library(sna)
library(xlsx)

#WORKSHOPS OF SNA WITH R
#https://github.com/statnet/Workshops/wiki 

#Matrices in R
m <- matrix(data=1, nrow=5, ncol=4)#matrix 5x4 full of 1s
m <- matrix(1,5,4) #same
dim(m) #matrix dimension

m <- matrix(1:10, 10,10)
m[2,] #second row
m[,3] #third column
m[2,3] #cell in second row and third column
m[1:2, 3:8] #submatrix of 1 and 2 row and 3 to 8 columns
m

#Operations with matrices
m>3 # A logical matrix: TRUE for m elements >3, FALSE otherwise:
m[m>3] # Selects only TRUE elements - that is ones greater than 3:

t(m) #transpose 
m1 = t(m)
m3 = m %*% t(m) #matrix multiplication (dot product: multiplicate row by column and add it forming new matrix)
m4 = m*m #element-wise multiplication
m
m1
m3
m4
#Arrays (multidimentional matrices)
a = array(data=1:18, dim=c(3,3,2))# 3d with dimensions 3x3x2
a 

#Networks in igraph
rm(list = ls()) # Remove all the objects we created so far.
g1 <- graph( edges=c(1,2, 2,3, 3, 1), n=3, directed=F ) 

plot(g1) # A simple plot of the network - we'll talk more about plots later

# Now with 10 vertices, and directed by default:
g2 <- graph( edges=c(1,2, 2,3, 3, 1), n=10 )
plot(g2) 

gl <- graph_from_literal(a-+b+-c-+d-e-f, a-g-h-b, h-e:f:i, j)

plot(gl, edge.arrow.size=.05, vertex.color="gold", vertex.size=15,
     vertex.frame.color="gray", vertex.label.color="black", 
     
     vertex.label.cex=1, vertex.label.dist=2, edge.curved=0.2)


#To create graphs from field data, 
#graph_from_edgelist, graph_from_data_frame 
#and graph_from_adjacency_matrix are 
#probably the best choices.

#Data analysis 
#Data representation (nodes (with attributes) & edges)
setwd("D:\\KSHAP DATA\\busan_workshop")
edge = read.xlsx("w1edge.xlsx", 
                sheetIndex = 1)
node = read.xlsx('w1node.xlsx', sheetIndex = 1)
node = node[1:7]
head(node)
head(edge)
nrow(node);length(unique(node$nid))
nrow(edge); nrow(unique(edge[,c("from", "to")]))

#Data representation (adjacency matrix)
mat = read.csv('w1mat.csv', header = T,row.names=1)
m2 = as.matrix(mat)
head(m2)
#Turning into graph
library(igraph)
net = graph_from_data_frame(d = edge, vertices=node$nid, directed=T)
net
net2 = graph_from_adjacency_matrix(m2)
summary(net2)
plot(net2, edge.arrow.size=.4,vertex.label=NA, vertex.size = 5)

#Possible to extract edge list or a matrix from igraph networks
as_edgelist(net, names=T)
as_adjacency_matrix(net, attr="weight")
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")

#SNA descriptives
deg = rowSums(as.matrix(m2))
table( deg, useNA = 'always' )

plot( net, vertex.col = 'lightblue', vertex.cex = (deg + 1)/3)
detach('package:tnet', unload = T)
detach('package:igraph', unload = T)

set.vertex.attribute(net,"cesd_14_d",as.character(node[,7]))
set.vertex.attribute(net,"mmse_c",as.character(node[,5]))
par( mfrow = c( 1, 2 ) )
plot( net, vertex.col = "cesd_14_d", vertex.cex = (deg + 1)/4 )
plot( net, vertex.col = "mmse_c", vertex.cex = (deg + 1)/4 )

coordin <-  plot( net1 + net3)

# ---- Basic network statistics ------------------------------------------------

# The package "sna" can be used for a variety of descriptions and analyses.
# The following are examples.
# some important graph level statistics
library(sna)
net = as.network(m2)
set.vertex.attribute(net, 'age', node$age)
list.network.attributes(net)
summary(net)
net
gden(net) # density
grecip(net) # proportion of dyads that are symmetric
grecip(net, measure = "dyadic.nonnull") # reciprocity, ignoring the null dyads
grecip(net, measure = "edgewise") #proportion of edges which are reciprocated

gtrans(net) # transitivity
component = component.dist(net)
table(component$csize)
connectedness(net)
efficiency(net)
ego.extract(net) #Extract Egocentric Networks from Complete Network Data
evcent(net) #Eigen vector centrality
# dyad and triad census

dyad.census( net )
triad.census( net )

# out degree distribution (of course for a symmetric network outdegree=indegree)

outdegree <- degree( net, cmode = "outdegree" )
indegree = degree(net, cmode = 'indegree')
outdegree #outgoing ties of each note
hist( outdegree )
quantile( outdegree )

# measures of connectivity and distance

dist <- geodist(net, inf.replace = Inf, count.paths = TRUE)
# calculate the geodesic distance (shortest path length) matrix
dist$gd
# matrix of geodesic distances
dist$counts
# matrix containing the number of paths at each geodesic between each pair of vertices
dist
reach <- reachability( net)  # calculate the reachability matrix
reach

#number of isolates in a graph
length(isolates(net))

#K-core score
table(kcores(net))
brokerage(net)
#Centrality measures (closeness) (igraph, sna)

#Igraph package
detach("package:sna", unload=TRUE)
df = as_long_data_frame(net2) #from graph to long df

#Basic stats
ecount(net2) #edge count
outdeg = degree(net2, mode = "in")
table(outdeg)
hist(outdeg)
indeg = degree(net2, mode = 'out')
table(indeg)
hist(indeg)

edge_connectivity(net2) #igraph
hierarch(net2)
is_weighted(net2)
reciprocity(net2)
transitivity(net2)
edge_density(net2)
eigen_centrality(net2) #eigen vector centrality 
sna::connectedness(net) #sna
dyad.census(net2)
triad.census(net2)

igrbet = igraph::betweenness(net2)
snabet = sna::betweenness(net)
igraph::closeness(net2)

comp = components(net2) #weak component
table(comp$csize) #distibution of components
table(graph.coreness(net2)) #k-core score distribution
V(net2)$sex = node$sex #set vertex attribute (gender)
make_k_core_plot <- function (g) {
  lay1 <- layout.fruchterman.reingold(g)
  V(g)$size <- 4
  plot(g, 
       vertex.color = graph.coreness(g), 
       layout=lay1, 
       edge.arrow.size = .1,
       vertex.label=NA)
}

make_k_core_plot(net2)

library(igraph)
library(RColorBrewer)
display.brewer.all()
darkcols <- brewer.pal(5, "Spectral")
kcore = graph.coreness(net2)
kcore = kcore+1
V(net2)$kcore =kcore
V(net2)$color = darkcols[V(net2)$kcore] #vertex colors
lay1 <- layout.fruchterman.reingold(net2) #layout of the graph
V(net2)$size <- 2 #vertex size
plot(net2, vertex.color = darkcols[V(net2)$kcore], 
     layout=lay1, 
     edge.arrow.size = .05,
     vertex.label=NA)

assortativity(net2, types1 = node$sex, directed = T) #similiarity coefficient based on some external property
constraint(net2) #Burt's constraint measure

##### ERGM #####
##Analysis should be proceeded by network object of sna package 
library(statnet)
net
list.network.attributes(net)
set.network.attribute(net, 'age', node$age)
set.network.attribute(net,'lonely', node$cesd_14_d)
set.network.attribute(net, 'sex', node$sex)
list.network.attributes(net)

#ERGM
m1 = ergm(net ~ edges)
summary(m1)

m2 = ergm(net ~ edges+mutual)
summary(m2)
plogis(coef(m2)[['edges']]) #the baseline probability of a tie

plogis(coef(m2)[['edges']] + coef(m2)[['mutual']]) #probability of a tie if the reciprocal tie is present

mcmc.diagnostics(m2)
m3 = ergm(net ~ edges+mutual)

#model fit
m2_gof = gof(m2, GOF = ~model)
m2_gof

#network simulation
sim_nets = simulate(m2, nsim = 4)
sim_nets
m3 = ergm(net ~ edges+gwesp(0.5,fixed=T)+nodematch('sex'),control = control.ergm(seed = 1, MCMC.samplesize = 50000, 
                                                                MCMC.interval = 1000))
m3
list.network.attributes(net)
summary(net~edges)


data(package = 'ergm')
data(florentine)
flomarriage
net

data("faux.magnolia.high")
magnolia <- faux.magnolia.high
magnolia
set.vertex.attribute(net, 'lonely', node$lonely)
set.vertex.attribute(net, 'age', node$age)
set.vertex.attribute(net, 'sex', node$sex)
net

m2 <- ergm(net~edges+mutual+nodematch('sex', diff=T)+nodematch('lonely')) 
summary(m2)
mixingmatrix(net, "sex")
plogis(sum(coef(m2)[c(2,4)]))
coef(m2)[c(2,4)]
coef(m2)
?plogis

#simulation of complete network from ego-centric network data
#http://statnet.csde.washington.edu/workshops/SUNBELT/previous/ergm/ergm%20tutorial.html
#https://statnet.github.io/Workshops/ergm.ego_tutorial.html 
