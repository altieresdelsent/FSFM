#using Debug
function isVisibleCache(func::LinearFunc,obstaclesCache::Vector{ObstacleCache})
    for obstacleCache in obstaclesCache
        if !solve(func,obstacleCache.obstacle.funcCache)
            return false
        end
    end
    return true
end
