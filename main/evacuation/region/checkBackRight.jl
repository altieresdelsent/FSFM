function checkBackRight(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getBackRight(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end