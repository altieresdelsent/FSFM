
using Zlib

function loadSimulation(file::AbstractString, parseData = false, appendDefaultDirectory = true)
	file = appendDefaultDirectory ? "$baseFolderSimulation/$file.sml":"$file.sml"
	fileReader = open(file,"r")
	hash = readbytes(fileReader, 64)
	nScene = read(fileReader,Int32)
	sceneBytes = readbytes(fileReader, nScene)
	simulationBytes = readbytes(fileReader)
	close(fileReader)
	if parseData
		scene = parseScene(sceneBytes)
		simulation = parseSimulation(simulationBytes)
		return (hash,scene,simulation)
	else
		return (hash,sceneBytes,simulationBytes)
	end
end
function loadSimulation(data::Array{UInt8,1})
	buffer = IOBuffer(length(data))
	hash = readbytes(buffer, 64)
	nScene = read(buffer,Int32)
	sceneBytes = readbytes(buffer, nScene)
	simulationBytes = readbytes(buffer)
	if parseData
		scene = parseScene(sceneBytes)
		simulation = parseSimulation(simulationBytes)
		return (hash,scene,simulation)
	else
		return (hash,sceneBytes,simulationBytes)
	end
end
