using Distance
function benchmarkDist()
    dist = Euclidean()
    initial = rand(2,1200)
    distancesH = pairwise(dist,initial)


    tic()
    for i in 1:5000
        pairwise!(distancesH,dist,initial)
        rand!(initial)
    end
    toc()
end
