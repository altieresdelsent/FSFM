isdefined(:getNearestWayPoint) || include("../trajectory/getNearestWayPoint.jl")
using types
function createCrowd(pedestrians,wayPoints,obstacles)
    lengthPedestrians = length(pedestrians)
    wayPointsPed = [getNearestWayPoint(pedestrian.position,wayPoints,obstacles,[true for x in wayPoints]) for pedestrian in pedestrians]
    for i in 1:lengthPedestrians
        pedestrians[i].wayPoint = wayPointsPed[i]
    end

    return types.Crowd(pedestrians)
end
