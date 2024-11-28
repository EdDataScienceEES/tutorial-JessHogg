# Introduction to Visualising Networks Using igraph
Created by Jess hogg in Nov 2024
## Tutorial Aims: 
1. To have an overall understanding of the package igraph
2. To become confident with creating, manipulating and analysing graphs  
3. To learn effective visualisation skills 
   
## Tutorial Steps: 
#### <a href="#1"> 1. Introduction to igraph and Basics</a>
#### <a href="#2"> 2. Analysis and Manipulation</a>
#### <a href="#3"> 3. Visualisation</a>

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
1. Using ```rgraph_from_data_frame```
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
Community Detection:
igraph allows you to detected different communities in networks.In network analysis, a community is a subset of nodes that are more densely connected to each other than to the other communities in the same graph. Community detection is the method used to locate these communities based on the networks structure. In a biological network identifying communites can provide insight into substructures such as ecologialc niches in food webs.

Two different methods of detection: 
- Edge betweenness method: ``` cluster_edge_betweenness ``` detects communites by repeated removing edges with the highest betweenness centrality which are edges that connect differnent clusters. This process continues until the graph is divided into clear communities. This methods is better used to identiy communities in smaller networks than larger networks due to the repeated calculation of highest betweeness centraility. 
- Louvain method: ``` cluster_louvain ```  is faster and more effective at detetcing communites in larger networks becasue it measures the density of connections within communities compared to between them. 

  
```r
comm <- cluster_edge_betweenness(foodweb) # detecting communites using Edges betweeness method
print(comm) # print community structure details
comm_2 <- cluster_louvain(network) # detecting communites using Louvain methods 
plot(comm_2, network) # visulising louvain communites on network
```
Outputs: 
- ```print(comm)``` shows the number of communites and what communties each node has been assigned to
- The graph produced by ```plot(comm_2, network) ``` highlights nodes that belong to the same communites, each community is shown by different colors. This helps to visulise the communites present and how/ if they interact with each other

<img width="278" alt="image" src="https://github.com/user-attachments/assets/e00fe8bf-6fd5-4b54-beb9-4b197c06066c">

Exercise: 
- Try detecting communities using other methods of detection available in igraph (e.g., cluster_walktrap or cluster_fast_greedy). How do the results compare? What are the noticiable differences between graphs? 

Shortest path:

The ```shortest_path``` calculates the lenght of all the shortest paths from or to the vertices in a network. To do this it uses the minimum number of edges that are essential for the connection between two vertices. 

First lets make sure that the graph is prepared for analysis by running ```is_connected() ```. You will notice that the output says FALSE this means that the graph is not fully connected therefore if we tried to use ```shortest_path ``` we would get an error message like this: 
```Warning message:
In shortest_paths(network, from = V(network), to = V(network)) :
  At vendor/cigraph/src/paths/unweighted.c:444 : Couldn't reach some vertices.```
Therefore we use the components() to identify connections and will select for the largest one. 

```r
is_connected(network) # checking if graph is fully connected (preperation for analysis) 
components_info <- components(network) # identify connections 
largest_component <- induced_subgraph(network, components_info$membership == which.max(components_info$csize)) # only include the largest connected components from the network
plot(largest_component) # visualise only largest components 
path <- shortest_paths(largest_component, from = 1, to = 5) # calculate the shortest path 
print(path$vpath[1:5]) # print the first 5 paths 
shortest_path_vertices <- path$vpath[[1]] # extracting vertices 
shortest_path_edges <- E(largest_component)[.from(shortest_path_vertices) %--% .to(shortest_path_vertices)] # extracting edges
plot(largest_component, 
     vertex.size = 15,                         
     vertex.color = ifelse(V(largest_component) %in% shortest_path_vertices, "green", "lightblue"), 
     vertex.label.cex = 1.2,                    
     edge.color = ifelse(E(largest_component) %in% shortest_path_edges, "red", "gray"), 
     edge.arrow.size = 0.5,                     
     main = "Shortest Path in the Largest Component") 
```

<img width="280" alt="image" src="https://github.com/user-attachments/assets/aecb5b9b-ded6-4052-8a89-b5748ffbac5c">

Graph shows the shortest path which is highlighted with red egdes (lines) and green vertices (circles). 

