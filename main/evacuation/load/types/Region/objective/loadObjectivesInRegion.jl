isdefined(:isVisible) || include("../../../../visibility/isVisible.jl")
function loadObjectivesInRegion(region::Region, scene::Scene)
    for objective in scene.objectives
        x = objective.position[1]
        y = objective.position[2]
        if isInRegion(x,y,region) || isVisible(region.center,scene.obstacles,objective.position)
            push!(region.objectives,objective)
        end
    end
end
