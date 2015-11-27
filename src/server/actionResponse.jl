function actionResponse(client,action,data, verbose = false)
	buffer = IOBuffer()
	fullAnswer = IOBuffer();
	write(buffer, utf8(action))
	seekstart(buffer)

	actionBytes = readbytes(buffer)

	dataBytes = reinterpret(Uint8, data[:])
	write(fullAnswer,int32(length(actionBytes)))
	write(fullAnswer,actionBytes)
	write(fullAnswer,dataBytes)
	seekstart(fullAnswer)

    write(client, readbytes(fullAnswer))
end