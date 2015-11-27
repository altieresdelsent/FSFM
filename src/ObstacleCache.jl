type ObstacleCache
    obstacle::Obstacle
    point::Vector{Float64}
    pointFunc::LinearFunc
    distance::Float64
    startDist::Float64
    startFunc::LinearFunc
    enderDist::Float64
    enderFunc::LinearFunc
    regionRadian::RegionRadian
end
