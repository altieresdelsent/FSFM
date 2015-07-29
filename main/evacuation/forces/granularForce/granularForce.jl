using JuliaFuzzy.Engine
function granularForce(position,anotherPosition,velocity,anotherVelocity, totalRadius = 0.4)
#granularForce Summary of this function goes here
#   Detailed explanation goes here
    normalElasticRestorationConstant = 1.2 * 10^5
    TangentialElasticRestorativeConstants = 2.4 * 10^5
    kn = normalElasticRestorationConstant
    kt = TangentialElasticRestorativeConstants

    relativePosition = @minus(position,anotherPosition)
    relativeVelocity = @minus(anotherVelocity,velocity)

    distance = @length(relativePosition)
    #print(distance)
    #print("\n")
    realDistance = totalRadius - distance
    if realDistance >= 0.0
        direction = @divideFloat(relativePosition,distance)
        tangentialDirection = Point(-direction.y,direction.x)
        ## it will have the length of the actual velocity if is 90 degrees for any side
        ## and none(zero) if its is exactly in the same direction approaching or moving away
        tangentialVelocity = @dot(relativeVelocity,tangentialDirection)
        vec1 = @multiplyFloat(direction,(realDistance*kn))
        vec2 = @multiplyFloat(tangentialDirection,(kt*realDistance*tangentialVelocity))
        return @plus(vec1,vec2)
    end
#print("\n saiu granularForce")
    return zeroVector
end

