isdefined(:checkWayPoint) || include("checkWayPoint.jl")
isdefined(:checkObjective) || include("checkObjective.jl")
isdefined(:getNearestWayPoint) || include("getNearestWayPoint.jl")
function verifyTrajectory!(pedestrian,crowd,scene,waysPossibles,counter)
    waysPossibles[:] = true
    #position = currentPedestrian.position
    wayPoints = scene.wayPoints
    obstacles = scene.obstacles
    objectives = scene.objectives

    localObjectiveAcomplished = checkWayPoint(pedestrian.position,pedestrian.wayPoint)
    wayIsInvisible = !isVisible(pedestrian.position,obstacles,pedestrian.wayPoint.position)

    if(localObjectiveAcomplished)||(wayIsInvisible)|| (counter % 100) == 0

        pedestrian.active = !checkObjective(pedestrian.position,objectives)

        if pedestrian.active
            pedestrian.wayPoint = getNearestWayPoint(pedestrian.position,wayPoints,obstacles,waysPossibles)
        end
    end
    #return currentPedestrian
end
