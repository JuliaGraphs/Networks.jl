g = WheelGraph(10)
n10 = Net(WheelGraph(10))
@test edges(n10) == edges(g)
@test graph(n10) == g

g = WheelDiGraph(10)
n10 = DiNet(WheelDiGraph(10))
@test edges(n10) == edges(g)
@test graph(n10) == g

n = Net(10)
@test nv(n) == 10
@test ne(n) == 0
dn = DiNet(10)
@test nv(dn) == 10
@test ne(dn) == 0

@test sort(dn, Edge(2,1)) == Edge(2,1)
@test sort(n, Edge(2,1)) == Edge(1,2)

@test_throws ErrorException convert(Graph, dn)
@test_throws ErrorException convert(DiGraph, n)


g10 = CompleteGraph(10)
net = Net(CompleteGraph(10))
@test convert(Graph, net) == graph(net)
@test Graph(net) == graph(net)
@test fadj(net) == fadj(g10)
@test promote(net, g10) == (g10,g10)
# @test_throws UndefVarException convert(DiGraph, net)

g10 = DiGraph(10,10)
dnet = DiNet(g10)
@test convert(DiGraph, dnet) == g10
@test fadj(dnet) == fadj(g10)
# @test_throws UndefVarException convert(Graph, dnet)

# test that least upper bound type
# of a network and a graph is the compatible graph type
@test promote_rule(Network{Int,Int,Void}, Graph) == Graph
@test promote_rule(DiNetwork{Int,Int,Void}, DiGraph) == DiGraph
@test promote(dnet, g10) == (g10,g10)

# if the graph types are incompatible do not promote!
# @test promote_rule(Network{Int,Int,Void}, DiGraph) == Union{}
# @test promote(net, dg) == (net, dg)
# @test promote(dnet, g) == (dnet, g)
