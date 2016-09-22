module Networks

import LightGraphs: Graph, DiGraph, SimpleGraph, Edge,
        fadj,
        add_vertex!, add_vertices!, add_edge!

import Base.convert, Base.promote_rule
import Base.==

export AbstractNetwork, Network
abstract AbstractNetwork

"""
    `Network{G,V,E}`

`Network` is the core type for representing graphs with vertex and edge properties.
`G` is the type of the underlying graph; the vertex properties are of type `V`,
and the edge properties are of type `E`.
"""
type Network{G,V,E} <: AbstractNetwork
  graph::G
  vprops::Vector{V}
  eprops::Dict{Edge,E}
end

# convenience constructors for empty `Network`s with given types:
Network{G,V,E}(::Type{G}, ::Type{V}, ::Type{E}) = Network(G(), V[], Dict{Edge,E}())
Network{G,V}(::Type{G}, ::Type{V}) = Network(G(), V[], Dict{Edge,Void}())


function add_vertex!{G,V,E}(g::Network{G,V,E}, vertex_info::V)
    n = add_vertex!(g.graph)
    push!(g.vprops, vertex_info)

    return n
end

function add_vertices!{G,V,E}(g::Network{G,V,E}, vertex_info::Vector{V})
    for vertex in vertex_info
        add_vertex!(g.graph)
        push!(g.vprops, vertex)
    end
end

function add_edge!{G,V,E}(g::Network{G,V,E}, i, j, edge_info::E)
    e = add_edge!(g.graph, i, j)
    (g.eprops)[e] = edge_info
    return e
end

add_edge!{G,V,E}(g::Network{G,V,E}, i, j) = add_edge!(g.graph, i, j)


==(n::Network, m::Network) = (n.graph == m.graph) && (n.vprops == m.vprops) && (n.eprops == m.eprops)

# conversion to underlying Graph:

Graph(net::Network) = net.graph

function convert{T<:SimpleGraph, G,V,E}(::Type{T}, net::Network{G,V,E})
    if typeof(net.graph) <: T
        return net.graph
    else
        error("Cannot convert network $G to graphtype $T")
    end
end

# promotion_rule{T<:SimpleGraph}(::Type{T}, ::Type{Network}) = T
promote_rule{T<:SimpleGraph, V, E}(::Type{Network{T,V,E}}, ::Type{T}) = T

# this is how one could define methods in LightGraphs
# to make everything work for types that embed a graph
fadj(g::Any) = fadj(convert(SimpleGraph, g))
end
