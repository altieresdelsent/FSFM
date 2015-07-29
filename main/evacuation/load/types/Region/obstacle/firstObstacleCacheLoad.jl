#using Debug

function firstObstacleCacheLoad(region::Region, obstaclesSorted::Vector{ObstacleCache})
	 #@bp
	 obstaclesFirstLoad = ObstacleCache[]
	 for obstacleCache in obstaclesSorted
	 	if outOfRegion(region,obstacleCache)
	 		if isVisibleCache(obstacleCache.pointFunc,obstaclesSorted) || isVisibleCache(obstacleCache.startFunc,obstaclesSorted) || isVisibleCache(obstacleCache.enderFunc,obstaclesSorted) 
		 		push!(obstaclesFirstLoad,obstacleCache)
		 	end
	 	else
	 		push!(region.obstacles,obstacleCache)
	 	end
	 end
	 return obstaclesFirstLoad
end