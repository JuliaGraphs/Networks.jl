using Networks
using LightGraphs
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
    net = Network(g, 1:nv(g), Dict{Edge, Float64}())
    net.eprop[Edge(5,1)] = 2.3
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
