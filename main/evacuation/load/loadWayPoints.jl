
using types
using LibExpat

#using Debug
function loadWayPoints(waypointsMatLab)
    (m,n) = size(waypointsMatLab)
    ways = waypointsMatLab
    retorno = Array(WayPoint,n)
    for i = 1:n
        retorno[i] = WayPoint(Point(ways[1,i], ways[2,i]),ways[3,i], ways[4,i],ways[5,i]);
    end
    return retorno
end

function loadWayPoints(waypointsXML::Array{ETree,1})
    retorno = Array(WayPoint,length(waypointsXML))
    i = 0
    for waypointXML in waypointsXML
    	i = i + 1
    	center = Point(parsefloat(waypointXML.attr["x"]), parsefloat(waypointXML.attr["y"]))
        retorno[i] = WayPoint(center,parsefloat(waypointXML.attr["r"]),0.0,realmax(typeof(0.0)));
    end
    return retorno
end
