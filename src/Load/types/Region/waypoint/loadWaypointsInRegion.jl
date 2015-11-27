function loadWaypointsInRegion(region::Region, scene::Scene)
    for wayPoint in scene.wayPoints
        x = wayPoint.position[1]
        y = wayPoint.position[2]
        if isInRegion(x,y,region) || isVisible(region.center,scene.obstacles,wayPoint.position)
            push!(region.wayPoints,wayPoint)
        end
    end
end
