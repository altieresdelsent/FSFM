function saveAll(file::String, data)
	fileWriter = open(file,"w")
	(m,n) = size(data)
	write(fileWriter,m)
	write(fileWriter,n)
	write(fileWriter,data)
	close(fileWriter)
end