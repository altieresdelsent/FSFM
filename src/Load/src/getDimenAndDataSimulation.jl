function getDimenAndDataSimulation(simulation)
	lengthSimulation = length(simulation)
	bufferSimulation = IOBuffer(lengthSimulation)
	write(bufferSimulation,simulation)
	seekstart(bufferSimulation)

	#print("getDimenAndDataSimulation lengthSimulation:$lengthSimulation \n")

	frames = Array(Array{UInt8,1},0)
	contador = 1
	a = read(bufferSimulation, Int32)
	#print("getDimenAndDataSimulation a:$a \n")
	b = read(bufferSimulation, Int32)
	#print("getDimenAndDataSimulation b:$b \n")
	c = read(bufferSimulation, Int32)
	#print("getDimenAndDataSimulation c:$c \n")
	#total = 12
	while true
		n = read(bufferSimulation, Int32)
		#total = total + n
		#print("getDimenAndDataSimulation n:$n \n")
		#print("getDimenAndDataSimulation total:$total \n")
		frame = Array(UInt8,n)
		readbytes!(bufferSimulation, frame)
		push!(frames,frame)
		contador = contador + n
		#print("getDimenAndDataSimulation contador:$contador \n")
		if eof(bufferSimulation)
			break
		end
	end
	return ([a,b,c],frames)
end
