isdefined(:getInteractionVector) || include("getInteractionVector.jl")
isdefined(:socialFuzzy) || include("socialFuzzy.jl")
const gamma = 0.35
const n = 2.0
const n_prime = 3.0
const lambdaImportance = 2

using types
function socialForce(pedestrian,other, fDirec, fDeacce)
    result = Point(0.0, 0.0)

    currentPosition = pedestrian.position
    currentVelocity = pedestrian.velocity
    otherPosition = other.position
    otherVelocity = other.velocity
    #return result
    #Vector from pedestrian current to pedestrian other
    diffe = @minus(otherPosition,currentPosition)

    distanceBeetweenPeds = @length(diffe)

    attractionDirection = @divideFloat(diffe,distanceBeetweenPeds)

    #how much current are moving in relation with pedestrian other

    relativeVelocity = @minus(currentVelocity,otherVelocity)

    lengthRelativeVelocity = @length(relativeVelocity)
    # If the current are moving in the direction of other interaction vector will be stronger
    #otherwise it will be weaker
    #interactionVector = getInteractionVector(relativeVelocity,attractionDirection)
    percentilAngle = fDirec(lengthRelativeVelocity)

    angleDirection = atan2(attractionDirection.y,attractionDirection.x)
    angleRelativeVelocity = atan2(relativeVelocity.y,relativeVelocity.x)

    differenceAngle = angleRelativeVelocity - angleDirection

    if differenceAngle > pi
        differenceAngle = differenceAngle - 2*pi
    elseif differenceAngle < -pi
        differenceAngle = differenceAngle + 2*pi
    end
    angleInteraction = angleDirection
    #lengthRelativeVelocity = @length(relativeVelocity)
    thetaAngle = 0.0
    percentilAngle = 0.0
    if abs(differenceAngle) > 0.01
        percentilAngle = fDirec(lengthRelativeVelocity)
        thetaAngle = (differenceAngle*percentilAngle)
        angleInteraction = angleDirection + thetaAngle#(differenceAngle*percentilAngle)
    end
    if angleInteraction > pi
        angleInteraction = angleInteraction - 2*pi
    elseif angleInteraction < -pi
        angleInteraction = angleInteraction + 2*pi
    end
    interactionDirection = Point(cos(angleInteraction),sin(angleInteraction))

    #interactionVector = lambdaImportance * relativeVelocity + attractionDirection

    #get the true distance, discounting the radius of pedestrians
    distanceBeetweenPeds = distanceBeetweenPeds - 0.4

    #get the length of the interaction, if the pedestrian is moving to the
    # other pedestrian it will be bigger than one, if it's moving away from it
    # it will be less than one
    #interactionLength = sqrt(dot(interactionVector,interactionVector))

    # get the direction where the interaction is pointing
    #interactionDirection = interactionVector / interactionLength

    #the theta angle is the diference of angle between the "velocity" and the attraction direction
    #the bigger the angle the more the pedestrians are moving away one from another
    #angleInteraction = atan2(interactionDirection[2],interactionDirection[1])



    #thetaAngle = angleDirection - angleInteraction

    #if thetaAngle > pi
    #    thetaAngle = thetaAngle - 2*pi
    #elseif thetaAngle < -pi
    #    thetaAngle = thetaAngle + 2*pi
    #end
    thetaSign = 1.0
    if abs(differenceAngle) > 0.0000001
        thetaSign = differenceAngle/abs(differenceAngle)
    end

    #if the pedestrian "current" is moving to the encounter of "other", interactionLength will be bigger
    # and so will be the B parameter
    #B = gamma * interactionLength
     #if the pedestrian "current" is moving to the encounter of "other", the angle will be closer to 0
     # but be will be bigger, I didn't get why it's like that...
    #parameter = (B*thetaAngle)
    #get rid of sign
    #parameter = parameter*parameter

    #FIRST PART -distanceBeetweenPeds/B
    #the closer velocity are to the attraction force the bigger the interaction
    #the bigger the interaction the bigger the B
    #the bigger the B, the lower the "distanceBeetweenPeds/B"
    #the lower the "distanceBeetweenPeds/B" the bigger the force
    #so the bigger the B, the stronger the force,
    #so the bigger the distance, the lower the force
    #so the closer velocity are to the attraction force the bigger the force
    #SECOND PART
    #the bigger the angle the lower the force
    #the bigger the B the lower the force
    #

    #forceVelocityAmount = -exp(-distanceBeetweenPeds/B - (n_prime*n_prime*parameter))
    #return forceVelocityAmount*-1

    #forceAngleAmount = -thetaSign * exp(-distanceBeetweenPeds/B - (n*n*parameter))
    #return abs(forceVelocityAmount)/abs(forceAngleAmount)

    #return socialFuzzy(distanceBeetweenPeds,abs(thetaAngle),interactionLength)
    forceAmount = -socialFuzzy(distanceBeetweenPeds,abs(thetaAngle),lengthRelativeVelocity*2.0)
    percentilDeacceleration = fDeacce(forceAmount)
    #forceVelocityAmount = forceAmount #* 0.01
    #forceAngleAmount = forceVelocityAmount * 0.3

    forceVelocity = @multiplyFloat(interactionDirection, forceAmount * percentilDeacceleration)

    interactionDirectionLeft = Point(-interactionDirection.y, interactionDirection.x)

    #interactionDirectionLeft[1] =

    #interactionDirectionLeft[2] =
    forceAngle = @multiplyFloat(interactionDirectionLeft, forceAmount * thetaSign)

    result = @plus(forceVelocity,forceAngle)

    return result
    #=DistancePeds =  distanceBeetweenPeds
    angleVelocityPed1 = atan2Radians(current.velocity[2],current.velocity[1])
    angleVelocityPed2 = atan2Radians(other.velocity[2],other.velocity[1])
    differenceAngleVec = treatAngle(angleVelocityPed2-angleVelocityPed1)
    totalVelPed1 = lengthV(current.velocity)
    totalVelPed2  = lengthV(other.velocity)
    totalRelVelPed = lengthV(relativeVelocity)
    angleRelativeVelocity = atan2Radians(relativeVelocity[2],relativeVelocity[1])
    E = attractionDirection
    angleE = atan2Radians(attractionDirection[2],attractionDirection[1])
    interactionVector = interactionDirection
    angleInteractionVector = atan2Radians(interactionDirection[2],interactionDirection[1])
    relationForceAngle = percentilDeacceleration
    resultAngle = atan2Radians(result[2],result[1])

    return [DistancePeds,
    angleVelocityPed1,
    angleVelocityPed2,
    differenceAngleVec,
    totalVelPed1,
    totalVelPed2,
    relativeVelocity,
    totalRelVelPed,
    angleRelativeVelocity,
    E,
    angleE,
    interactionVector,
    angleInteractionVector,
    forceVelocity,
    forceAngle,
    relationForceAngle,
    result,
    resultAngle,
    thetaAngle / (2*pi),
    percentilAngle,
    differenceAngle/ (2*pi)]=#

end
function atan2Radians(y,x)
    atan2(y,x) / (2*pi)
end
function lengthV(vec)
    sqrt(dot(vec,vec))
end
function treatAngle(angle)
    if angle > pi
        angle = angle - 2*pi
    elseif angle < -pi
        angle = angle + 2*pi
    end
    return angle
end
