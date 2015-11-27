using Distances
#using Debug
function loadObstaclesCache(region::Region, scene::Scene)
    lengthObstacle = length(scene.obstacles)
    points = Array(Float64,2,lengthObstacle)
    start = Array(Float64,2,lengthObstacle)
    ender = Array(Float64,2,lengthObstacle)
    xs = Array(Float64,lengthObstacle*2)
    ys = Array(Float64,lengthObstacle*2)
    obstaclesCache = Array(ObstacleCache,lengthObstacle)

    dist = Euclidean()

    for i in 1:lengthObstacle        
        points[:,i] = closestPoint(region.center,scene.obstacles[i])
        start[:,i] = scene.obstacles[i].start
        ender[:,i] = scene.obstacles[i].ender
        xs[((i-1)*2) + 1] = scene.obstacles[i].start[1] - region.center[1]
        ys[((i-1)*2) + 1] = scene.obstacles[i].start[2] - region.center[2]

        xs[((i-1)*2) + 2] = scene.obstacles[i].ender[1] - region.center[1]
        ys[((i-1)*2) + 2] = scene.obstacles[i].ender[2] - region.center[2]
    end

    distances = colwise(dist, region.center, points)
    startDists = colwise(dist, region.center, start)
    enderDists = colwise(dist, region.center, ender)
    radiansCache = atan2(xs,ys)

    for i in 1:lengthObstacle
        point = points[:,i]
        pointFunc = LinearFunc(region.center[1],region.center[2],point[1],point[2])

        startFunc = LinearFunc(region.center[1],region.center[2],scene.obstacles[i].start[1],scene.obstacles[i].start[2])
        enderFunc = LinearFunc(region.center[1],region.center[2],scene.obstacles[i].ender[1],scene.obstacles[i].ender[2])

        regionRadian = RegionRadian(radiansCache[((i-1)*2) + 1],radiansCache[((i-1)*2) + 2])
        startAngleDist = startDists[i]
        endAngleDist = enderDists[i]
        if radiansCache[((i-1)*2) + 1] != regionRadian.start && radiansCache[((i-1)*2) + 2] != regionRadian.ender
            startAngleDist = enderDists[i]
            endAngleDist = startDists[i]
            startFunc = LinearFunc(region.center[1],region.center[2],scene.obstacles[i].ender[1],scene.obstacles[i].ender[2])
            enderFunc = LinearFunc(region.center[1],region.center[2],scene.obstacles[i].start[1],scene.obstacles[i].start[2])            
        end

        obstaclesCache[i] = ObstacleCache(scene.obstacles[i],point,pointFunc,distances[i],startAngleDist,startFunc,endAngleDist,enderFunc,regionRadian)
    end

    return obstaclesCache
end
