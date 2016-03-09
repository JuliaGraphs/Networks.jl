# Networks

[![Build Status](https://travis-ci.org/JuliaGraphs/Networks.jl.svg?branch=master)](https://travis-ci.org/JuliaGraphs/Networks.jl)

Networks.jl is a Julia Package for supporting Graphs with vertex and edge properties.
This includes weighted graphs, labeled vertices, categories edges.
The idea is to support graphs through the Adjacency List storage format provided in the LightGraphs.Graph (undirected) and LightGraphs.DiGraph (directed) graph types.
Goals of this project are to be simple, performant, and flexible in that order.
This is similar to the LightGraphs.jl philosophy but with the understanding that applications of networks are much more diverse than a simple graph datastructure.
