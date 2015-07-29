function getMaxCoordinate(obstacles::Vector{Obstacle}, index)
    maxCoordinate = realmin(Float64)
    for obstacle in obstacles
        if(obstacle.start[index] > maxCoordinate)
            maxCoordinate = obstacle.start[index]
        end

        if(obstacle.ender[index] > maxCoordinate)
            maxCoordinate = obstacle.ender[index]
        end
    end
    return maxCoordinate
end
