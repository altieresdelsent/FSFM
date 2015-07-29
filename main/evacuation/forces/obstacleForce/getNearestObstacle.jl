using types
using Debug
isdefined(:closestPoint) || include("closestPoint.jl")
@debug function getNearestObstacle( pedestrianPosition, obstacles )
    minObstacle = obstacles[1]
    minPoint = closestPoint(pedestrianPosition, minObstacle)
    diffee = @minus(pedestrianPosition,minPoint)
    minDistance = @dot(diffee,diffee)

    for obstacle in obstacles
        point = closestPoint(pedestrianPosition, obstacle)

        diffee = @minus(pedestrianPosition,point)
        distance = @dot(diffee,diffee)
        #print("distance:$distance, point:$point, obstacle:$(obstacle.start)$(obstacle.ender)\n")
        if distance < minDistance
            minDistance = distance
            #print("minDistance:$minDistance\n")
            minPoint = point
            minObstacle = obstacle
        end
    end
    x = (minPoint,minObstacle)

    return x
end
