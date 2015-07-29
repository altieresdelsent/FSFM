function deletePedestrianRegion!(region,pedestrian,index)
	select = trues(length(region.pedestrians))
	deleteat!(region.pedestrians, index)
	select[index] = false
	#@bp
	region.pedestriansPosition = region.pedestriansPosition[:,select]
	region.distancesPedestrians = region.distancesPedestrians[select,select]
end