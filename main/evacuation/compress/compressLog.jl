using Zlib

function compressLog(data)
	(pedLength,numberPedestrians,frames) = size(data)
	fullCompressedFile = IOBuffer()
	write(fullCompressedFile,int32(pedLength))
	write(fullCompressedFile,int32(numberPedestrians))
	write(fullCompressedFile,int32(frames))
	if pedLength == 4
		numberBlocks = int64(frames/100)
		
		for blockN in 0:(numberBlocks-1)

			startFrame = (blockN*100)+1

			head = data[:,:,startFrame]
			body = Array(Float16,4,numberPedestrians,99)
			actual = Array(Float32,4,numberPedestrians)
			fill!(actual, float32(0.0))
			startBody = startFrame+1
			endBody = startFrame+99
			for currentFrame in startBody:endBody
				frame = float16(data[:,:,currentFrame] - (head + actual))
				actual[:,:] = actual[:,:] + frame
				currentAtBody = currentFrame - startFrame
				body[:,:,currentAtBody] = frame
			end
			
			blockBuffer = IOBuffer()
			write(blockBuffer,head)
			write(blockBuffer,body)
			seekstart(blockBuffer)

			compressedData = compress(readbytes(blockBuffer),6)
			n = int32(length(compressedData))
			write(fullCompressedFile,n)
			write(fullCompressedFile,compressedData)
		end
	else 
		print("$a:a\n")
	end
	#print("$c:c\n")
	#print("$b:b\n")
	#print("$a:a\n")
	seekstart(fullCompressedFile)
	return readbytes(fullCompressedFile)
end