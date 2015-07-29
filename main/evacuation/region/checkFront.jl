function checkFront(pedestrian,regions,x,y,lengthX,lengthY)
	(x,y) = getFront(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end