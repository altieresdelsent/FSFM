using Gadfly
function plotScene(scene, point)
    plot([point.x], [point.y],"g.")

    for wayPoint in scene.wayPoints
        oplot([wayPoint.position.x],[wayPoint.position.y],"b.")
    end

    for objective in scene.objectives
        oplot([objective.position.x],[objective.position.y],"r.")
    end

    for obstacle in scene.obstacles
        oplot([obstacle.start.x,obstacle.ender.x],[obstacle.start.y,obstacle.ender.y],"k-")
    end
end
