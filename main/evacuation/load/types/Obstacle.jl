immutable Obstacle
    start::Point
    ender::Point
    funcCache::LinearFunc
    function Obstacle(start,ender)
        funcCache = LinearFunc(start.x,start.y,ender.x,ender.y)
        return new(start,ender,funcCache)
    end
end
