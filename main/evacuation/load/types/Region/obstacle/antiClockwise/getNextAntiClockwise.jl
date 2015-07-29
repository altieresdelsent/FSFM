#using Debug
function getNextAntiClockwise(region::Region,obstaclesCache::Vector{ObstacleCache},angle::Float64, index::Int64)
    newAngle = treatAngle(nextfloat(angle,-1024))
    if finalDistance == -1.0
        finalDistance = realmax(Float64)
    end
    antiClockwiseNext = LinearFunc(region.center[1],region.center[2],newAngle,true)
    lengthObstaclesCache = length(obstaclesCache)
    nextsObstacles = ObstacleCache[]
    if index <= lengthObstaclesCache
        for i in index:lengthObstaclesCache
            if obstaclesCache[i].distance > finalDistance
                break
            end

            if !solve(antiClockwiseNext,obstaclesCache[i].obstacle.funcCache)
                encounterPoint::FastSolution = solveFast(antiClockwiseNext,obstaclesCache[i].obstacle.funcCache)

                distanceSquared = region.center[1]*encounterPoint.x + region.center[2]*encounterPoint.y
                if finalDistance > distanceSquared
                    finalDistance = distanceSquared
                    nextsObstacles = ObstacleCache[obstaclesCache[i]]                    
                elseif finalDistance == distanceSquared
                    push!(nextsObstacles,obstaclesCache[i])
                end
            end
        end
    end
end
