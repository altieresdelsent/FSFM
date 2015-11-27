using JuliaFuzzy.Engine
using ..@isPointNan
using ..@multiplyFloat
using ..Point

function obstacleForce!( pedestrian,pointObstacle)
#@bp typeof(pedestrianPosition) != typeof(pointObstacle)
    if @isPointNan(pointObstacle)
        error("pointObstacle Nan")
    end
    if @isPointNan(pedestrian.position)
        error("pedestrian.position Nan, $(pedestrian.id)")
    end
    minDiff = @minus(pedestrian.position,pointObstacle)
    if @isPointNan(minDiff)
        error("minDiff Nan")
    end
    minDistance = @length(minDiff)
    if isnan(minDistance)
        error("minDistance Nan")
    end
    agentRadius = 0.2
    obstacleForceSigma = 0.1

    distance = minDistance - agentRadius
    if isnan(distance)
        error("distance Nan")
    end
    forceAmount = obstacleFuzzy(distance)
    if isnan(forceAmount)
        error("forceAmount Nan")
    end

    #forceAmount = 3*exp(-distance/obstacleForceSigma);
    #return forceAmount
    pedestrian.obstacleForce = @multiplyFloat(minDiff,forceAmount / minDistance)
end
