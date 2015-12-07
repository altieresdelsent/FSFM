#using Zlib
using .Load.sceneToBytes
function doEvacuation(scene::Scene,crowd::Crowd,iterations )
    numberPedestrians = length(crowd.pedestrians)
    lengthPedestrian = 4
    pedestriansLog = map(Float32,zeros(lengthPedestrian,numberPedestrians,100))
    saveLog(crowd,pedestriansLog,1)
    onePercente = iterations / 100
    fileSimulation = IOBuffer()
    dataBytes = sceneToBytes(scene,crowd)
	write(fileSimulation,Int32(dataBytes.size))
    write(fileSimulation,dataBytes)
    write(fileSimulation,Int32(lengthPedestrian))
	write(fileSimulation,Int32(numberPedestrians))
	write(fileSimulation,Int32(iterations))
    counterPedCal = 0.0
    lengthPedCal = 0.0
    counterFinal = 0
    totalLengthFile = 0
    totalLengthNormal = 0
    for i = 2:iterations
        counter = move!(scene,crowd,i)
        if (i%500) == 0
            print("$((i/iterations) * 100)% --")
        end
        lengthPedCal = lengthPedCal + counter
        #lengthPedCal = lengthPedCal + moveByRegion!(scene,i)
        counterPedCal = counterPedCal + numberPedestrians
        saveLog(crowd,pedestriansLog,(i%100)+1)
        if ((i%100) == 1)
            compressLog!(fileSimulation,pedestriansLog)
        end
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
    seekstart(fileSimulation)
    return fileSimulation
end
