using ..Trajectory.getNearestWayPoint
using ..Crowd

function createCrowd(pedestrians,wayPoints,obstacles)
    lengthPedestrians = length(pedestrians)
    wayPointsPed = [getNearestWayPoint(pedestrian.position,wayPoints,obstacles,[true for x in wayPoints]) for pedestrian in pedestrians]
    for i in 1:lengthPedestrians
        pedestrians[i].wayPoint = wayPointsPed[i]
    end

    return Crowd(pedestrians)
end
