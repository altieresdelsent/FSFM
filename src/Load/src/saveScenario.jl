using ..Scene

function saveScenario(file::AbstractString,scenario::Scene, log, appendDefaultDirectory = true)
	dataBytes = sceneToBytes()
	file = appendDefaultDirectory ? "$baseDirectoryScenario/$file.scn":"$file.scn";
	fileScenario = open(file,"w")
	write(dataBytes)
	close(fileScenario)
end
