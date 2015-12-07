function saveLog(crowd,pedestriansLog,i)
    contador = 0
    for pedestrian in crowd.pedestrians
        contador = contador + 1
        infPosition = 0

        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.position.x)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.position.y)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.velocity.x)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.velocity.y)
        #=index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.acceleration[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.acceleration[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.socialForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.socialForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.socialGranularForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.socialGranularForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.obstacleForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.obstacleForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.obstacleGranularForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.obstacleGranularForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.desiredForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.desiredForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.lookAheadForce[1])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.lookAheadForce[2])
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.maxVelocity)
        index = index + 1
        pedestriansLog[i,indPed,index] = Float32(ped.active? 1.0: 0.0)=#
        #=infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.wayPoint.position.x)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.wayPoint.position.y)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.wayPoint.radius)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.wayPoint.deepness)
        infPosition = infPosition + 1
        pedestriansLog[infPosition,contador,i] = Float32(pedestrian.wayPoint.distance)=#
    end

end
