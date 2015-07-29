function loadPedestriansInRegion(region::Region, scene::Scene)
    for pedestrian in scene.pedestrians
        x = pedestrian.position[1]
        y = pedestrian.position[2]
        if isInRegion(x,y,region)
            push!(region.pedestrians,pedestrian)
        end
    end
end
