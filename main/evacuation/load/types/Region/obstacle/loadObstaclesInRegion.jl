isdefined(:addSortedObstacle) || include("addSortedObstacle.jl")
isdefined(:addSortedObstacles) || include("addSortedObstacles.jl")
isdefined(:transformObstacleCache) || include("transformObstacleCache.jl")
isdefined(:hasObstacleCache) || include("hasObstacleCache.jl")
isdefined(:isInsideRegionRadian) || include("isInsideRegionRadian.jl")
isdefined(:isOutsideAllRegionRadian) || include("isOutsideAllRegionRadian.jl")
isdefined(:isOutsideAnyRegionRadian) || include("isOutsideAnyRegionRadian.jl")
isdefined(:isVisibleCache) || include("isVisibleCache.jl")
isdefined(:loadObstaclesCache) || include("loadObstaclesCache.jl")
isdefined(:outOfRegion) || include("outOfRegion.jl")
isdefined(:sortObstacles) || include("sortObstacles.jl")
isdefined(:treatAngle) || include("treatAngle.jl")
isdefined(:firstObstacleCacheLoad) || include("firstObstacleCacheLoad.jl")

#JUST FOR TEST
isdefined(:plotObstaclesRegion) || include("test/plotObstaclesRegion.jl")
isdefined(:plotAllRegions) || include("test/plotAllRegions.jl")

isdefined(:getObstaclesClockwise) || include("clockwise/getObstaclesClockwise.jl")
isdefined(:getObstaclesAntiClockwise) || include("antiClockwise/getObstaclesAntiClockwise.jl")
#using Debug
function loadObstaclesInRegion(region::Region, scene::Scene)

    #@bp
    
    obstaclesCache = loadObstaclesCache(region,scene)
    #print(obstaclesCache)
    sortObstacles!(obstaclesCache)

    region.obstacles = obstaclesCache

    #need more test before release
    #firstLoadVisibles = firstObstacleCacheLoad(region,obstaclesCache)
    
    #obstaclesClockwise = getObstaclesClockwise(region,obstaclesCache,copy(firstLoadVisibles))
    
    #obstaclesAntiClockwise = getObstaclesAntiClockwise(region,obstaclesCache,copy(firstLoadVisibles))
   
    #addSortedObstacles!(region.obstacles, firstLoadVisibles)
    
    #addSortedObstacles!(region.obstacles, obstaclesAntiClockwise)

end
