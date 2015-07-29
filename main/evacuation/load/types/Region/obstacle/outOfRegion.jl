#using Debug
function outOfRegion(region::Region,obstacleCache::ObstacleCache)
	x = obstacleCache.point[1]
	y = obstacleCache.point[2]
    return !isInRegion(x,y,region)
end
