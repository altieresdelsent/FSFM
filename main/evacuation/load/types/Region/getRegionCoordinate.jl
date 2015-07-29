isdefined(:getMaxCoordinate) || include("getMaxCoordinate.jl")
isdefined(:getMinCoordinate) || include("getMinCoordinate.jl")
isdefined(:isInRegion) || include("isInRegion.jl")

isdefined(:loadObjectivesInRegion) || include("objective/loadObjectivesInRegion.jl")
#isdefined(:loadObstaclesInRegion) || include("obstacle/loadObstaclesInRegion.jl")
isdefined(:loadPedestriansInRegion) || include("pedestrian/loadPedestriansInRegion.jl")
isdefined(:loadWaypointsInRegion) || include("waypoint/loadWaypointsInRegion.jl")
#using Debug
using Distances
const distType = Euclidean()
function getRegionCoordinate(scene::Scene)
    xMax = getMaxCoordinate(scene.obstacles,1)
    yMax = getMaxCoordinate(scene.obstacles,2)

    xMin = getMinCoordinate(scene.obstacles,1)
    yMin = getMinCoordinate(scene.obstacles,2)

    rangeX = xMax - xMin
    rangeY = yMax - yMin

    regionsX = convert(Int64,round(rangeX / 4.0))
    regionsY = convert(Int64,round(rangeY / 4.0))

    lengthX = rangeX / regionsX
    lengthY = rangeY / regionsY
    regions = Array(Region,regionsX,regionsY)
    #print(size(regions))
    for x in 1:regionsX
        for y in 1:regionsY
            xStart = xMin + ((x-1)*lengthX)
            xEnd=  xMin + (x*lengthX)

            yStart = yMin + ((y-1)*lengthY)
            yEnd = yMin + (y*lengthY)

            region = Region(xStart,yStart,xEnd,yEnd)


            regions[x,y] = region
            loadPedestriansInRegion(region,scene)
            loadWaypointsInRegion(region,scene)
            loadObjectivesInRegion(region,scene)
            #@bp x == 7 && y == 7
            #loadObstaclesInRegion(region,scene)
            lengthPedestrians = length(region.pedestrians)
            region.pedestriansPosition = Array(Float64,2,length(region.pedestrians))
            for i in 1:length(region.pedestrians)
                region.pedestriansPosition[:,i] = region.pedestrians[i].position
            end
            region.distancesPedestrians = zeros(lengthPedestrians,lengthPedestrians)
            pairwise!(region.distancesPedestrians,distType,region.pedestriansPosition)

        end
    end
    return regions
end
