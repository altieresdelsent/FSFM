isdefined(:obstacleIsInsideAnother) || include("obstacleIsInsideAnother.jl")

#using Debug
function obstacleTouchAnotherSameLine(obstacleTest::Obstacle, obstacleCrossed::Obstacle, obstacles::Vector{Obstacle}, indexObstacleTest::Int64, indexObstacleCrossed::Int64)
	if obstacleIsInsideAnother(obstacleTest, obstacleCrossed, obstacles, indexObstacleTest)
		return (-1,0,0)
	elseif obstacleIsInsideAnother(obstacleCrossed, obstacleTest, obstacles, indexObstacleCrossed)
		return (0,-1,0)
	else
	    info("obstacle\n $obstacleTest \n, reduced, because otherwise will interfer in the function to check visibility of pedestrians")
	    deleteat!(obstacles, indexObstacleTest)

	    if obstacleTest.start[1] == encounterPoint.x && obstacleTest.start[2] == encounterPoint.y
	        newObstacle1 = Obstacle([encounterPoint.x,encounterPoint.y],obstacleTest.ender) 
	        push!(obstacles,newObstacle1)                       
	    elseif obstacleTest.ender[1] == encounterPoint.x && obstacleTest.ender[2] == encounterPoint.y
	        newObstacle2 = Obstacle(obstacleTest.start,[encounterPoint.x,encounterPoint.y])
	        push!(obstacles,newObstacle2)
	    end
	    return (-1,0,0)
	end
end