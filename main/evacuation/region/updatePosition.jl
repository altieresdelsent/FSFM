using Distances
const distType = Euclidean()
function updatePosition(region::Region)
	lengthPedestrians = length(region.pedestrians)
	for i in 1:lengthPedestrians
		region.pedestriansPosition[:,i] = region.pedestrians[i].position
	end
	pairwise!(region.distancesPedestrians,distType,region.pedestriansPosition)
end
