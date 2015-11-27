
using JuliaFuzzy.LinearAlgebra	
#using Debug
function obstacleIsInsideAnother(obstacleTest::Obstacle, obstacleCrossed::Obstacle, obstacles::Vector{Obstacle}, indexObstacleTest::Int64)
	if obstacleIsInsideAnother(obstacleTest.funcCache,obstacleCrossed.funcCache)
	    info("obstacle \n $obstacleTest, \n excluded because obstacle was inside another obstacle.")
	    deleteat!(obstacles, indexObstacleTest)
	    return true
	else
		return false
	end
end

function obstacleIsInsideAnother(first::LinearFunc, second::LinearFunc)
	return first.xMax < second.xMax && first.xMax > second.xMin && first.xMin < second.xMax && first.xMin > second.xMin
end