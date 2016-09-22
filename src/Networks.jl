module Networks
using LightGraphs
import LightGraphs: Graph, DiGraph, fadj,
        add_vertex!, add_vertices!, add_edge!
import Base.convert, Base.promote_rule

export AbstractNetwork, Network
abstract AbstractNetwork

"""Network{G,V,E}
Network is the core type for store Graphs with vertex and edge properties.
The vertex properites are of type V and the edge properties are of type E.
"""
type Network{G,V,E} <: AbstractNetwork
  graph::G
  vprop::Vector{V}
  eprop::Dict{Edge,E}
end

Network{G,V,E}(::Type{G}, ::Type{V}, ::Type{E}) = Network(G(), V[], Dict{Edge,E}())
Network{G,V}(::Type{G}, ::Type{V}) = Network(G(), V[], Dict{Edge,Void}())



import Base.==

function add_vertex!{G,V,E}(g::Network{G,V,E}, vertex_info::V)
    n = add_vertex!(g.graph)
    push!(g.vprop, vertex_info)

    return n
end

function add_vertices!{G,V,E}(g::Network{G,V,E}, vertex_info::Vector{V})
    for vertex in vertex_info
        add_vertex!(g.graph)
        push!(g.vprop, vertex)
    end
end

function add_edge!{G,V,E}(g::Network{G,V,E}, i, j, edge_info::E)
    e = add_edge!(g.graph, i, j)
    (g.eprop)[e] = edge_info
    return e
end

add_edge!{G,V,E}(g::Network{G,V,E}, i, j) = add_edge!(g.graph, i, j)



==(n::Network, m::Network) = (n.graph == m.graph) && (n.vprop == m.vprop) && (n.eprop == m.eprop)

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
