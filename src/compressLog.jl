using Zlib
const lengthBlockPedestrian = 100
function compressLog(data)
	(pedLength,numberPedestrians,frames) = size(data)
	fullCompressedFile = IOBuffer()
	write(fullCompressedFile,Int32(pedLength))
	write(fullCompressedFile,Int32(numberPedestrians))
	write(fullCompressedFile,Int32(frames))
	if pedLength == 4
		numberBlocks = round(Int64,frames/lengthBlockPedestrian)

		for blockN in 0:(numberBlocks-1)
			startFrame = (blockN*lengthBlockPedestrian)+1
            compressLog!(fullCompressedFile, data, startFrame)
		end
	else
		print("$a:a\n")
	end
	#print("$c:c\n")
	#print("$b:b\n")
	#print("$a:a\n")
	seekstart(fullCompressedFile)
	return fullCompressedFile
end
function compressLog!(fullCompressedFile::IOBuffer, data, startFrame = 1)
    (pedLength,numberPedestrians,frames) = size(data)
    head = data[:,:,startFrame]
    body = Array(Float16,4,numberPedestrians,99)
    actual = Array(Float32,4,numberPedestrians)
    fill!(actual, Float32(0.0))
    startBody = startFrame+1
    endBody = startFrame+99
    for currentFrame in startBody:endBody
        frame = map(Float16,data[:,:,currentFrame] - (head + actual))
        actual[:,:] = actual[:,:] + frame
        currentAtBody = currentFrame - startFrame
        body[:,:,currentAtBody] = frame
    end

    blockBuffer = IOBuffer()
    write(blockBuffer,head)
    write(blockBuffer,body)
    seekstart(blockBuffer)

    compressedData = compress(readbytes(blockBuffer),6)
    n = Int32(length(compressedData))
	write(fullCompressedFile,n)
	write(fullCompressedFile,compressedData)
end
