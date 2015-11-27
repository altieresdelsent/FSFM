#using Debug
function getBelowObstacleClockwise(obstaclesClockwise::Vector{ObstacleCache},region::Region, obstacletTest::ObstacleCache,obstaclesCache::Vector{ObstacleCache},index::Int64, angleStart::Float64, finalDistance = -1.0)
    angleEnder = obstacletTest.regionRadian.ender
    maxObstacle = obstacletTest
    addSortedObstacle!(obstaclesClockwise,obstacletTest)
    #obstaclesClockwise = ObstacleCache[obstacletTest]
    if angleEnder == angleStart
        return obstaclesClockwise
    end
    regionRadianSearch = RegionRadian(angleStart,angleEnder);
    if finalDistance == -1
        finalDistance = obstacletTest.enderDist
    end
    lengthObstacleCache = length(obstaclesCache)
    if index <= lengthObstacleCache
        for i in index:lengthObstacleCache
            obstacleCache = obstaclesCache[i]
            #check obstacles inside de circle..
            if obstacleCache.distance >= finalDistance
                break
            end
            if isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian) && isVisibleCache(obstacleCache.pointFunc,obstaclesClockwise)
                #    getEncounterPoint
                addSortedObstacle!(obstaclesClockwise,obstacleCache)
                # if eventualy this 
                nexts = getNextClockwise(region,obstaclesCache,obstacleCache.regionRadian.ender,i+1, finalDistance)
                
                for newObstacle in nexts
                    indexNew = searchsortedfirst(obstaclesCache,newObstacle,by=transformObstacleCache)
                    getBelowObstacleClockwise(obstaclesClockwise,region,obstacleCache,obstaclesCache,indexNew+1,angleStart, finalDistance)
                end
            
            elseif (isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian.ender) || isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian.start)) && isVisibleCache(obstacleCache.pointFunc,obstaclesClockwise)
                getBelowObstacleClockwise(obstaclesClockwise,region,obstacleCache,obstaclesCache,i+1,angleStart)
                
                nexts = getNextClockwise(region,obstaclesCache,obstacleCache.regionRadian.ender,i+1)

                for newObstacle in nexts
                    indexNew = searchsortedfirst(obstaclesCache,newObstacle,by=transformObstacleCache)
                    getBelowObstacleClockwise(obstaclesClockwise,region,obstacleCache,obstaclesCache,indexNew+1,angleStart)
                end

                
            end
        end
    end
    return obstaclesClockwise
end
