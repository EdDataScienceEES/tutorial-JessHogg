### Introduction to igraph and Basics ----

# Install and load package 
install.packages("igraph")
library(igraph)

## Creating graphs from scrtach 
    # - lets first understand the basics 
first_graph <- make_graph(c(1, 2, 2, 3, 3, 4), directed = TRUE)
plot(first_graph) # this is to manulally creat smaller graphs 
g <- graph_from_literal(A - B - C, A - D)
plot(g) # creates graohs using simple text-like representation useful for small illustrative examples 
# if you want to include multiple edges then use can add : ( A-B:C) . Make sure you know if egdes are undirected or directed as they require differnt input of code -- undirected, -> directed 
g1 <- graph_from_literal(A - B:C, A-D)
plot(g1) # multiple edges 
g2<- graph_from_literal(A--B--C--A)
plot (g2) # undirected edges 
g3<- graph_from_literal(A -+ B -+ C -+ A) 
plot(g3) # Directed edges 

# addind graoh to the same panel 
par(mfrow = c(1, 3)) 
par(mar = c(2, 2, 2, 2))  # Adjust margins
# Plot each graph
plot(g1, main = "Graph 1: Mixed Edges")
plot(g2, main = "Graph 2: Undirected")
plot(g3, main = "Graph 3: Directed")

# Reset plotting parameters
par(mfrow = c(1, 1))

## Creating graphs from datasets 
  # description: 3 way s
#load  dataset(s)
Edges <- read.csv("edges data.csv")
Nodes <- read.csv ("nodes data.csv")

#1
foodweb <- graph_from_data_frame(d = Edges, vertices = Nodes, directed = TRUE)
plot(foodweb)
#2 - adjacent matrix 
adj_matrix <- as_adjacency_matrix(foodweb, attr = "Weight", sparse = FALSE)
print(adj_matrix)
#3 - edge list 
edge_list <- as_data_frame(foodweb, what = "edges")
print(edge_list)
# 4 - incidence matrix ?
#5 
network<- graph_from_adjacency_matrix(adj_matrix)
network<- graph_from_data_frame(d = edge_list, directed = F)
plot(network)

## differnt graph shapes 
g_ring<- make_ring(10)
plot(g_ring)
g5 <- make_star(n = 6, mode = "undirected")
plot(g5)
g6 <- make_tree(n = 7, children = 2)
plot(g6)
g7<- make_lattice(dimvector = c(3, 3))
plot(g7)

par(mfrow = c(1, 4)) 
par(mar = c(2, 2, 2, 2))  # Adjust margins
# Plot each graph
plot(g4, main = "ring")
plot(g5, main = "star")
plot(g6, main = "tree")
plot(g7, main = "lattice")

# Reset plotting parameters
par(mfrow = c(1, 1))

## now that we have covered the basics lets start to manipulate and analyse the datasets 







# visulise Network 
