module Networks
using LightGraphs

import LightGraphs: Graph, DiGraph, SimpleGraph, Edge,
        fadj, nv, ne, edges,
        add_vertex!, add_vertices!, add_edge!, rem_edge!, rem_vertex!

import Base: convert, promote_rule, ==

export AbstractNetwork, Network, DiNetwork, ComplexNetworkNet
export Net, DiNet, UNet

export setprop!, getprop, rmprop!, hasprop

export graph

#temporary
export DSA

include("interface.jl")
include("network.jl")
include("net.jl")


end #module
