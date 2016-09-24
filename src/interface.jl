# Here we should define a minimal interface
# One requirement could be the presence of
# a `graph` member, of type LightGraphs.Graph or DiGraph
abstract AbstractNetwork

nv(net::AbstractNetwork) = nv(net.graph)
ne(net::AbstractNetwork) = ne(net.graph)
