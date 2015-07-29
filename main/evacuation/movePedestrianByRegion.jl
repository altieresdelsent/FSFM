function movePedestrianByRegion!{P <: Pedestrian}(currentPedestrian::P,scene::Scene,x::Int64,y::Int64,zeroVector::Vector{Float64})

    position = currentPedestrian.position
    velocity = currentPedestrian.velocity

    #pedestriansVisible = scene.pedestrians#getPedestriansVisible(position,obstacles,pedestrians)
    #pedestriansNear = getPedestriansNear(currentPedestrian,pedestriansVisible)

    pedestriansNear = scene.regions[x,y].pedestriansNear;#getPedestriansNear(scene,x,y)


    (currentSocialForce,currentGranularForce) = aggregatedSocialForce(currentPedestrian,pedestriansNear,scene.engineGranular)
    #@TEST = isnan(currentSocialForce[1]) || isnan(currentSocialForce[2])
    #@bp TEST
    currentPedestrian.socialForce = currentSocialForce

    #@bp isnan(currentGranularForce[1]) || isnan(currentGranularForce[2])
    currentPedestrian.socialGranularForce = currentGranularForce

    (point,obstacle) = getNearestObstacle(position,scene.obstacles)
    currentPedestrian.obstacleForce = obstacleForce(position,point,scene.engineObstacle)
    #@bp isnan(currentPedestrian.obstacleForce[1]) || isnan(currentPedestrian.obstacleForce[2])

    currentPedestrian.obstacleGranularForce = granularForce(position,point,velocity,zeroVector,scene.engineGranular)
    #@bp isnan(currentPedestrian.obstacleGranularForce[1]) || isnan(currentPedestrian.obstacleGranularForce[2])

    currentPedestrian.desiredForce = desiredForce(currentPedestrian)
    #@bp isnan(currentPedestrian.desiredForce[1]) || isnan(currentPedestrian.desiredForce[2])
    #currentPedestrian.lookAheadForce = lookAheadForce(currentPedestrian,pedestriansVisible,currentPedestrian.desiredForce)
    #currentLookAheadForce = xptr
    return length(pedestriansNear)
end