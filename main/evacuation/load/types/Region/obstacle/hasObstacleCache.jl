#using Debug
 function hasObstacleCache(obstacles::Vector{ObstacleCache},obstacle::ObstacleCache)
    resultSearch = searchsorted(obstacles,obstacle,by=transformObstacleCache)
    for i in resultSearch
        if obstacles[i].obstacle == obstacle.obstacle
            return true
        end
    end
    return false
end

 function hasObstacleCache(obstacles::Vector{ObstacleCache},obstacle::Obstacle)
    return findfirst(a -> a.obstacle == obstacle,obstacles) != 0
end
