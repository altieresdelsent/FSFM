using HttpServer
using WebSockets

wsh = WebSocketHandler() do req,client
        while true
            msg = read(client)
            floatArray = reinterpret(String,msg)

            for t in floatArray
                print(t)
                print("\n")
            end
            write(client, base64(floatArray))
        end
      end

server = Server(wsh)
run(server,8090)
