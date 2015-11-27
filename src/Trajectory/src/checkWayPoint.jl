import ..@minus
import ..@dot
function checkWayPoint(position, wayPoint)

    radiusWayPointSquared = wayPoint.radius
    radiusWayPointSquared = radiusWayPointSquared*radiusWayPointSquared

    distanceVec = @minus(position,wayPoint.position)
    distanceSquared = @dot(distanceVec,distanceVec)

    return radiusWayPointSquared > distanceSquared
end

function checkWayPoints(position, wayPoints, waysPossibles)
    lengthWays = length(wayPoints)

    counter = 0
    for i in 1:lengthWays
        wayPoint = wayPoints[i]

        distanceVec = @minus(position,wayPoint.position)
        distanceSquared = @dot(distanceVec,distanceVec)

        radiusWayPointSquared = wayPoint.radius
        radiusWayPointSquared = radiusWayPointSquared*radiusWayPointSquared

        if waysPossibles[i] && radiusWayPointSquared > distanceSquared
            waysPossibles[i] = false
        elseif waysPossibles[i]
            counter = counter + 1
        end
    end
    return counter
end
