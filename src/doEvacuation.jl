#using Zlib
function doEvacuation(scene::Scene,crowd,iterations )
    n = length(crowd.pedestrians)
    lengthPedestrian = 9
    pedestriansLog = map(Float32,zeros(lengthPedestrian,n,iterations+1))
    saveLog(crowd,pedestriansLog,1)
    onePercente = iterations / 100

    counterPedCal = 0.0
    lengthPedCal = 0.0
    counterFinal = 0
    totalLengthFile = 0
    totalLengthNormal = 0
    for i = 2:(iterations+1)
        counter = move!(scene,crowd,i)
        if (i%500) == 0
            print("$((i/iterations) * 100)% --")
        end
        lengthPedCal = lengthPedCal + counter
        #lengthPedCal = lengthPedCal + moveByRegion!(scene,i)
        counterPedCal = counterPedCal + n
        saveLog(crowd,pedestriansLog,i)
        counterFinal = i
    end
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
