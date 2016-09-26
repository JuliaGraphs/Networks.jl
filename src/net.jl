typealias DSA Dict{Symbol,Any}
typealias EDSA Dict{Edge,DSA}
typealias VDSA Dict{Int,DSA}

typealias Net Network{DSA, DSA, DSA}
typealias DiNet DiNetwork{DSA, DSA, DSA}

typealias UNet Union{Net, DiNet}

Net(n::Int=0) = Net(Graph(n), VDSA(), EDSA(), DSA())
DiNet(n::Int=0) = DiNet(DiGraph(n), VDSA(), EDSA(), DSA())

Net(g::Graph) = Net(g, VDSA(), EDSA(), DSA())
DiNet(g::DiGraph) = DiNet(g, VDSA(), EDSA(), DSA())


getprop(n::UNet, p::Symbol) = n.gprops[p]
getprop(n::UNet, i::Int, p::Symbol) = n.vprops[i][p]
function getprop(n::UNet, e::Edge, p::Symbol)
    e = sort(n.graph, e)
    n.eprops[e][p]
end
getprop(n::UNet, i::Int, j::Int, p::Symbol) = getprop(n, Edge(i,j), p)

function setprop!(n::UNet, i::Int; kws...)
    props = get(n.vprops, i, DSA())
    for (name,value) in kws
        props[name] = value
    end
    n.vprops[i] = props
end

function setprop!(n::UNet, e::Edge; kws...)
    e = sort(n.graph, e)
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

"""
    add_vertex!(net; kws...)

Usage:
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
