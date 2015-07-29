function checkRight(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getRight(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end