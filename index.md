### Introduction to visualising networks using igraph
## Tutorial Aims: 
1. To have an overall understanding of the package igraph
2. To learn how to create, manipulate and analyse graphs  
3. To product effective and informative graphs  ... To become confident 
   
### Tutorial Steps: 
#### <a href="#1"> 1. Introduction to igraph and Basics</a>
#### <a href="#2"> 2. Analysis and Manipultion</a>
#### <a href="#3"> 3. Visulisation</a>

<a name="1"></a>
## 1. Introduction to igraph and Basics 

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

