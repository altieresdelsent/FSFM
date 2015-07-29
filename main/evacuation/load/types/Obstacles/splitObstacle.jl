#using Debug
function splitObstacle(obstacle::Obstacle, splitPoint::Float64)
	newObstacle1 = Obstacle(splitPoint,obstacleTest.ender)
	newObstacle2 = Obstacle(obstacleTest.start,splitPoint)
	return (newObstacle1,newObstacle2)
end