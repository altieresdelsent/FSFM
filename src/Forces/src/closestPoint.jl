using ..@dot
using ..@multiplyFloat
using ..@minus
using ..@plus
using ..Point

function closestPoint(point, obstacle )
    startPoint = obstacle.start
    #print("startPoint:$startPoint\n")
    endPoint = obstacle.ender
    #print("endPoint:$endPoint\n")
    relativeEndPoint = @minus(endPoint,startPoint)
    #print("relativeEndPoint:$relativeEndPoint\n")
    relativePoint = @minus(point,startPoint)
    #print("relativePoint:$relativePoint\n")
    lambda = @dot(relativePoint,relativeEndPoint) / @dot(relativeEndPoint,relativeEndPoint)
    #print("lambda:$lambda\n")
    if lambda <= 0.0
        return startPoint
    elseif lambda >= 1.0
        return endPoint
    end

    result = @plus(startPoint,@multiplyFloat(relativeEndPoint,lambda))
    #print("result:$result\n")

end
