
"""
    `Network{V,E,H}`

`Network` is the core type for representing graphs with vertex and edge properties.
`G` is the type of the underlying graph; the vertex properties are of type `V`,
and the edge properties are of type `E`.
"""
type Network{V,E,H} <: AbstractNetwork
  graph::Graph
  vprops::Dict{Int, V}
  eprops::Dict{Edge, E}
  gprops::H
end

type DiNetwork{V,E,H} <: AbstractNetwork
  graph::DiGraph
  vprops::Dict{Int, V}
  eprops::Dict{Edge, E}
  gprops::H
end

typealias ComplexNetwork{V,E,H} Union{Network{V,E,H},DiNetwork{V,E,H}}

# convenience constructors for empty `Network`s with given types:
Network{V,E}(::Type{V}, ::Type{E}) = Network(Graph(), Dict{Int,V}(), Dict{Edge,E}(), Void())
Network{V}(::Type{V}) = Network(Graph(), Dict{Int,V}(), Dict{Edge,Void}(), Void())

Network{V,E}(g::Graph, ::Type{V}, ::Type{E}) = Network(g, Dict{Int,V}(), Dict{Edge,E}(), Void())
Network{V}(g::Graph, ::Type{V}) = Network(g, Dict{Int,V}(), Dict{Edge,Void}(), Void())
Network(g::Graph) = Network(g, Dict{Int,Void}(), Dict{Edge,Void}(), Void())

DiNetwork{V,E}(::Type{V}, ::Type{E}) = DiNetwork(DiGraph(), Dict{Int,V}(), Dict{Edge,E}(), Void)
DiNetwork{V}(::Type{V}) = DiNetwork(DiGraph(), Dict{Int,V}(), Dict{Edge,Void}(), Void)

DiNetwork{V,E}(g::DiGraph, ::Type{V}, ::Type{E}) = DiNetwork(g, Dict{Int,V}(), Dict{Edge,E}(), Void)
DiNetwork{V}(g::DiGraph, ::Type{V}) = DiNetwork(g, Dict{Int,V}(), Dict{Edge,Void}(), Void)

#### core functions ###########
function add_vertex!(g::ComplexNetwork)
    add_vertex!(g.graph)
    return nv(g)
end

function add_vertex!{V,E,H}(g::ComplexNetwork{V,E,H}, vprop::V)
    add_vertex!(g.graph)
    n = nv(g)
    g.vprops[n] = vprop
    return n
end

function add_vertices!{V,E,H}(g::ComplexNetwork{V,E,H}, vprops::Vector{V})
    for vprop in vprops
        add_vertex!(g, vprop)
    end
end

function add_edge!{V,E,H}(g::ComplexNetwork{V,E,H}, e::Edge, eprop::E)
    e = sort(g.graph, e)
    g.eprops[e] = eprop
    return add_edge!(g.graph, e)
end

add_edge!(net::ComplexNetwork, i::Int, j::Int) = add_edge!(net.graph, i, j)
add_edge!(net::ComplexNetwork, e::Edge) = add_edge!(net.graph, e)
add_edge!{E}(net::ComplexNetwork, i::Int, j::Int, eprop::E) =
                                    add_edge!(net.graph, Edge(i,j), eprop)


function setprop!{V,E,H}(net::ComplexNetwork{V,E,H}, i::Int, vprop::V)
    net.vprops[i] = vprop
end


getprop(net::ComplexNetwork, i::Int) = net.vprops[i]
getprop(net::ComplexNetwork, e::Edge) = (e = sort(net.graph, e); net.eprops[e])

function setprop!{V,E,H}(net::ComplexNetwork{V,E,H}, e::Edge, eprop::E)
    e = sort(net.graph, e)
    net.eprops[e] = eprop
end

==(n::ComplexNetwork, m::ComplexNetwork) = (n.graph == m.graph) && (n.vprops == m.vprops) && (n.eprops == m.eprops)

# Integration with LightGraphs package


# conversion to underlying Graph:
graph(net::ComplexNetwork) = net.graph

sort(g::Graph, e::Edge) = e[1] <= e[2] ? e : reverse(e)
sort(g::DiGraph, e::Edge) = e

function convert{T<:SimpleGraph, V,E,H}(::Type{T}, net::ComplexNetwork{V,E,H})
    if typeof(net.graph) <: T
        return net.graph
    else
        error("Cannot convert network $G to graphtype $T")
    end
end

# promotion_rule{T<:SimpleGraph}(::Type{T}, ::Type{Network}) = T
promote_rule{Graph,V,E,H}(::Type{Network{V,E,H}}, ::Type{Graph}) = Graph
promote_rule{DiGraph,V,E,H}(::Type{DiNetwork{V,E,H}}, ::Type{DiGraph}) = DiGraph
