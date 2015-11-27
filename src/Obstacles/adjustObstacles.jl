isdefined(:obstacleTouchAnotherSameLine) || include("obstacleTouchAnotherSameLine.jl")
isdefined(:splitObstacle) || include("splitObstacle.jl")
#using Debug
function adjustObstacles(obstacleTest::Obstacle, obstacleCrossed::Obstacle, obstacles::Vector{Obstacle}, indexObstacleTest::Int64 = 0, indexObstacleCrossed::Int64 = 0)
	encounterPoint::FastSolution = solveFast(obstacleTest.funcCache,obstacleCrossed.funcCache)
	if encounterPoint.hasManySolution
	    return obstacleTouchAnotherSameLine(obstacleTest, obstacleCrossed, obstacles, indexObstacleTest, indexObstacleCrossed)
	else                    
	    info("obstacle\n $obstacleTest \n, was crossing another obstacle so we split in two, because otherwise will interfer in the function to check visibility of pedestrians")
	    lengthObstacle = lengthObstacle + 1
	    (newObstacle1,newObstacle2) = splitObstacle(obstacleTest,[encounterPoint.x,encounterPoint.y])
	    deleteat!(obstacles, indexObstacleTest)
	    push!(obstacles,newObstacle1)
	    push!(obstacles,newObstacle2)
	    return (-1,0,1)
	end
end