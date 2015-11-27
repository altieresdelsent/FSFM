using ..Point

function getFirst(wayPoints,waysPossibles)
    lengthWays = length(wayPoints)
    for i in 1:lengthWays
        if waysPossibles[i]
            return wayPoints[i]
        end
    end
end
function getNearestWayPoint(position,wayPoints,obstacles,waysPossibles)

    counterOK = getWayPointsVisible(position,wayPoints, obstacles, waysPossibles)
    if counterOK == 1
        return getFirst(wayPoints,waysPossibles)
    elseif counterOK == 0
        #warn("Fail to get new waypoint in getWayPointsVisible, impossible to continue.$position")
        return WayPoint(Point(position.x + rand(),position.y + rand()),0.2,0,0)
    end
    #print("getWayPointsVisible =  counterOK:$counterOK \n")

    counterOK = checkWayPoints(position,wayPoints,waysPossibles)
    if counterOK == 1
        return getFirst(wayPoints,waysPossibles)
    elseif counterOK == 0
        error("Fail to get new waypoint in checkWayPoints, impossible to continue.")
    end
    #print("checkWayPoints =  counterOK:$counterOK \n")

    counterOK = minDeepness(wayPoints, waysPossibles)
    if counterOK == 1
        return getFirst(wayPoints,waysPossibles)
    elseif counterOK == 0
        error("Fail to get new waypoint in minDeepness, impossible to continue.")
    end
    #print("minDeepness =  counterOK:$counterOK \n")

    counterOK = minDistance(wayPoints, waysPossibles)
    if counterOK == 1
        return getFirst(wayPoints,waysPossibles)
    elseif counterOK == 0
        error("Fail to get new waypoint in minDistance, impossible to continue.")
    end

    #print("minDistance =  counterOK:$counterOK \n")

    counterOK = maxRadius(wayPoints, waysPossibles)
    if counterOK == 1
        return getFirst(wayPoints,waysPossibles)
    elseif counterOK == 0
        error("Fail to get new waypoint in maxRadius, impossible to continue.")
    else
        #warn("maxRadius should have return only one.")
        return getFirst(wayPoints,waysPossibles)
    end

    #print("maxRadius =  counterOK:$counterOK \n")

    #print("\n\n\n")

end

