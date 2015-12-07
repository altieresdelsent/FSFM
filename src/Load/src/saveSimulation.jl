using ..compressLog
using Nettle
using ..Scene
using ..Crowd
function saveSimulation(file, fileSimulation::IOBuffer, appendDefaultDirectory = true)
    seekstart(fileSimulation)
	bytesFile = readbytes(fileSimulation)
    hash = digest("sha512",bytesFile)
    file = appendDefaultDirectory ? "$baseFolderSimulation/$file.sml":"$file.sml"
	finalFileStream = open(file,"w")
	write(finalFileStream,hash)
	write(finalFileStream,bytesFile)
	close(finalFileStream)
end

function saveSimulation(file, scene::Scene,crowd::Crowd, compressedLog::IOBuffer, appendDefaultDirectory = true, IsLogCompressed = false)

    fileSimulation::IOBuffer = IOBuffer()
    dataBytes::IOBuffer = sceneToBytes(scene,crowd)
    #open(file,"w")
	write(fileSimulation,Int32(dataBytes.size))
	write(fileSimulation,dataBytes)
	#print(length(compressedLog))
	write(fileSimulation,compressedLog)

    saveSimulation(file, compressedLog::IOBuffer, appendDefaultDirectory)
end
function saveSimulation(file, scene::Scene,crowd::Crowd, log, appendDefaultDirectory = true)

    (x,y,z) = size(log)
    for j in 1:y
        crowd.pedestrians[j].position = Point(Float64(log[1,j,1]),Float64(log[2,j,1]));
        crowd.pedestrians[j].velocity = Point(Float64(log[3,j,1]),Float64(log[4,j,1]));
    end

    logPositionVelocity = extractPedPositAndVeloc(log)
    compressedLog::IOBuffer = compressLog(logPositionVelocity)
    saveSimulation(file,scene,crowd,compressedLog)
end
