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

function teste()
verbose = true
contador = 18
        allFrames = Array(Uint8,0)
        last = -1
        pedLength = 0
        pedCount = 0
        frameLength = 0
        sceneReal::Scene = Scene()
        crowd::Crowd = Crowd()
file = "desiredFuzzy"
verbose && print("loading file: $file\n")
                (hash,sceneBytes,simulation) = loadSimulation(file)
                verbose && print("loaded file: $file\n")

                (dimen,allFrames) = getDimenAndDataSimulation(simulation)
                (pedLength,pedCount,frameLength) = dimen
                verbose && print("carregou allFrames\n")

                verbose && print("parse em scenes e crowd allFrames\n")
                (sceneReal,crowd) = parseScene(sceneBytes)
                verbose && print("carregou sceneReal\n")

                indexJs = 1
                indexFrame = indexJs+1


                indexJs = 1
                indexFrame = indexJs+1
                if indexFrame > 0 && indexFrame <= length(allFrames)

                    idPedestrianJs = int64(1)
                    idPedestrian = idPedestrianJs+1
                    #lengthFrames = length(allFrames[indexFrame])
                    dataMovement = getAllValues(crowd.pedestrians[idPedestrian],sceneReal,crowd,allFrames[indexFrame],pedCount)
                    verbose && print("indexJs: $(float32(indexJs))\n")
                    verbose && print("idPedestrianJs: $(float32(idPedestrianJs))\n")
                else
                    action = "outOfRange"
end

end
teste()

