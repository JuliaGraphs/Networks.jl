module Networks
using LightGraphs

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

import Base.==

==(n::Network, m::Network) = (n.graph == m.graph) && (n.vprop == m.vprop) && (n.eprop == m.eprop)

end # module
