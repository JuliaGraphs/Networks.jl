module Networks
using LightGraphs
import LightGraphs: Graph, DiGraph, fadj
import Base.convert, Base.promote_rule

export AbstractNetwork, Network
abstract AbstractNetwork

"""Network{G,V,E}
Network is the core type for store Graphs with vertex and edge properties.
The vertex properites are of type V and the edge properties are of type E.
"""
type Network{G,V,E} <: AbstractNetwork
  graph::G
  vprop::AbstractVector{V}
  eprop::Dict{Edge,E}
end

import Base.==

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
