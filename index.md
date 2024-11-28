# Introduction to visualising networks using igraph
## Tutorial Aims: 
1. To have an overall understanding of the package igraph
2. To learn how to create, manipulate and analyse graphs  
3. To product effective and informative graphs  ... To become confident 
   
## Tutorial Steps: 
#### <a href="#1"> 1. Introduction to igraph and Basics</a>
#### <a href="#2"> 2. Analysis and Manipulation</a>
#### <a href="#3"> 3. Visulisation</a>

<a name="1"></a>
### 1. Introduction to igraph and Basics 

Welcome to the igraph tutorial! 
Don't worry if you are not familiar with the igraph package yet. We will start from the begining taking it step by step so you will be confident in no time.  

We will explore the dynamic igraph package in R, which is an open source used to create, analyse and visualise networks and graph routines. Networks and graphs are a key component when modeling relationships and interactions of complex systems/structures. Whether you are working in socal, commmuntication or biological fields igraph is useful to help understand individual connections. Well will focus on using igraph to visualise biological networks specifically ecological food webs. As food webs represent the feeding relationships within an environment where different species are conectted by predator prey interactions. 

Before we dive in to igraph lets define sone key concepts: 
- A vertex (node) is an indiviual element of the network(graph) e.g. species
- An link (edge) is the connection between two vertices showing a relationship e.g. predator-prey relationship.

Lets start! - Understanding the basics

First step is to install and load the igraph 
```r
install.packages("igraph") # install package 
library(igraph) # load package
```
Once we have successfully loaded igraph then we can start to create some simple graphs to familirse ourselves with certain function that this package offers 
```r
first_graph <- make_graph(c(1, 2, 2, 3, 3, 4), directed = TRUE)
plot(first_graph) # this is to manulally create smaller graphs 
g <- graph_from_literal(A - B - C, A - D)
plot(g) # creates graphs using simple text-like representation useful for small illustrative examples
```
If you want to include multiple edges then use can add : However you need to know if your edges are undirected or directed
- Directed: when an edge has a specific direction from one vertex to another. In other words if it demonstrates a one way relationship. When graph is plotted arrows appear to show direction
- Undirected: when an edge does not have a direction, therefore a mutualistic relationship between vertices. No arrows present when plotted just soild lines. 

```r
g1 <- graph_from_literal(A - B:C, A-D)
plot(g1) # multiple edges 
g2<- graph_from_literal(A--B--C--A)
plot (g2) # undirected edges 
g3<- graph_from_literal(A -+ B -+ C -+ A) 
plot(g3) # Directed edges
```
<img width="436" alt="image" src="https://github.com/user-attachments/assets/7a35a9ea-971e-43bf-a91c-82766e103e67">

Now that have an understanding of plotting graphs lets start to incorporate datasets. 
The code below shows you how to load a dataset the has been saved to your working directory. If you have the files saved somewhere else then that is fine, you just have to change put the path directory inside the brackets instead. 
```r
# load dataset(s)
Edges <- read.csv("edges data.csv") 
Nodes <- read.csv ("nodes data.csv") 
```
igraph has different ways to create a graph object: 
1. Using graph_from_data_frame
2. Adjacency Matrix: A square matrix with rows and columns representing vertices, and values representing edge weights
3. Edge List: A data frame with two columns (to and from) representing edges
```r
#1.
foodweb <- graph_from_data_frame(d = Edges, vertices = Nodes, directed = TRUE)
plot(foodweb)
#2.
adj_matrix <- as_adjacency_matrix(foodweb, attr = "Weight", sparse = FALSE)
print(adj_matrix)
#3. 
edge_list <- as_data_frame(foodweb, what = "edges")
print(edge_list)
# Visulise Network 
network<- graph_from_adjacency_matrix(adj_matrix)
network<- graph_from_data_frame(d = edge_list, directed = F)
plot(network)
```
network: 


<img width="272" alt="image" src="https://github.com/user-attachments/assets/cdf30561-2e45-4daa-ae3a-c46c04d8259c">

igraph allows you do decide the shape of the graph. Here are some examples of the different shapes available 
```r
g_ring<- make_ring(10)
plot(g_ring)
g5 <- make_star(n = 6, mode = "undirected")
plot(g5)
g6 <- make_tree(n = 7, children = 2)
plot(g6)
g7<- make_lattice(dimvector = c(3, 3))
plot(g7)
```
<img width="394" alt="image" src="https://github.com/user-attachments/assets/eb6786e5-9dd0-4a2a-bcc8-0d2e2939c58e">

Amazing! Now that we have been introduced to igraph and covered the basics lets have a try at manupulating and analysing data 
<a name="2"></a>
### Analysis and Manipulation
Communites 
```r
comm <- cluster_edge_betweenness(foodweb)
print(comm)
comm_2 <- cluster_louvain(network)
plot(comm_2, network)
```
Shortest path
```r
shortest <- shortest_paths(g, from = 1)
print(shortest$vpath[1:5])
```
Degree
```r
deg <- degree(foodweb)
print(deg)

hist(deg, 
     main = "Degree Distribution", 
     xlab = "Degree", 
     ylab = "Frequency", 
     col = "skyblue", 
     border = "black", 
     breaks = 10)

plot(foodweb, 
     vertex.size = deg * 3,  # Adjust the size based on the degree
     vertex.color = "lightblue", 
     edge.color = "gray", 
     vertex.label.color = "black", 
     main = "Food Web with Degree Centrality (Vertex Size)")

sorted_deg <- sort(deg, decreasing = TRUE)

# Print the top 10 vertices with the highest degree centrality
print(sorted_deg[1:10])

normalized_deg <- deg / max(deg)

# Print normalized degree centrality
print(normalized_deg)


degree_table <- data.frame(Vertex = names(deg), Degree = deg)

# Print the degree table
print(degree_table)
```

