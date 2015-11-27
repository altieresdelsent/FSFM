using HttpServer
using WebSockets
using JSON
using Zlib
include("actionResponse.jl")

include("../load/types.jl")
include("../JuliaFuzzy/JuliaFuzzy.jl")
include("../forces/socialForce/socialForce.jl")
include("../load/types/buildFuzzy/buildFuzzySocial.jl")
include("../load/types/buildFuzzy/buildFuzzySocialDeacceleration.jl")
include("../load/types/buildFuzzy/buildFuzzySocialDirection.jl")
verbose = false
deAccelerator = buildFuzzySocialDeacceleration()
direction = buildFuzzySocialDirection()
wsh = WebSocketHandler() do req,wsClient
        isOpened = true
        while !wsClient.is_closed
            try
                msg = read(wsClient)
                #allRequest = Array(Float64,div(length(msg),8))
                allRequest = reinterpret(Float64,msg)
                ped = allRequest[1:2]
                otherPed = allRequest[3:4]
                velocity = allRequest[5:6]
                otherVelocity = allRequest[7:8]
                way = WayPoint([0.0, 0.0], 0.0, 0.0, 0.0)
                current = Pedestrian{Region}(1,ped,velocity,1.2,true,way)
                other = Pedestrian{Region}(2,otherPed,otherVelocity,1.2,true,way)
                data = reinterpret(Uint8,socialForce(current,other,direction,deAccelerator))
                actionResponse(wsClient,"socialAnswer",data)

            catch erro
                print(erro)
            end
        end
      end

server = Server(wsh)
run(server,8888)
