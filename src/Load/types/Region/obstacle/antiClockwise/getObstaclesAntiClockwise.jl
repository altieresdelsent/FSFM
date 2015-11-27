isdefined(:getNextAntiClockwise) || include("getNextAntiClockwise.jl")
isdefined(:getBelowObstacleAntiClockwise) || include("getBelowObstacleAntiClockwise.jl")
#using Debug
function getObstaclesAntiClockwise(region::Region, obstaclesCache::Vector{ObstacleCache})
    lengthObstacleCache = length(obstaclesCache)
    obstaclesAntiClockwise = ObstacleCache[]
    for i in 1:lengthObstacleCache
        obstacleCache = obstaclesCache[i]
        if hasObstacleCache(obstaclesAntiClockwise,obstacleCache)
            continue
        end
        if outOfRegion(region,obstacleCache)
            if isOutsideAllRegionRadian(obstaclesAntiClockwise,obstacleCache.regionRadian) || isVisibleCache(obstacleCache.pointFunc,obstaclesAntiClockwise)
                
                #if enderDist is differente, so the points of ender and distance are not the same
                # so it's possible that exists some obstacle below
                #@bp
                if obstacleCache.startDist != obstacleCache.distance
                    getBelowObstacleAntiClockwise(obstaclesAntiClockwise,region,obstacleCache,obstaclesCache,i+1, obstacleCache.regionRadian.start)
                else
                    addSortedObstacle!(region.obstacles,obstacleCache)
                end

                nexts = getNextAntiClockwise(region,obstaclesCache,obstacleCache.regionRadian.start,i)

                for nextClockwise in nexts
                    newObstacles = getBelowObstacleAntiClockwise(obstaclesAntiClockwise,region,nextClockwise,obstaclesCache,i+1, obstacleCache.regionRadian.start)
                end
            end
        else
            addSortedObstacle!(region.obstacles,obstacleCache)
        end
    end
    return obstaclesAntiClockwise
end
