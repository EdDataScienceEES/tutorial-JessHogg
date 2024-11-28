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

#5 -# visulise Network 
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









### Analysis and Manipulation of graphs produced using igraph ----
## Highlighting communities 
comm <- cluster_edge_betweenness(foodweb)
print(comm)
comm_2 <- cluster_louvain(network)
plot(comm_2, network)



## shortest path 
is_connected(network)
components_info <- components(network)
largest_component <- induced_subgraph(network, components_info$membership == which.max(components_info$csize))
plot(largest_component)
path <- shortest_paths(largest_component, from = 1, to = 5)
print(path$vpath[1:5])
shortest_path_vertices <- path$vpath[[1]]
shortest_path_edges <- E(largest_component)[.from(shortest_path_vertices) %--% .to(shortest_path_vertices)]
plot(largest_component, 
     vertex.size = 15, 
     vertex.label.cex = 1.5, 
     edge.color = ifelse(E(largest_component) %in% shortest_path_edges, "red", "gray"),  # Highlight path in red
     main = "Graph with Shortest Path Highlighted")




## degree 
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

### Visualisation ----
## Customising graphs 
plot(foodweb)
custom <- plot(foodweb,
                vertex.size = 20,
                vertex.color = "orange",
                vertex.label.color = "black",
                vertex.label.cex = 1.5,
                edge.arrow.size = 0.5,
                main = "Customisied graph",
                layout = layout.circle(foodweb))

# describe what these are 

## Creating interactive graphs ( using visNetwork or plotly with igraph)
install.packages("visNetwork")
library(visNetwork)
Edges_1 <- read.csv("edges data.csv")
Nodes_1 <- read.csv ("tutorial_data.csv")

# Rename columns for visNetwork compatibility
colnames(Edges_1) <- c("from", "to", "weight")
colnames(Nodes_1) <- c("id", "label", "trophic_level", "community")

# Assign colors to nodes based on the community
Nodes_1$color <- ifelse(Nodes_1$community == "Aquatic", "blue", 
                           ifelse(Nodes_1$community == "Marine", "green", 
                                  ifelse(Nodes_1$community == "Terrestrial", "brown", "gray")))

# Create the interactive graph

Interactive <- visNetwork(nodes = Nodes_1, edges = Edges_1)%>%
  visNodes(size = 25, shape = "dot") %>%
  visEdges(arrows = "to", width = 1) %>%
  visIgraphLayout() %>%
  visLayout(randomSeed = 123) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)





htmlwidgets::saveWidget(Interactive, "network_graph.html")
browseURL("network_graph.html")








                 