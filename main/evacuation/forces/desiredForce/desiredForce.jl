using types
function desiredForce!(pedestrian, desiredFuzzyVelocity, desiredFuzzyAngle)

    way = pedestrian.wayPoint.position
    vMax = pedestrian.maxVelocity
    ped = pedestrian.position
    velocity = pedestrian.velocity
    vecDirection = @minus(way,ped)
    #print("vecDirection=$vecDirection \n")

    #print("sqrt(dot(velocity,velocity))=$(sqrt(dot(velocity,velocity))) \n")
    differenceVelocity = (@length(velocity) / vMax) - 1
    #print("differenceVelocity=$differenceVelocity \n")
    angleDirection = atan2(vecDirection.y,vecDirection.x)
    #print("angleDirection=$angleDirection \n")
    angleVelocity = (velocity.x != 0.0 || velocity.y != 0.0) ? atan2(velocity.y,velocity.x) : angleDirection
    #print("angleVelocity=$angleVelocity \n")
    differenceAngle = angleVelocity - angleDirection
    if differenceAngle > pi
        differenceAngle = differenceAngle - 2*pi
    elseif differenceAngle < -pi
        differenceAngle = differenceAngle + 2*pi
    end
    #print("differenceAngle=$differenceAngle \n")
    #print("differenceVelocity=$differenceVelocity \n")
    #-pi = left | pi = right
    force = desiredFuzzyVelocity(differenceVelocity)
    angleTurn = desiredFuzzyAngle(differenceAngle)
    #print("force=$force \n")
    #print("angleTurn=$angleTurn \n")
    angleFinal = angleTurn + angleVelocity
    angleFinal = (angleFinal > pi)? angleFinal - 2pi:(angleFinal < -pi)? angleFinal + 2pi:angleFinal
    #print("angleFinal=$angleFinal \n")
    nextIdeal = @multiplyFloat(Point(cos(angleFinal),sin(angleFinal)),((force*vMax)+vMax))

    #print("nextIdeal=$nextIdeal \n")
    #print("velocity=$velocity \n")
    pedestrian.desiredForce = @minus(nextIdeal,velocity)
    #=ped = pedestrian.position
    way = pedestrian.wayPoint.position
    vMax = pedestrian.maxVelocity
    relaxationTime = 0.01

-1 = 1 - 2
1 = 2 - 1
    diffee = way - ped

    lengthVec = sqrt(dot(diffee,diffee))
    if lengthVec > 0.0
        force = ((diffee / lengthVec)*vMax) - pedestrian.velocity
        return force / (relaxationTime*75)
    else
        return [0.0, 0.0]
    end
=#
end
