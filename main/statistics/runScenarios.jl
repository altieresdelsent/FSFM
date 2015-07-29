function runScenarios(name,number)
	for i in 1:number
		scenario = loadAll("$(name)_$i")
		log = doEvacuation(scenario,4000)
		fileWriter = open("$baseFolderStatistics/log/$(name)_$i.log","w")
		(m,n) = size(log)
		write(fileWriter,m)
		write(fileWriter,n)
		write(fileWriter,log)
		close(fileWriter)
	end
end