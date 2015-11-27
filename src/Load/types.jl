    # types.jl

#
isdefined(:JuliaFuzzy) || include("../JuliaFuzzy/JuliaFuzzy.jl")

macro minus(arg1, arg2)
    :(Point($arg1.x - $arg2.x, $arg1.y - $arg2.y))
end

macro plus(arg1, arg2)
    :(Point($arg1.x + $arg2.x, $arg1.y + $arg2.y))
end

macro multiply(arg1, arg2)
    :(Point($arg1.x * $arg2.x, $arg1.y * $arg2.y))
end

macro multiplyFloat(arg1, arg2)
    :(Point($arg1.x * $arg2, $arg1.y * $arg2))
end

macro dot(arg1, arg2)
    :($arg1.x * $arg2.x + $arg1.y * $arg2.y)
end

macro length(arg1)
    :(sqrt($arg1.x * $arg1.x + $arg1.y * $arg1.y))
end

macro divideFloat(arg1, arg2)
    :(Point($arg1.x / $arg2, $arg1.y / $arg2))
end

macro isPointNan(arg1)
    :(isnan($arg1.x) || isnan($arg1.y))
end

module types

    using JuliaFuzzy.Engine
    #using Debug
    export WayPoint, Objective, Obstacle, ObstacleCache, Pedestrian, Scene, Region, PedestrianRegion, Point, Crowd
    abstract baseRegion

    isdefined(:Point) || include("types/Point.jl")

    isdefined(:WayPoint) || include("types/WayPoint.jl")
    isdefined(:Objective) || include("types/Objective.jl")

    isdefined(:RegionRadian) || include("types/RegionRadian.jl")
    isdefined(:isVisible) || include("../visibility/isVisible.jl")
    isdefined(:closestPoint) || include("../forces/obstacleForce/closestPoint.jl")

    isdefined(:Obstacle) || include("types/Obstacle.jl")
    isdefined(:ObstacleCache) || include("types/ObstacleCache.jl")
    isdefined(:Pedestrian) || include("types/Pedestrian.jl")
    isdefined(:PedestrianRegion) || include("types/PedestrianRegion.jl")

    isdefined(:Region) || include("types/Region.jl")
    isdefined(:Crowd) || include("types/Crowd.jl")
    isdefined(:Scene) || include("types/Scene.jl")
    isdefined(:plotScene) || include("types/plotScene.jl")
end


