#using Debug
function isOutsideAllRegionRadian(obstaclesCache::Vector{ObstacleCache},regionTest::RegionRadian)
    for obstacleCache in obstaclesCache
        if isInsideRegionRadian(obstacleCache.regionRadian,regionTest)
            return false
        end
    end
    return true
end
