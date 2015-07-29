using Distance
type Point
    x::Float64
    y::Float64
end
function testSortJulia()
    values = rand(100,2) * 13
    points = Array(Point,100)
    for i in 1:100
        points[i] = Point(values[i,1],values[i,2])
    end
    function transform(point)
        return point.x + point.y
    end
    sort(points, by=transform)
end
