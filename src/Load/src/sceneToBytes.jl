using ..Scene
using ..Crowd
function sceneToBytes(scenario::Scene,crowd::Crowd)
	buffer = IOBuffer()
    function pointToVec(point)
        [point.x,point.y]
    end
	function savePedestrianRegion(pedestriansRegions)
		for region in pedestriansRegions
			write(buffer,pointToVec(region.position))
			write(buffer,region.width)
			write(buffer,region.height)
			write(buffer,region.n)
		end
	end
	function savePedestrian(pedestrians)
		for pedestrian in pedestrians
			write(buffer,Float64(pedestrian.id))
			write(buffer,pointToVec(pedestrian.position))
			write(buffer,pointToVec(pedestrian.velocity))
			write(buffer,pedestrian.maxVelocity)
		end
	end
	function saveObstacle(obstacles)
		for obstacle in obstacles
			write(buffer,pointToVec(obstacle.start))
			write(buffer,pointToVec(obstacle.ender))
		end
	end
	function saveWaypoint(waypoints)
		for waypoint in waypoints
			write(buffer,pointToVec(waypoint.position))
			write(buffer,waypoint.radius)
		end
	end
	function saveObjective(objectives)
		for objective in objectives
			write(buffer,pointToVec(objective.position))
			write(buffer,objective.radius)
		end
	end

	write(buffer,Int32(length(scenario.pedestriansRegions)))
	savePedestrianRegion(scenario.pedestriansRegions)

	write(buffer,Int32(length(crowd.pedestrians)))
	savePedestrian(crowd.pedestrians)

	write(buffer,Int32(length(scenario.obstacles)))
	saveObstacle(scenario.obstacles)

	write(buffer,Int32(length(scenario.wayPoints)))
	saveWaypoint(scenario.wayPoints)

	write(buffer,Int32(length(scenario.objectives)))
	saveObjective(scenario.objectives)
	seekstart(buffer)

	return readbytes(buffer)
end
