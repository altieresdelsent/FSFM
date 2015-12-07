
#using Debug
using ..isVisible
#using ..
using LibExpat

function loadAll(file::AbstractString)

		fileReader = open("$baseFolderScenario/$file.scn","r")

		function processPedestrianRegion(n)
			cache = Array(Float64,5)
			retorno = zeros(5,n)
			for i in 1:n
				read!(fileReader,cache)
				retorno[1,i] = cache[1]
				retorno[2,i] = cache[2]
				retorno[3,i] = cache[3]
				retorno[4,i] = cache[4]
				retorno[5,i] = cache[5]
			end
			return retorno
		end

		function processPedestrian(n)
			cache = Array(Float64,6)
			retorno = zeros(6,n)
			for i in 1:n
				read!(fileReader,cache)
				retorno[1,i] = cache[2]
				retorno[2,i] = cache[3]
				retorno[3,i] = cache[4]
				retorno[4,i] = cache[5]
				retorno[5,i] = cache[6]
				retorno[6,i] = 1.0
			end
			return retorno
		end
		function processObstacle(n)
			cache = Array(Float64,4)
			retorno = zeros(4,n)
			for i in 1:n
				read!(fileReader,cache)
				retorno[1,i] = cache[1]
				retorno[2,i] = cache[2]
				retorno[3,i] = cache[3]
				retorno[4,i] = cache[4]
			end
			return retorno
		end
		function processWaypoint(n)
			cache = Array(Float64,3)
			retorno = zeros(5,n)
			for i in 1:n
				read!(fileReader,cache)
				retorno[1,i] = cache[1]
				retorno[2,i] = cache[2]
				retorno[3,i] = cache[3]
				retorno[4,i] = 0.0
				retorno[5,i] = realmax(typeof(0.0))
			end
			return retorno
		end
		function processObjective(n)
			cache = Array(Float64,3)
			retorno = zeros(3,n)
			for i in 1:n
				read!(fileReader,cache)
				retorno[1,i] = cache[1]
				retorno[2,i] = cache[2]
				retorno[3,i] = cache[3]
			end
			return retorno
		end

		n = read(fileReader,Int64)
		#print("n:$n\n")
		pedestriansRegionsMatLab = processPedestrianRegion(n)

		n = read(fileReader,Int64)
		#print("n:$n\n")
		pedestriansMatLab = processPedestrian(n)

		n = read(fileReader,Int64)
		#print("n:$n\n")
        obstaclesMatLab = processObstacle(n)

        n = read(fileReader,Int64)
        #print("n:$n\n")
        waypointsMatLab = processWaypoint(n)

        n = read(fileReader,Int64)
        #print("n:$n\n")
        objectivesMatLab = processObjective(n)

        close(fileReader)

        (pedestrians,positions,velocities) = loadPedestrians(pedestriansMatLab)
        objectives = loadObjectives(objectivesMatLab)
        wayPoints = loadWayPoints(waypointsMatLab)
        obstacles = loadObstacles(obstaclesMatLab)
        wayPoints = preComputeWayPoints(wayPoints,objectives,obstacles)

        scene = Scene(loadPedestriansRegions(pedestriansRegionsMatLab),obstacles,wayPoints,objectives)
        retornoNovo = preComputeWayPoints(wayPoints,objectives,obstacles)
        scene.wayPoints = retornoNovo
        #Crowd(1.0,1.0,1.0,2.0)
        crowd = createCrowd(pedestrians,scene.wayPoints,scene.obstacles)
        return (scene,crowd)
end

function loadAllXML(file::AbstractString)


    scenarioXML = xp_parse(readall("$baseFolderScenario/$file.xml"))

    pedestriansXML = scenarioXML["agent"]
    obstaclesXML = scenarioXML["obstacle"]
    wayPointsXML = scenarioXML["waypoint"]
    objectivesXML = scenarioXML["objective"]
        #print(methods(loadPedestrians))
        (pedestrians) = loadPedestrians(pedestriansXML)
        objectives = loadObjectives(objectivesXML)
        wayPoints = loadWayPoints(wayPointsXML)
        obstacles = loadObstacles(obstaclesXML)
        wayPoints = preComputeWayPoints(wayPoints,objectives,obstacles)
        #print("dsfsdfsd $positions")
        scene = Scene(loadPedestriansRegions(pedestriansXML),obstacles,wayPoints,objectives)

        crowd = createCrowd(pedestrians,wayPoints,obstacles)
        return (scene,crowd)
end
