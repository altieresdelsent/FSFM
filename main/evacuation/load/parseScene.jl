isdefined(:types) || include("types.jl")
isdefined(:loadPedestriansRegions) || include("loadPedestriansRegions.jl")
isdefined(:loadPedestrians) || include("loadPedestrians.jl")
isdefined(:loadObstacles) || include("loadObstacles.jl")
isdefined(:loadWayPoints) || include("loadWayPoints.jl")
isdefined(:loadObjectives) || include("loadObjectives.jl")
isdefined(:solveFast) || include("../visibility/solveFast.jl")
isdefined(:isVisible) || include("../visibility/isVisible.jl")
isdefined(:preComputeWayPoints) || include("preComputeWayPoints.jl")

using types

function parseScene(data::Vector{Uint8})
		fileReader = IOBuffer(length(data))
		write(fileReader,data)
		seekstart(fileReader)
		function processPedestrianRegion(n)
			retorno = zeros(5,n)
			for i in 1:n
				retorno[1,i] = read(fileReader, Float64)
				retorno[2,i] = read(fileReader, Float64)
				retorno[3,i] = read(fileReader, Float64)
				retorno[4,i] = read(fileReader, Float64)
				retorno[5,i] = read(fileReader, Float64)
			end
			return retorno
		end
		function processPedestrian(n)
			retorno = zeros(6,n)
			for i in 1:n
				id = read(fileReader, Float64)
				retorno[1,i] = read(fileReader, Float64)
				retorno[2,i] = read(fileReader, Float64)
				retorno[3,i] = read(fileReader, Float64)
				retorno[4,i] = read(fileReader, Float64)
				retorno[5,i] = read(fileReader, Float64)
				retorno[6,i] = 1.0
			end
			return retorno
		end
		function processObstacle(n)
			retorno = zeros(4,n)
			for i in 1:n
				retorno[1,i] = read(fileReader, Float64)
				retorno[2,i] = read(fileReader, Float64)
				retorno[3,i] = read(fileReader, Float64)
				retorno[4,i] = read(fileReader, Float64)
			end
			return retorno
		end
		function processWayPoint(n)
			retorno = zeros(5,n)
			for i in 1:n
				retorno[1,i] = read(fileReader, Float64)
				retorno[2,i] = read(fileReader, Float64)
				retorno[3,i] = read(fileReader, Float64)
				retorno[4,i] = 0.0
				retorno[5,i] = realmax(typeof(0.0))
			end
			return retorno
		end
		function processObjective(n)
			retorno = zeros(3,n)
			for i in 1:n
				retorno[1,i] = read(fileReader, Float64)
				retorno[2,i] = read(fileReader, Float64)
				retorno[3,i] = read(fileReader, Float64)
			end
			return retorno
		end

		n = read(fileReader,Int32)
		print("n:$n\n")
		pedestriansRegionsMatLab = processPedestrianRegion(n)

		n = read(fileReader,Int32)
		print("n:$n\n")
		pedestriansMatLab = processPedestrian(n)

		n = read(fileReader,Int32)
		print("n:$n\n")
        obstaclesMatLab = processObstacle(n)

        n = read(fileReader,Int32)
        print("n:$n\n")
        wayPointsMatLab = processWayPoint(n)

        n = read(fileReader,Int32)
        print("n:$n\n")
        objectivesMatLab = processObjective(n)

        close(fileReader)
        print("1 loadAll\n")
        pedestriansRegion = loadPedestriansRegions(pedestriansRegionsMatLab)
        print("1.2 loadAll\n")
        obstacles = loadObstacles(obstaclesMatLab)
        print("1.3 loadAll\n")
        wayPoints = loadWayPoints(wayPointsMatLab)
        print("1.4 loadAll\n")
        objectives = loadObjectives(objectivesMatLab)
        print("1.5 loadAll\n")
        wayPoints = preComputeWayPoints(wayPoints,objectives,obstacles)
        print("3 loadAll\n")
        scene = Scene(pedestriansRegion,obstacles,wayPoints,objectives)
        print("1.1 loadAll\n")
        crowd = Crowd(loadPedestrians(pedestriansMatLab))
        print("2 loadAll\n")


        print("4 loadAll\n")
        return (scene,crowd)
end
