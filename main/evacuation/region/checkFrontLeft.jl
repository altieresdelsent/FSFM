function checkFrontLeft(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getFrontLeft(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end