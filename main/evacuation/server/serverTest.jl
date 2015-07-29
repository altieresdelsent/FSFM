using HttpServer
using WebSockets
using JSON
using Zlib
include("actionResponse.jl")
verbose = false
wsh = WebSocketHandler() do req,wsClient
        isOpened = true
        while !wsClient.is_closed
            try
                msg = read(wsClient)
                print(utf8(msg))
                print("\n")
                clientMsg = JSON.parse(utf8(msg))
                if clientMsg["action"]== "getFrame"
                    
                    number = clientMsg["number"]
                    buffer = IOBuffer(4*4 + 4*2*99)
                    write(buffer,float32(1.0))
                    write(buffer,float32(2.0))
                    write(buffer,float32(3.0))
                    write(buffer,float32(4.0))

                    write(buffer,float16(0.23))
                    write(buffer,float16(0.345))
                    write(buffer,float16(0.456))
                    write(buffer,float16(0.567))
                    for i = 1:98
                        write(buffer,float16(0.1))
                        write(buffer,float16(0.1))
                        write(buffer,float16(0.1))
                        write(buffer,float16(0.1))
                    end

                    seekstart(buffer)
                    dataUncompressed = readbytes(buffer)
                    
                    dataFrame = compress(dataUncompressed,6)
                    
                    lengthFrames = length(dataFrame)
                    data = [reinterpret(Uint8, [float32(number),float32(lengthFrames)]), dataFrame]
                    actionResponse(wsClient,"getFrame",data)
                elseif clientMsg["action"] == "pakoTest"
                    data = float32([1:1000]) / 10
                    uncompressedData = reinterpret(Uint8, data)
                    compressedData = compress(uncompressedData,6)
                    write(wsClient,compressedData)
                end
            catch erro
                print(erro)
            end
        end
      end

server = Server(wsh)
run(server,8888)
