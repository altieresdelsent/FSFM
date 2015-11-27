
import .Forces.aggregatedSocialForce!
import .Forces.getNearestObstacle
import .Forces.obstacleForce!
import .Forces.granularForce
import .Forces.desiredForce!
import .Load.zeroVector
import .Load.factorsocialforce
import .Load.factorobstacleforce
import .Load.factordesiredforce
import .Load.timeStep


function movePedestrian!(pedestrian,crowd,scene, returnDetails = false)
    #print("\n movePedestrian")
    if @isPointNan(pedestrian.position)
        error("pedestrian.position Nan")
    end
    #@bp
    counter = aggregatedSocialForce!(pedestrian,crowd,scene)
    if @isPointNan(pedestrian.socialGranular)
        error("pedestrian.socialGranular Nan")
    end

    (point,obstacle) = getNearestObstacle(pedestrian.position,scene.obstacles)
    obstacleForce!(pedestrian,point)
    lengthObstacle = @length(@minus(pedestrian.position,point))

    pedestrian.obstacleGranular = granularForce(pedestrian.position,point,pedestrian.velocity,zeroVector,0.2)

    if @isPointNan(pedestrian.obstacleGranular)
        error("pedestrian.obstacleGranular Nan")
    end

    desiredForce!(pedestrian, scene.engineDesiredVelocity, scene.engineDesiredAngle )

    acceleration = @multiplyFloat(pedestrian.socialForce,factorsocialforce)
    if @isPointNan(acceleration)
        error("socialForce Nan")
    end
    #currentPedestrian.acceleration = currentPedestrian.acceleration + factorsocialforce * currentPedestrian.socialGranularForce

    acceleration = @plus(acceleration,@multiplyFloat(pedestrian.obstacleForce,factorobstacleforce))
    if @isPointNan(acceleration)
        error("obstacle Nan")
    end
    #currentPedestrian.acceleration = currentPedestrian.acceleration + factorobstacleforce * currentPedestrian.obstacleGranularForce

    acceleration = @plus(acceleration,@multiplyFloat(pedestrian.desiredForce,factordesiredforce))
    if @isPointNan(acceleration)
        error("desired Nan")
    end

    pedestrian.newVelocity = @plus(pedestrian.velocity,@multiplyFloat(acceleration,timeStep))

    #don't exceed maximal speed
    lengthVelocity = @length(pedestrian.newVelocity)
    if lengthVelocity > pedestrian.maxVelocity
        pedestrian.newVelocity = @multiplyFloat(pedestrian.newVelocity,(pedestrian.maxVelocity / lengthVelocity))
        pedestrian.newVelocity = Point(pedestrian.newVelocity.x + (rand() * 1e-3 * pedestrian.maxVelocity),pedestrian.newVelocity.y + (rand() * 1e-3 * pedestrian.maxVelocity))
    else
        pedestrian.newVelocity = Point(pedestrian.newVelocity.x + (rand() * 1e-3 * lengthVelocity),pedestrian.newVelocity.y + (rand() * 1e-3 * lengthVelocity))
    end
    if @isPointNan(pedestrian.newVelocity)
        error("pedestrian.newVelocity Nan 1")
    end

    colissionMovementVelocity = @multiplyFloat(@plus(pedestrian.socialGranular,pedestrian.obstacleGranular),timeStep)

    if @isPointNan(colissionMovementVelocity)
        error("colissionMovementVelocity Nan")
    end
    lengthColissionSquared = @dot(colissionMovementVelocity,colissionMovementVelocity)
    if lengthColissionSquared > 0.0
        lengthColission = sqrt(lengthColissionSquared)
        if lengthColission > pedestrian.maxVelocity
            colissionMovementVelocity = @multiplyFloat(colissionMovementVelocity,(pedestrian.maxVelocity / lengthColission))
        end

        if lengthObstacle < 0.2
            #print("pedestrian.position:$(pedestrian.position)")
            #print("point:$(point)")
            #print("lengthObstacle:$(lengthObstacle)")
            #print("\n")
            #print("pedestrian.obstacleGranular:$(pedestrian.obstacleGranular)")
            #print("\n")
            #print("colissionMovementVelocity:$colissionMovementVelocity")
            #print("\n")
        end
        pedestrian.newPosition = @plus(pedestrian.position,@multiplyFloat(colissionMovementVelocity,timeStep))
    else
        pedestrian.newPosition = @plus(pedestrian.position,@multiplyFloat(pedestrian.newVelocity,timeStep))
    end
    #print("\naccelerration:$(acceleration),$(acceleration)\n")
    #print("\nvelocity:$(pedestrian.velocity),$(pedestrian.newVelocity)\n")
    #print("\nposition:$(pedestrian.position),$(pedestrian.newPosition)\n")
    if @isPointNan(pedestrian.newPosition)
        error("pedestrian.newPosition Nan")
    end
    #currentPedestrian.lookAheadForce = lookAheadForce(currentPedestrian,pedestriansVisible,currentPedestrian.desiredForce)
    #currentLookAheadForce = xptr
    if(returnDetails)
        return (pedestrian.socialForce,pedestrian.socialGranular,pedestrian.obstacleForce,pedestrian.obstacleGranular,pedestrian.desiredForce)
    else
        return counter
    end
end
