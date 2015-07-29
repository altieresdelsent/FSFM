isdefined(:adjustObstacles) || include("adjustObstacles.jl")
#using Debug
function adjustObstaclesCrossingOneAnother(obstacles::Vector{Obstacle})
    return obstacles
    #need more testing before release
    lengthObstacle = length(obstacles)
    i = 1
    while  i <= lengthObstacle
        obstacle1 = obstacles[i]
        (adjustLength,adjustIndex) = adjustObstaclesCrossingOneAnother(obstacle1,obstacles)
        lengthObstacle = lengthObstacle + adjustLength
        i = i + adjustIndex
        i = i + 1
    end
    return obstacles
end

function adjustObstaclesCrossingOneAnother(obstacleTest::Obstacle,obstacles::Vector{Obstacle}, indexObstacleTest::Int64 = 0)
    lengthObstacle = length(obstacles)
    lengthObstacleOriginal = lengthObstacle
    indexOuter = 0
    i = 1
    while i <= lengthObstacle
        obstacleCrossed = obstacles[i]
        if obstacleTest != obstacleCrossed
            if !solve(obstacleTest.funcCache,obstacleCrossed.funcCache)
                #@bp
                solve(obstacleTest.funcCache,obstacleCrossed.funcCache)
                (adjustIndexOuter,adjustIndexInner,adjustLength) = adjustObstacles(obstacleTest, obstacleCrossed, obstacles, indexObstacleTest, i)
                lengthObstacle = lengthObstacle + adjustLength
                i = i + adjustIndexInner
                indexOuter = indexOuter + adjustIndexOuter
            end
        end
        i = i + 1
    end
    return ((lengthObstacle - lengthObstacleOriginal),indexOuter)
end