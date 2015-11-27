
const regionsAround = ((x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y),(x,y) -> (x,y))
const affectLength = 4.0
function getPedestriansNear(currentPedestrian,pedestriansVisible)
    pedestriansNear = [];

    #affectLengthSquared = affectLength^2;
    pedestriansNearTemp = Pedestrian[];

    for ped in pedestriansVisible
        if !ped.active
            continue
        end

        if ped == currentPedestrian
            continue
        end

        diffe = currentPedestrian.position - ped.position
        distanceX = abs(diffe[1])
        distanteY = abs(diffe[2])
        if distanceX > affectLength || distanteY > affectLength
            continue
        end

        push!(pedestriansNearTemp,ped)
    end
    return pedestriansNearTemp
end
function getPedestriansNear(scene::Scene,xRegion::Int64,yRegion::Int64,lengthX::Int64,lengthY::Int64)
    #affectLengthSquared = affectLength^2;
    pedestriansNearTemp = Array(Pedestrian,0);
    #(lengthX,lengthY) = size(scene.regions)
    for getRegion in regionsAround
        (x,y) = getRegion(xRegion,yRegion)
        if x >= 1 && x <= lengthX && y >= 1 && y <= lengthY
            region = scene.regions[x,y]
        else
            continue
        end
        #distances = region.distancesPedestrians
        #currentIndex = findfirst(region.pedestrians,currentPedestrian)
        #filterPedestrians = ped -> ped.active && ped != currentPedestrian && distances[currentPedestrian.id, ped.id] < affectLength
        #pedsFiltered = #filter(filterPedestrians,region.pedestrians)
        push!(pedestriansNearTemp,region.pedestrians...)
    end
    return pedestriansNearTemp
end
