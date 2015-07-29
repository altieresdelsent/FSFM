isdefined(:types) || include("load/types.jl")
isdefined(:move!) || include("move.jl")
#isdefined(:moveByRegion!) || include("moveByRegion.jl")
isdefined(:saveLog) || include("saveLog.jl")

using types
#using Zlib
#using Debug

#scenprint(current_module())
function doEvacuation(scene::Scene,crowd,iterations )
    n = length(crowd.pedestrians)
    lengthPedestrian = 9
    pedestriansLog = float32(zeros(lengthPedestrian,n,iterations+1))
    #tic()
    #toc()
    #tic()
    saveLog(crowd,pedestriansLog,1)
    #toc()
    #print("dsfds");
    #print(iterations);
    onePercente = iterations / 100

    tic()
    counterPedCal = 0.0
    lengthPedCal = 0.0
    counterFinal = 0
    totalLengthFile = 0
    totalLengthNormal = 0
    for i = 2:(iterations+1)
        #print("dsfds");
        counter = move!(scene,crowd,i)
        #print("\nmoveu")
        if (i%500) == 0
            print("$((i/iterations) * 100)% --")
        end
        lengthPedCal = lengthPedCal + counter
        #lengthPedCal = lengthPedCal + moveByRegion!(scene,i)
        counterPedCal = counterPedCal + n
        saveLog(crowd,pedestriansLog,i)
        #print("\nsalvou")
        counterFinal = i
        #print("\nterminou");
    end
    toc()
    #print("vai retornar, haah")
    print("Total cálculos:")
    print(lengthPedCal)
    print("\n")
    print("Total pedestres:")
    print(counterPedCal)
    print("\n")
    print("Media cálculo por pedestre:")
    print(lengthPedCal /counterPedCal)
    print("\n")
    return pedestriansLog
end
