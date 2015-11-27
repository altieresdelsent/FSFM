
isdefined(:isVisible) || include("isVisible.jl")
function getPedestriansVisible(currentPedestrian,obstacles,pedestrians)
    pedestriansTemp = Pedestrian[];
    for pedestrian in pedestrians
        if pedestrian.active && isVisible(currentPedestrian.position,obstacles,pedestrian.position) && (currentPedestrian != pedestrian)
            push!(pedestriansTemp,pedestrian)
        end
    end
    return pedestriansTemp
end
