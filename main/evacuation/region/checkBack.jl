function checkBack(pedestrian,regions,x, y,lengthX,lengthY)
	(x,y) = getBack(x,y)
	return checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
end