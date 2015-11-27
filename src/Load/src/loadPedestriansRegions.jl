using ..Point
using ..PedestrianRegion
using LibExpat

function loadPedestriansRegions(pedestriansRegions)
    (m,n) = size(pedestriansRegions)
    regions = pedestriansRegions
    retorno = Array(PedestrianRegion,n)
    for i = 1:n
        retorno[i] = PedestrianRegion(Point(regions[1,i], regions[2,i]),regions[3,i], regions[4,i],regions[5,i]);
    end
    return retorno
end

function loadPedestriansRegions(pedestrianRegionXML::Array{ETree,1})
    retorno = Array(PedestrianRegion,length(pedestrianRegionXML))
    i = 0
    for regionXML in pedestrianRegionXML
    	i = i + 1
    	x = parse(Float64,regionXML.attr["x"])
    	y = parse(Float64,regionXML.attr["y"])
    	dx = parse(Float64,regionXML.attr["dx"])
    	dy = parse(Float64,regionXML.attr["dy"])
    	n = parse(Int64,regionXML.attr["n"])

        retorno[i] = PedestrianRegion(Point(x,y),dx,dy,n);
    end
    return retorno
end
