# Networks

[![Build Status](https://travis-ci.org/JuliaGraphs/Networks.jl.svg?branch=master)](https://travis-ci.org/JuliaGraphs/Networks.jl)

Networks.jl is a Julia Package for supporting Graphs with vertex and edge properties.
This includes weighted graphs, labeled vertices, categories edges.
The idea is to support graphs through the Adjacency List storage format provided in the LightGraphs.Graph (undirected) and LightGraphs.DiGraph (directed) graph types.
Goals of this project are to be simple, performant, and flexible in that order.
This is similar to the LightGraphs.jl philosophy but with the understanding that applications of networks are much more diverse than a simple graph datastructure.

For now the Package is bare with just the type:

```julia
type Network{G,V,E}
  graph::G
  vprop::Vector{V}
  eprop::Dict{Edge, E}
end
```

The idea is that any Network can be converted into a graph by forgetting the properties.
Thus `convert(Graph, net::Network)` are defined for for both `Graph` and `DiGraph`.
If combined with default definitions of the graph functions such as `fadj` that do conversion before calling the "real"
 definition then one can use `Network` as a graph transparently.

For example: `fadj(g::Any) = fadj(convert(SimpleGraph, g))` allows one to call `fadj` on an arbitrary network and get
the forward adjacency list.
