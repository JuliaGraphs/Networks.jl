include("../src/Networks.jl")
using LightGraphs
using Networks
using Base.Test

# write your own tests here
@test 1 == 1

g = Graph(5)
dg = DiGraph(5)
function prepgraph(g)
    add_edge!(g, 1,2)
    add_edge!(g, 2,3)
    add_edge!(g, 3,4)
    add_edge!(g, 4,5)
    add_edge!(g, 5,1)
    net = Network(g, Dict{Int, Float64}(), Dict{Edge, Float64}())
    net.eprops[Edge(5, 1)] = 2.3
    return net
end

net = prepgraph(g)

@test convert(Graph, net) == g
@test Graph(net) == g
@test fadj(net) == fadj(g)
@test_throws ErrorException convert(DiGraph, net)

dnet = prepgraph(dg)
@test convert(DiGraph, dnet) == dg
@test fadj(dnet) == fadj(dg)
@test_throws ErrorException convert(Graph, dnet)

# test that least upper bound type
# of a network and a graph is the compatible graph type
@test promote_rule(Network{Graph,Int,Int}, Graph) == Graph
@test promote_rule(Network{DiGraph,Int,Int}, DiGraph) == DiGraph
@test promote(dnet, dg) == (dg,dg)
@test promote(net, g) == (g,g)

# if the graph types are incompatible do not promote!
@test promote_rule(Network{Graph,Int,Int}, DiGraph) == Union{}
@test promote(net, dg) == (net, dg)
@test promote(dnet, g) == (dnet, g)


g = Graph()
add_vertex!(g)
add_vertex!(g)
add_edge!(g, 1, 2)

net = Network(Graph, String)
add_vertex!(net, "a")
add_vertex!(net, "b")
add_edge!(net, 1, 2)

@test net.graph == g
@test net.vprops[1] == "a"
@test net.vprops[2] == "b"

@test typeof(net.vprops) <: Dict
@test typeof(net.eprops) <: Dict

@test nv(net) == nv(net.graph)
@test ne(net) == ne(net.graph)

net2 = Network(g, String)
set_vprop!(net2, 1, "a")
set_vprop!(net2, 2, "b")
@test net2 == net

net3 = Network(g, Void, String)
@test nv(g) == 2
add_vertex!(net3)
@test nv(g) == 3
@test nv(net3) == 3

set_eprop!(net3, Edge(2,1), "ciao")
@test net3.eprop[Edge(1,2)] == "ciao"
