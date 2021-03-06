using ..Point
using ..Pedestrian
using ..WayPoint

using LibExpat
#using Debug
function loadPedestrians(pedestriansMatLab)
    (m,n) = size(pedestriansMatLab)
    peds = pedestriansMatLab
    retorno = Array(Pedestrian,n)
    for i = 1:n
        retorno[i] = Pedestrian(i,peds[5,i],Point(peds[1,i], peds[2,i]),Point(peds[3,i], peds[4,i]), true)
    end
    return retorno
end

function loadPedestrians(pedestriansXML::Array{ETree,1})
    way = WayPoint(Point(0.0, 0.0), 0.0, 0.0, 0.0)
    meanMaxVelocity = 1.2;
    standardDeviationMaxVelocity = 0.2;

    counter = 0
    total = 0
    for pedestrianXML in pedestriansXML
        total = total + parse(Int64,pedestrianXML.attr["n"])
    end
    retorno = Array(Pedestrian,total)

    for pedestrianXML in pedestriansXML
    	x = parse(Float64,pedestrianXML.attr["x"])
    	y = parse(Float64,pedestrianXML.attr["y"])
    	dx = parse(Float64,pedestrianXML.attr["dx"])
    	dy = parse(Float64,pedestrianXML.attr["dy"])
    	n = parse(Int64,pedestrianXML.attr["n"])
    	minX = x - (dx/2)
    	minY = y - (dy/2)

	    for i = 1:n
            counter = counter + 1
            xPed  = minX + rand()*dx
            yPed = minY + rand()*dy
            maxVelocity = randn()*standardDeviationMaxVelocity +meanMaxVelocity
            ped = Pedestrian(counter,maxVelocity,Point(xPed,yPed),Point(0.0, 0.0), true)

	        retorno[counter] = ped
	    end
    end
    return (retorno)
end
