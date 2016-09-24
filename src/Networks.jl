module Networks

using LightGraphs
import LightGraphs: Graph, DiGraph, SimpleGraph, Edge,
        fadj, nv, ne,
        add_vertex!, add_vertices!, add_edge!

import Base.convert, Base.promote_rule
import Base.==

export AbstractNetwork, Network

export set_vprop!, set_eprop!
abstract AbstractNetwork

"""
    `Network{G,V,E}`

`Network` is the core type for representing graphs with vertex and edge properties.
`G` is the type of the underlying graph; the vertex properties are of type `V`,
and the edge properties are of type `E`.
"""
type Network{G<:SimpleGraph,V,E} <: AbstractNetwork
  graph::G
  vprops::Dict{Int, V}
  eprops::Dict{Edge,E}
end


# convenience constructors for empty `Network`s with given types:
Network{G,V,E}(::Type{G}, ::Type{V}, ::Type{E}) = Network(G(), Dict{Int,V}(), Dict{Edge,E}())
Network{G,V}(::Type{G}, ::Type{V}) = Network(G(), Dict{Int,V}(), Dict{Edge,Void}())

Network{G,V,E}(g::G, ::Type{V}, ::Type{E}) = Network(g, Dict{Int,V}(), Dict{Edge,E}())
Network{G,V}(g::G, ::Type{V}) = Network(g, Dict{Int,V}(), Dict{Edge,Void}())



nv(g::AbstractNetwork) = nv(g.graph)
ne(g::AbstractNetwork) = ne(g.graph)


function add_vertex!(g::Network)
    add_vertex!(g.graph)
    return nv(g)
end

function add_vertex!{G,V,E}(g::Network{G,V,E}, vprop::V)
    add_vertex!(g.graph)
    n = nv(g)
    g.vprops[n] = vprop
    return n
end

function add_vertices!{G,V,E}(g::Network{G,V,E}, vprops::Vector{V})
    for vprop in vprops
        add_vertex!(g, vprop)
    end
end

sort(g::Graph, e::Edge) = e[1] <= e[2] ? e : reverse(e)
sort(g::DiGraph, e::Edge) = e


function add_edge!{G,V,E}(g::Network{G,V,E}, e::Edge, eprop::E)
    e = sort(g.graph, e)
    g.eprops[e] = eprop
    return add_edge!(g.graph, e)
end

add_edge!{G,V,E}(net::Network{G,V,E}, i::Int, j::Int) = add_edge!(net.graph, i, j)
add_edge!{G,V,E}(net::Network{G,V,E}, e::Edge) = add_edge!(net.graph, e)
add_edge!{G,V,E}(net::Network{G,V,E}, i::Int, j::Int, eprop::E) =
                                    add_edge!(net.graph, Edge(i,j), eprop)


function set_vprop!{G,V,E}(net::Network{G,V,E}, i::Int, vprop::V)
    net.vprops[i] = vprop
end

function set_eprop!{G,V,E}(net::Network{G,V,E}, e::Edge, vprop::E)
    e = sort(g.graph, e)
    net.eprops[e] = eprop
end

==(n::Network, m::Network) = (n.graph == m.graph) && (n.vprops == m.vprops) && (n.eprops == m.eprops)

# conversion to underlying Graph:

graph(net::Network) = net.graph

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
