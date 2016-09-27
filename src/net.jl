typealias DSA Dict{Symbol,Any}
typealias EDSA Dict{Edge,DSA}
typealias VDSA Dict{Int,DSA}

"""
An handy specialization of a generic Network.
"""
typealias Net Network{DSA, DSA, DSA}

"""
An handy specialization of a generic DiNetwork.
"""
typealias DiNet DiNetwork{DSA, DSA, DSA}

typealias UNet Union{Net, DiNet}

Net(n::Int=0) = Net(Graph(n), VDSA(), EDSA(), DSA())
DiNet(n::Int=0) = DiNet(DiGraph(n), VDSA(), EDSA(), DSA())

Net(g::Graph) = Net(g, VDSA(), EDSA(), DSA())
DiNet(g::DiGraph) = DiNet(g, VDSA(), EDSA(), DSA())


## properties
getprop(n::UNet, p::Symbol) = n.gprops[p]
getprop(n::UNet, i::Int, p::Symbol) = n.vprops[i][p]
function getprop(n::UNet, e::Edge, p::Symbol)
    e = sort(n, e)
    n.eprops[e][p]
end
getprop(n::UNet, i::Int, j::Int, p::Symbol) = getprop(n, Edge(i,j), p)

hasprop(n::UNet, p::Symbol) = haskey(n.gprops, p)
hasprop(n::UNet, i::Int, p::Symbol) = haskey(n.vprops[i], p)
function hasprop(n::UNet, e::Edge, p::Symbol)
    e = sort(n, e)
    haskey(n.eprops[e], p)
end
hasprop(n::UNet, i::Int, j::Int, p::Symbol) = hasprop(n, Edge(i,j), p)

function setprop!(n::UNet, i::Int; kws...)
    props = get(n.vprops, i, DSA())
    for (name,value) in kws
        props[name] = value
    end
    n.vprops[i] = props
end

function setprop!(n::UNet, e::Edge; kws...)
    e = sort(n, e)
    props = get(n.eprops, e, DSA())
    for (name,value) in kws
        props[name] = value
    end
    n.eprops[e] = props
end

setprop!(n::UNet, i::Int, j::Int; kws...) = setprop!(n, Edge(i,j); kws...)

function setprop!(n::UNet; kws...)
    props = n.gprops
    for (name,value) in kws
        props[name] = value
    end
end

rmprop!(n::UNet, p::Symbol) = delete!(n.gprops, p)
rmprop!(n::UNet, i::Int, p::Symbol) = delete!(n.vprops[i], p)
rmprop!(n::UNet, i::Int, j::Int, p::Symbol) = rmprop!(n, Edge(i,j), p)
function rmprop!(n::UNet, e::Edge, p::Symbol)
    e = sort(n, e)
    delete!(n.eprops[e], p)
end

## core methods
"""
    add_vertex!(net; kws...)

Add vertex and its properties.
## Usage:
add_vertex!(g)
add_vertex!(g, :label="ciao", :size=2.0)
"""
function add_vertex!(n::UNet; kws...)
    add_vertex!(n.graph)
    i = nv(n)
    n.vprops[i] = DSA(kws)
    # props = DSA()
    # for (name, value) in kws
    #     props[name] = value
    # end
    # n.vprops[i] = props
    return i
end

"""
    add_edge!(net, e::Edge; kws...)
    add_edge!(net, i::Int, j::Int; kws...)

Add edge and its properties

## Usage:
add_edge!(g, 1, 2)
add_vertex!(g, Edge(2, 3), :label="ciao", :size=2.0)
"""
function add_edge!(g::UNet, e::Edge; kws...)
    e = sort(g, e)

    g.eprops[e] = DSA(kws)
    return add_edge!(g.graph, e)
end
