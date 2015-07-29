#using Debug
function addSortedObstacles!(obstaclesCache::Vector{ObstacleCache},newObstaclesCache::Vector{ObstacleCache})
    jump = false
    i = 1
    lengthCache = length(obstaclesCache)
    sortObstacles!(newObstaclesCache)
    for newObstacleCache in newObstaclesCache
        while i <= lengthCache && obstaclesCache[i].distance < newObstacleCache.distance
            i = i + 1
        end
        while i <= lengthCache && obstaclesCache[i].distance == newObstacleCache.distance
            if(obstaclesCache[i].obstacle == newObstacleCache.obstacle)
                jump = true
            end
            i = i + 1
        end
        addSortedObstacle!(obstaclesCache,newObstacleCache, i, lengthCache, jump)
        jump = false
    end
end
