n = Net(10)
@test nv(n) == 10
@test ne(n) == 0

n10 = Net(CompleteGraph(10))
@test graph(n10) == CompleteGraph(10)

n = Net()
for i=1:10
    j = add_vertex!(n, id=i, label="v$i")
    @test j == i
end
@test nv(n) == 10
@test ne(n) == 0

for i=1:10
    p = getprop(n, i, :id)
    @test p == i

    p = getprop(n, i, :label)
    @test p == "v$i"
end

n10 = Net(CompleteGraph(10))

# graph properties
setprop!(n10, a=1,b="b")
@test getprop(n10, :a) ==  1
@test getprop(n10, :b) ==  "b"


# vertex properties
setprop!(n10, 1, a=1,b="b")
@test getprop(n10, 1, :a) ==  1
@test getprop(n10, 1, :b) ==  "b"


# edge properties
setprop!(n10, 1, 2, a=1,b="b")
@test getprop(n10, 1,2, :a) ==  1
@test getprop(n10, 1,2, :b) ==  "b"
setprop!(n10, Edge(1, 2), c=3.1)
@test getprop(n10, Edge(2,1), :c) ==  3.1
