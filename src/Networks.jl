module Networks
using LightGraphs

import LightGraphs: Graph, DiGraph, SimpleGraph, Edge,
        fadj, nv, ne,
        add_vertex!, add_vertices!, add_edge!

import Base: convert, promote_rule, ==

export AbstractNetwork, Network

export set_prop!, get_prop

export graph

include("interface.jl")
include("network.jl")
include("lightgraphs.jl")


end #module
