function checkLeft(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getLeft(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end