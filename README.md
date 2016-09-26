# Networks

[![Build Status](https://travis-ci.org/JuliaGraphs/Networks.jl.svg?branch=master)](https://travis-ci.org/JuliaGraphs/Networks.jl)

Networks.jl is a Julia Package for supporting Graphs with vertex and edge properties.
This includes weighted graphs, labeled vertices, categories edges.
The idea is to support graphs through the Adjacency List storage format provided in the LightGraphs.Graph (undirected) and LightGraphs.DiGraph (directed) graph types.
This is achieved by encapsulation of the LightGraphs.Graph type. Goals of this project are to be simple, performant, and flexible in that order.
This is similar to the LightGraphs.jl philosophy but with the understanding that applications of networks are much more diverse than a simple graph datastructure.

The idea is that any Network can be converted into a graph by forgetting the properties.
Thus `convert(Graph, net::Network)` are defined for for both `Graph` and `DiGraph`.
If combined with default definitions of the graph functions such as `fadj` that do conversion before calling the "real"
 definition then one can use `Network` as a graph transparently.

For example: `fadj(g::Any) = fadj(convert(SimpleGraph, g))` allows one to call `fadj` on an arbitrary network and get
the forward adjacency list.

## Usage
The types `Net` and `DiNet` are the two ready-to-use network types, for undirected and directed networks respectively. They are able to store any number of graph/vertex/edge properties of any type. It is based on a dictionary of dictionaries
structures.

```julia
using Networks
using LightGraph
n = Net(10)
add_vertex!(n, :label="pino", :weight=2.1)
nv(n) == 11 # number of vertices

#vertex properties
getprop(n, 11, :label) == "pino"
setprop!(n, 2, :label="rose")

#edge properties
add_edge!(n, 1, 2, :width=10)
setprop!(n, Edge(1,2), :label="violet")
getprop(n, 1, 2, :width) == 10

ne(n) == 1 # number of edges

setprop!(n, :name="mynetwork")

# construct from LightGraphs graphs
n = Net(CompleteGraph(10, 10))
n = DiNet(DiGraph(10, 20)) # random graph with 10 vertices and 20 edges
```
If you are looking for a more specialized and eventually more performant data structure, take a look to the `(Di)Network` type.
