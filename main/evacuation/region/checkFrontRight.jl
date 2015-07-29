function checkFrontRight(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getFrontRight(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end