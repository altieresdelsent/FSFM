using Winston
#include("desiredForce.jl")
#include("evacuation/forces/desiredForce/desiredForce.jl")
include("../../JuliaFuzzy/JuliaFuzzy.jl")
include("../../load/types/buildFuzzy/buildFuzzyDesiredAngle.jl")
include("../../load/types/buildFuzzy/buildFuzzyDesiredVelocity.jl")
angleFunc = buildFuzzyDesiredAngle()
velocityFunc = buildFuzzyDesiredVelocity()
using Winston
function plotDesired()
    way = rand(2)
    velocity = [1.2,1.2]
    ped = rand(2)
    plotDesired(ped,way,velocity)
end
function plotDesired(pedestrian,wayPoint,velocity)
    force = desiredForce(pedestrian,wayPoint,velocity,velocityFunc,angleFunc)

    plot([pedestrian[1]], [pedestrian[2]],"ro",
         [wayPoint[1]], [wayPoint[2]],"go",
         [pedestrian[1],velocity[1]+pedestrian[1]], [pedestrian[2],velocity[2]+pedestrian[2]],"b-",
         [pedestrian[1],force[1]+velocity[1]+pedestrian[1]], [pedestrian[2],force[2]+velocity[2]+pedestrian[2]],"r-",
         [0,0,4,4],[0,4,0,4],"g.")
    #oplot(x=[vec[1],ped[1]],y=[vec[2],ped[2]])
end
function desiredForce( pedPosition,wayPoint,velocity, desiredFuzzyVelocity, desiredFuzzyAngle)
desiredFuzzyDesiredVelocity
    ped = pedPosition
    way = wayPoint
    vMax = 1.2

    vecDirection = way - ped
    print("vecDirection=$vecDirection \n")

    print("sqrt(dot(velocity,velocity))=$(sqrt(dot(velocity,velocity))) \n")
    differenceVelocity = (sqrt(dot(velocity,velocity)) / vMax) - 1
    print("differenceVelocity=$differenceVelocity \n")
    angleDirection = atan2(vecDirection[1],vecDirection[2])
    print("angleDirection=$angleDirection \n")
    angleVelocity = (velocity[1] != 0.0 || velocity[2] != 0.0) ? atan2(velocity[1],velocity[2]) : angleDirection
    print("angleVelocity=$angleVelocity \n")
    differenceAngle = angleVelocity - angleDirection
    if differenceAngle > pi
        differenceAngle = differenceAngle - 2*pi
    elseif differenceAngle < -pi
        differenceAngle = differenceAngle + 2*pi
    end
    print("differenceAngle=$differenceAngle \n")
    print("differenceVelocity=$differenceVelocity \n")
    #-pi = left | pi = right
    force = desiredFuzzyVelocity(differenceVelocity)
    angleTurn = desiredFuzzyAngle(differenceAngle)
    print("force=$force \n")
    print("angleTurn=$angleTurn \n")
    angleFinal = angleTurn + angleVelocity
    angleFinal = (angleFinal > pi)? angleFinal - 2pi:(angleFinal < -pi)? angleFinal + 2pi:angleFinal
    print("angleFinal=$angleFinal \n")
    nextIdeal = [sin(angleFinal),cos(angleFinal)]*((force*vMax)+vMax)
    print("nextIdeal=$nextIdeal \n")
    print("velocity=$velocity \n")
    return nextIdeal - velocity
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
