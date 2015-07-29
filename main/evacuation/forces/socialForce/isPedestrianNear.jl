const affectedLength = 4.0
function isPedestrianNear(currentPosition, anotherPosition)

    diffe = @minus(currentPosition,anotherPosition)

    distanceX = abs(diffe.x)
	distanteY = abs(diffe.y)

	return distanceX < affectedLength && distanteY < affectedLength
end
