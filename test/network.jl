
g = Graph(5)
dg = DiGraph(5)
function prepgraph(g)
    add_edge!(g, 1,2)
    add_edge!(g, 2,3)
    add_edge!(g, 3,4)
    add_edge!(g, 4,5)
    add_edge!(g, 5,1)
    if is_directed(g)
        net = DiNetwork(g, Dict{Int, Float64}(), Dict{Edge, Float64}(), Void())
    else
        net = Network(g, Dict{Int, Float64}(), Dict{Edge, Float64}(), Void())
    end
    net.eprops[Edge(5, 1)] = 2.3
    return net
end

net = prepgraph(g)

@test convert(Graph, net) == g
@test Graph(net) == g
@test fadj(net) == fadj(g)
# @test_throws UndefVarException convert(DiGraph, net)

dnet = prepgraph(dg)
@test convert(DiGraph, dnet) == dg
@test fadj(dnet) == fadj(dg)
# @test_throws UndefVarException convert(Graph, dnet)

# test that least upper bound type
# of a network and a graph is the compatible graph type
@test promote_rule(Network{Int,Int,Void}, Graph) == Graph
@test promote_rule(DiNetwork{Int,Int,Void}, DiGraph) == DiGraph
@test promote(dnet, dg) == (dg,dg)
@test promote(net, g) == (g,g)

# if the graph types are incompatible do not promote!
# @test promote_rule(Network{Int,Int,Void}, DiGraph) == Union{}
# @test promote(net, dg) == (net, dg)
# @test promote(dnet, g) == (dnet, g)


g = Graph()
add_vertex!(g)
add_vertex!(g)
add_edge!(g, 1, 2)

net = Network(String)
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
setprop!(net2, 1, "a")
setprop!(net2, 2, "b")
@test net2 == net
@test getprop(net2, 1) == "a"
@test getprop(net2, 2) == "b"

net3 = Network(g, Void, String)
@test nv(g) == 2
add_vertex!(net3)
@test nv(g) == 3
@test nv(net3) == 3

setprop!(net3, Edge(2,1), "ciao")
@test net3.eprops[Edge(1,2)] == "ciao"

@test getprop(net3, Edge(1,2)) == "ciao"
@test getprop(net3, Edge(2,1)) == "ciao"

@test Graph(net3) == net3.graph
@test graph(net3) == net3.graph