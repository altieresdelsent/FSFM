function checkBackLeft(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getBackLeft(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end