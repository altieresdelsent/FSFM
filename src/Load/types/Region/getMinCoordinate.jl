function getMinCoordinate(obstacles::Vector{Obstacle}, index)
    minCoordinate = realmax(Float64)
    for obstacle in obstacles
        if(obstacle.start[index] < minCoordinate)
            minCoordinate = obstacle.start[index]
        end

        if(obstacle.ender[index] < minCoordinate)
            minCoordinate = obstacle.ender[index]
        end
    end
    return minCoordinate
end
