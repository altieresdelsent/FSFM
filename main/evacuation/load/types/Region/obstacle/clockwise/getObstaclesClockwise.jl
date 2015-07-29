isdefined(:getNextClockwise) || include("getNextClockwise.jl")
isdefined(:getBelowObstacleClockwise) || include("getBelowObstacleClockwise.jl")
#using Debug
function getObstaclesClockwise(region::Region, obstaclesCache::Vector{ObstacleCache}, obstaclesClockwise)
    lengthObstacle = length(obstaclesCache)
    regionRadians = Array(RegionRadian,0)
    #@bp
    for i in 1:lengthObstacle
        obstacleCache = obstaclesCache[i]
        if hasObstacleCache(obstaclesClockwise,obstacleCache)
            continue
        end
        if outOfRegion(region,obstacleCache)
            if isOutsideAllRegionRadian(obstaclesClockwise,obstacleCache.regionRadian) || isVisibleCache(obstacleCache.pointFunc,obstaclesClockwise)
                
                #if enderDist is differente, so the points of ender and distance are not the same
                # so it's possible that exists some obstacle below
                #@bp
                if obstacleCache.enderDist != obstacleCache.distance
                    getBelowObstacleClockwise(obstaclesClockwise,region,obstacleCache,obstaclesCache,i+1, obstacleCache.regionRadian.ender)
                else
                    addSortedObstacle!(region.obstacles,obstacleCache)
                end

                nexts = getNextClockwise(region,obstaclesCache,obstacleCache.regionRadian.ender,i)

                for nextClockwise in nexts
                    newObstacles = getBelowObstacleClockwise(obstaclesClockwise,region,nextClockwise,obstaclesCache,i+1, obstacleCache.regionRadian.ender)
                end
            end
        else
            addSortedObstacle!(region.obstacles,obstacleCache)
        end
    end
    return obstaclesClockwise
end
