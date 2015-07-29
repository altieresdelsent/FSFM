using types
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
    	x = parsefloat(regionXML.attr["x"])
    	y = parsefloat(regionXML.attr["y"])
    	dx = parsefloat(regionXML.attr["dx"])
    	dy = parsefloat(regionXML.attr["dy"])
    	n = parseint(regionXML.attr["n"])

        retorno[i] = PedestrianRegion(Point(x,y),dx,dy,n);
    end
    return retorno
end
