using Zlib
function parseSimulation(data::Array{Uint8,1})
	buffer = IOBuffer(length(data))
	write(buffer,data)
	seekstart(buffer)

	a = read(buffer,Int32)
	b = read(buffer,Int32)
	c = read(buffer,Int32)
	blocks = int32(c / 100)

	heads = Array(Array{Float32,3},blocks)
	bodys = Array(Array{Float16,3},blocks)

	
	for i = 1:blocks
		n = read(buffer,Int32)
		compressedLog = readbytes(buffer,n)
		finalLog = decompress(compressedLog)
		
		finalBuffer = IOBuffer(length(finalLog))
		write(finalBuffer,finalLog)
		seekstart(finalBuffer)
		
		head = Array(Float32,4,b,1)
		read!(finalBuffer,head)
		heads[i] = head
		
		
		body = Array(Float16,4,b,99)
		read!(finalBuffer,body)
		bodys[i] = body

	end
	return (heads,bodys)
end