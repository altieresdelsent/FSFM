#using Debug
function addSortedObstacle!(obstaclesCache::Vector{ObstacleCache},newObstacleCache::ObstacleCache)
    jump = false
    lengthCache = length(obstaclesCache)
    i = 1
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

function addSortedObstacle!(obstaclesCache::Vector{ObstacleCache},newObstacleCache::ObstacleCache, i::Int64, lengthCache::Int64, jump)
    if i <= lengthCache && !jump
        insert!(obstaclesCache,i,newObstacleCache)
    elseif i == (lengthCache+1)
        push!(obstaclesCache,newObstacleCache)
    end
end
