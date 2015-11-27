type Region <: baseRegion
    xStart::Float64
    yStart::Float64
    xEnd::Float64
    yEnd::Float64

    center::Vector{Float64}
    pedestrians::Vector{Pedestrian}
    pedestriansNear::Vector{Pedestrian}
    obstacles::Vector{ObstacleCache}
    wayPoints::Vector{WayPoint}
    objectives::Vector{Objective}
    pedestriansPosition::Matrix{Float64}
    distancesPedestrians::Matrix{Float64}
    function Region(xStart,yStart,xEnd,yEnd)
        here = new(xStart,yStart,xEnd,yEnd)
        here.center = [here.xStart + ((here.xEnd - here.xStart) / 2), here.yStart + ((here.yEnd - here.yStart) / 2)]
        here.pedestrians = Array(Pedestrian,0)
        here.pedestriansNear = Array(Pedestrian,0)
        here.obstacles = Array(ObstacleCache,0)
        here.wayPoints = Array(WayPoint,0)
        here.objectives = Array(Objective,0)
        here.pedestriansPosition = Array(Float64,0,0)
        here.distancesPedestrians = Array(Float64,0,0)
        return here
    end
end
