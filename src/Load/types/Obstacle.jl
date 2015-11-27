using LinearFunc.LinearFunc2D
immutable Obstacle
    start::Point
    ender::Point
    funcCache::LinearFunc2D
    function Obstacle(start,ender)
        funcCache = LinearFunc2D(start.x,start.y,ender.x,ender.y)
        return new(start,ender,funcCache)
    end
end
