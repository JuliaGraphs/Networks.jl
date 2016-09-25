# Integration with LightGraphs package


# conversion to underlying Graph:
graph(net::Network) = net.graph

sort(g::Graph, e::Edge) = e[1] <= e[2] ? e : reverse(e)
sort(g::DiGraph, e::Edge) = e

function convert{T<:SimpleGraph, G,V,E,H}(::Type{T}, net::Network{G,V,E,H})
    if typeof(net.graph) <: T
        return net.graph
    else
        error("Cannot convert network $G to graphtype $T")
    end
end

# promotion_rule{T<:SimpleGraph}(::Type{T}, ::Type{Network}) = T
promote_rule{G<:SimpleGraph, V,E,H}(::Type{Network{G,V,E,H}}, ::Type{G}) = G

# this is how one could define methods in LightGraphs
# to make everything work for types that embed a graph
fadj(g::Any) = fadj(convert(SimpleGraph, g))
