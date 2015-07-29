function checkRegionPedestrian(pedestrian,regions,x,y,lengthX,lengthY)
	if y >= 1 && y <= lengthY && x >= 1 && x <= lengthX
		if isInRegion(pedestrian.position[1],pedestrian.position[2],regions[x,y])
			addPedestrianRegion!(regions[x,y],pedestrian)
			return true
		end
	end
	return false
end