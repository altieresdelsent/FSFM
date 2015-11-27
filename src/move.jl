
import .Trajectory.verifyTrajectory!
using JuliaFuzzy.Engine


function move!(scene,crowd,counter)

    n = length(crowd.pedestrians)
    #log = zeros(8,n)

    lengthPedCalc = 0.0
    #print("move")
    #@bp
    #checkRegionPedestrians(scene)
    #updateAllPositions(scene)
    i = 0
    waysPossibles = Array(Bool,length(scene.wayPoints))
    for pedestrian in crowd.pedestrians

        if !pedestrian.active
            continue
        end
        position = pedestrian.position
        #tic()
        lengthPedCalc = lengthPedCalc + movePedestrian!(pedestrian,crowd,scene)
        #print("\nmoveu pedestre")
        #toc()
        #now really move the agent
        #print("$id,")
        #tic()
        verifyTrajectory!(pedestrian,crowd,scene,waysPossibles,counter)
        #print("\nverificou trajetoria pedestre")
        #toc()
    end
    #print("\nsaiu looop\n")
    #crowd = Crowd(1,2,3,4)
    move!(crowd)
    #print("\nmoveu de verdade")
    #crowd = Crowd(tuple(newPositions...),tuple(newVelocities...),tuple(activesNew...),tuple(wayPointsPedNew...))
    #print("\ncriou crowd\n")

    #crowd = Crowd(tuple(newPositions...),tuple(newVelocities...),tuple(activesNew...)),tuple(wayPointsPedNew...)
    return lengthPedCalc
    #print("saiu move")
end

function move!(crowd::Crowd)
    for pedestrian in crowd.pedestrians
        if !pedestrian.active
            continue
        end
        pedestrian.position = pedestrian.newPosition
        pedestrian.velocity = pedestrian.newVelocity
    end
end
