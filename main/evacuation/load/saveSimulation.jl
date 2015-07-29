include("constants.jl")
include("sceneToBytes.jl")
include("extractPedPositAndVeloc.jl")
include("../compress/compressLog.jl")
using Nettle

function saveSimulation(file, scene,crowd, log, appendDefaultDirectory = true)
	(x,y,z) = size(log)
	for j in 1:y
		crowd.pedestrians[j].position = Point(float64(log[1,j,1]),float64(log[2,j,1]));
		crowd.pedestrians[j].velocity = Point(float64(log[3,j,1]),float64(log[4,j,1]));
	end
	dataBytes = sceneToBytes(scene,crowd)
	logPositionVelocity = extractPedPositAndVeloc(log)
	compressedLog = compressLog(logPositionVelocity)

	fileSimulation = IOBuffer() #open(file,"w")
	write(fileSimulation,int32(length(dataBytes)))
	write(fileSimulation,dataBytes)
	#print(length(compressedLog))
	write(fileSimulation,compressedLog)

	seekstart(fileSimulation)
	bytesFile = readbytes(fileSimulation)
	hash = Nettle.sha512_hash(bytesFile)

	file = appendDefaultDirectory ? "$baseFolderSimulation/$file.sml":"$file.sml"
	finalFile = open(file,"w")
	write(finalFile,hash)
	write(finalFile,bytesFile)
	close(finalFile)
end
