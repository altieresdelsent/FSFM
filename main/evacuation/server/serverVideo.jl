
isdefined(:types) || include("../load/types.jl")
isdefined(:baseFolder) || include("../load/constants.jl")
isdefined(:getAllValues) || include("getAllValues.jl")
isdefined(:actionResponse) || include("actionResponse.jl")
isdefined(:loadSimulation) || include("../load/loadSimulation.jl")
isdefined(:getDimenAndDataSimulation) || include("../load/getDimenAndDataSimulation.jl")
isdefined(:parseScene) || include("../load/parseScene.jl")


using HttpServer
using WebSockets
using JSON
using Zlib
using types
verbose = true

videoHandler = WebSocketHandler() do req,client
    #try
        contador = 18
        allFrames = Array(Uint8,0)
        last = -1
        pedLength = 0
        pedCount = 0
        frameLength = 0
        sceneReal::Scene = Scene()
        crowd::Crowd = Crowd()
        while !client.is_closed
            verbose && print("inicio processamento de nova requisição\n")
            msg = read(client)
            verbose && print("$(utf8(msg))\n")
            clientMsg = JSON.parse(utf8(msg))
            action = clientMsg["action"]

            answerBuffer = IOBuffer()
            if  action == "getFrame"
                indexJs = clientMsg["idBlock"]
                indexFrame = indexJs+1

                if indexFrame > 0 && indexFrame <= length(allFrames)

                    #lengthFrames = length(allFrames[indexFrame])
                    write(answerBuffer,float32(indexJs))
                    #write(answerBuffer,float32(lengthFrames))
                    write(answerBuffer,allFrames[indexFrame])
                else
                    action = "outOfRange"
                end
            elseif action == "getInformation"
                indexJs = clientMsg["idBlock"]
                indexFrame = indexJs+1
                if indexFrame > 0 && indexFrame <= length(allFrames)

                    idPedestrianJs = int64(clientMsg["idPedestrian"])
                    idPedestrian = idPedestrianJs+1
                    #lengthFrames = length(allFrames[indexFrame])
                    dataMovement = getAllValues(crowd.pedestrians[idPedestrian],sceneReal,crowd,allFrames[indexFrame],pedCount)
                    verbose && print("indexJs: $(float32(indexJs))\n")
                    write(answerBuffer,float32(indexJs))
                    #write(answerBuffer,float32(lengthFrames))
                    write(answerBuffer,float32(idPedestrianJs))
                    verbose && print("idPedestrianJs: $(float32(idPedestrianJs))\n")
                    write(answerBuffer,dataMovement)
                else
                    action = "outOfRange"
                end
            elseif action == "open"
                file = clientMsg["fileName"]

                verbose && print("loading file: $file\n")
                (hash,sceneBytes,simulation) = loadSimulation(file)
                verbose && print("loaded file: $file\n")

                (dimen,allFrames) = getDimenAndDataSimulation(simulation)
                (pedLength,pedCount,frameLength) = dimen
                verbose && print("carregou allFrames\n")

                write(answerBuffer,hash)
                write(answerBuffer,int32(length(allFrames)))
                write(answerBuffer,sceneBytes)
                verbose && print("parse em scenes e crowd allFrames\n")
                (sceneReal,crowd) = parseScene(sceneBytes)
                verbose && print("carregou sceneReal\n")
            end
            seekstart(answerBuffer)
            #verbose && print("voltou para inicio sceneReal\n")
            actionResponse(client,action,readbytes(answerBuffer))
            verbose && print("enviou mensagem com actionResponse\n")
        end
    #=catch erro
        #print(erro)
        print(typeof(erro))
        print(erro.f)
        print(names(erro))
        #print(erro)
    end=#
end

server = Server(videoHandler)
run(server,8090)
