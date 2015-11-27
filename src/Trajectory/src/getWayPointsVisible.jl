using ..isVisible
function getWayPointsVisible(eye,wayPoints, obstacles, waysPossibles)
    counter =  0
    lengthWays = length(wayPoints)
    for i in 1:lengthWays
        if waysPossibles[i] && !isVisible(eye,obstacles,wayPoints[i].position)
            waysPossibles[i] = false
        elseif waysPossibles[i]
            counter = counter + 1
        end
    end
    return counter
end
