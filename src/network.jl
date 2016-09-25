
"""
    `Network{G,V,E}`

`Network` is the core type for representing graphs with vertex and edge properties.
`G` is the type of the underlying graph; the vertex properties are of type `V`,
and the edge properties are of type `E`.
"""
type Network{G<:SimpleGraph,V,E,H} <: AbstractNetwork
  graph::G
  vprops::Dict{Int, V}
  eprops::Dict{Edge,E}
  gprops::H
end


# convenience constructors for empty `Network`s with given types:
Network{G,V,E}(::Type{G}, ::Type{V}, ::Type{E}) = Network(G(), Dict{Int,V}(), Dict{Edge,E}(), Void)
Network{G,V}(::Type{G}, ::Type{V}) = Network(G(), Dict{Int,V}(), Dict{Edge,Void}(), Void)

Network{G,V,E}(g::G, ::Type{V}, ::Type{E}) = Network(g, Dict{Int,V}(), Dict{Edge,E}(), Void)
Network{G,V}(g::G, ::Type{V}) = Network(g, Dict{Int,V}(), Dict{Edge,Void}(), Void)

function add_vertex!(g::Network)
    add_vertex!(g.graph)
    return nv(g)
end

function add_vertex!{G,V,E,H}(g::Network{G,V,E,H}, vprop::V)
    add_vertex!(g.graph)
    n = nv(g)
    g.vprops[n] = vprop
    return n
end

function add_vertices!{G,V,E,H}(g::Network{G,V,E,H}, vprops::Vector{V})
    for vprop in vprops
        add_vertex!(g, vprop)
    end
end

function add_edge!{G,V,E,H}(g::Network{G,V,E,H}, e::Edge, eprop::E)
    e = sort(g.graph, e)
    g.eprops[e] = eprop
    return add_edge!(g.graph, e)
end

add_edge!{G,V,E,H}(net::Network{G,V,E,H}, i::Int, j::Int) = add_edge!(net.graph, i, j)
add_edge!{G,V,E,H}(net::Network{G,V,E,H}, e::Edge) = add_edge!(net.graph, e)
add_edge!{G,V,E,H}(net::Network{G,V,E,H}, i::Int, j::Int, eprop::E) =
                                    add_edge!(net.graph, Edge(i,j), eprop)


function set_prop!{G,V,E,H}(net::Network{G,V,E,H}, i::Int, vprop::V)
    net.vprops[i] = vprop
end


get_prop(net::Network, i::Int) = net.vprops[i]
get_prop(net::Network, e::Edge) = (e = sort(net.graph, e); net.eprops[e])

function set_prop!{G,V,E,H}(net::Network{G,V,E,H}, e::Edge, eprop::E)
    e = sort(net.graph, e)
    net.eprops[e] = eprop
end

==(n::Network, m::Network) = (n.graph == m.graph) && (n.vprops == m.vprops) && (n.eprops == m.eprops)
