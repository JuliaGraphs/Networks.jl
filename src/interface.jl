# Here we should define a minimal interface
# One requirement could be the presence of
# a `graph` member, of type LightGraphs.Graph or DiGraph
abstract AbstractNetwork

nv(net::AbstractNetwork) = nv(net.graph)
ne(net::AbstractNetwork) = ne(net.graph)

# this is how one could define methods in LightGraphs
# to make everything work for types that embed a graph
fadj(g::Any) = fadj(convert(SimpleGraph, g))
