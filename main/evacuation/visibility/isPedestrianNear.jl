const affectedLength = 4.0
function isPedestrianNear(currentPedestrian, another)
	if currentPedestrian == another
		return false
	elseif another.active && currentPedestrian.active 
		diffe = currentPedestrian.position - another.position
	    distanceX = abs(diffe[1])
	    distanteY = abs(diffe[2])
	    return distanceX < affectedLength && distanteY < affectedLength
	else
		return false
	end
end