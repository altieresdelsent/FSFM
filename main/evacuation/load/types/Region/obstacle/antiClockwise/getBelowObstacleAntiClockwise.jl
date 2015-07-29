#using Debug
function getBelowObstacleAntiClockwise(obstacletTest::ObstacleCache,obstaclesCache::Vector{ObstacleCache},index::Int64, angleEnder::Float64)
    angleStart = obstacletTest.regionRadian.start
    maxObstacle = obstacletTest
    addSortedObstacle!(obstaclesAntiClockwise,obstacletTest)
    #obstaclesClockwise = ObstacleCache[obstacletTest]
    if angleEnder == angleStart
        return obstaclesAntiClockwise
    end
    regionRadianSearch = RegionRadian(angleStart,angleEnder);
    if finalDistance == -1
        finalDistance = obstacletTest.startDist
    end
    lengthObstacleCache = length(obstaclesCache)
    if index <= lengthObstacleCache
        for i in index:lengthObstacleCache
            obstacleCache = obstaclesCache[i]
            #check obstacles inside de circle..
            if obstacleCache.distance >= finalDistance
                break
            end
            if isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian) && isVisibleCache(obstacleCache.pointFunc,obstaclesAntiClockwise)
                #    getEncounterPoint
                addSortedObstacle!(obstaclesAntiClockwise,obstacleCache)
                # if eventualy this 
                nexts = getNextAntiClockwise(region,obstaclesCache,obstacleCache.regionRadian.ender,i+1, finalDistance)
                
                for newObstacle in nexts
                    indexNew = searchsortedfirst(obstaclesCache,newObstacle,by=transformObstacleCache)
                    getBelowObstacleAntiClockwise(obstaclesAntiClockwise,region,obstacleCache,obstaclesCache,indexNew+1,angleEnder, finalDistance)
                end
            
            elseif (isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian.ender) || isInsideRegionRadian(regionRadianSearch,obstacleCache.regionRadian.start)) && isVisibleCache(obstacleCache.pointFunc,obstaclesAntiClockwise)
                getBelowObstacleAntiClockwise(obstaclesAntiClockwise,region,obstacleCache,obstaclesCache,i+1,angleEnder)
                
                nexts = getNextAntiClockwise(region,obstaclesCache,obstacleCache.regionRadian.ender,i+1)

                for newObstacle in nexts
                    indexNew = searchsortedfirst(obstaclesCache,newObstacle,by=transformObstacleCache)
                    getBelowObstacleAntiClockwise(obstaclesAntiClockwise,region,obstacleCache,obstaclesCache,indexNew+1,angleEnder)
                end

                
            end
        end
    end
    return obstaclesClockwise
end
