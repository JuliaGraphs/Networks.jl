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