Exercise: 
- Try and find the shortest path when considering weight. What happens? Any changes?

Degree Centrality

Is a measurement in network analysis that quantifies the number of connections a vertex has. It is calculated by counting the edges connected to a vertex. A higher value suggest that the vertex play a more important role in the network as it has more direct relationships with other vertices indication a greater influence. 

```r
# Calculate degree centrality
deg <- degree(foodweb)
print(deg)

# plot a histogram of degree distrubtion 
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

# Print the top 10 vertices with the highest degree centrality
sorted_deg <- sort(deg, decreasing = TRUE)
print(sorted_deg[1:10])

# Print normalized degree centrality
normalized_deg <- deg / max(deg)
print(normalized_deg)

degree_table <- data.frame(Vertex = names(deg), Degree = deg)

# Print the degree table
print(degree_table)
```
The histogram: Shows that as the number of interactions (degree) increases along the x axis, the number of species (frequency) is decreasing when looking at the y axis. Therefore the majority of species have low connectiveity due to the reduced interactions. 

<img width="284" alt="image" src="https://github.com/user-attachments/assets/35cc1a92-cca4-4ede-9152-624380786fda">

The plot: the degree Centrality is demonstrated in the network by the size of the vertices, larger vertex = higher degree centrality, smaller vertex = lower degree centrality. 

<img width="272" alt="image" src="https://github.com/user-attachments/assets/02fdf84c-2072-4005-87b1-f04a8d02ceee">

It is good practice to identify the top 10 vertices with the highest degree centrality as they would be the species that play a vital role wihtin the network forming its structure and influencing stability. Therefore with this information you can start to research why this might be the case for your chosen ecological interactions.

Creating a data table provides the specifc values that have been visualised in the plot which can then be used to further analyse relationships e.g. statistial tests and models(GLM). 

Anazing! You are now over halfway through this tutorial. Lets move onto the final section. 

<a name="3"></a>
### Visualisation
Customising graphs
There are lots of function that allow you to customise the look of plot 


| **Function**          | **Description**                                                                                         |
|------------------------|---------------------------------------------------------------------------------------------------------|
| `vertex.size = `       |    Sets a fixed size of the vertices. Larger values = larger vertices          |
| `vertex.color =`         | Allows you to choose the colour of the vertices. Can be a single colour of can customise colours for vertex (communities)                                                                                  |
| `vertex.label.color =`   | Specifies the colour of the labels shown on the vertices                    |
| `vertex.label.cex =`     | Changes the size of the labels on the vertices.                                     |
| `edge.arrow.size =`      | Used to adjust the size of the arrows of directed edges  |
| `main`                 |Name of the title which gets displayed at the top of the graph                          |
| `layout`               |  Defines the layout of the graph. Here are some examples:  layout.circle,   layout_with_fr , layout_with_kk         |
|Function	|Description|
---------------------------

Example: 
```r
plot(foodweb)
custom <- plot(foodweb,
                vertex.size = 20,
                vertex.color = "orange",
                vertex.label.color = "black",
                vertex.label.cex = 1.5,
                edge.arrow.size = 0.5,
                main = "Customisied graph",
                layout = layout.circle(foodweb))
```
Creating Interactive graphs 

An interactive graph is a more advanced visualisation and more effective when it comes to larger datasets. Interactive graphs allow you to zoom, pan and focus on specific interactions within a network resulting in locailised interactions being easier to visualise. 
First we neeed to download a package that can create and interactive graph with the package igraph 
```r
install.packages("visNetwork") # install new package
library(visNetwork) # load package
Edges_1 <- read.csv("edges data.csv") #load data 
Nodes_1 <- read.csv ("tutorial_data.csv")# load data 

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

Interactive

htmlwidgets::saveWidget(Interactive, "network_graph.html") # save a copy of a link to graph 
browseURL("network_graph.html") # open the link in web browser 
```
### Interactive Graph
[View the Interactive Graph](https://eddatascienceees.github.io/tutorial-JessHogg/Graphs/network_graph.html)

Congratulations you have sucessfully completed the tutorial! You now have all the techniques and information you need to start incorporating igraph into your on data science projects. If you would like to ask any questions (e.g. about the exercise) please contact me at s2421495@ed.ac.uk. Goodluck!
