function addPedestrianRegion!(region,pedestrian)
	push!(region.pedestrians,pedestrian)
	region.pedestriansPosition = [region.pedestriansPosition pedestrian.position]
	(lengthDistance,nothingd) = size(region.distancesPedestrians)
	region.distancesPedestrians = [[region.distancesPedestrians] ones(lengthDistance,1);  ones(1,lengthDistance+1)]
end