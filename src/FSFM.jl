module FSFM
    export WayPoint, Objective, Obstacle, Pedestrian, PedestrianRegion, Scene, Point, Crowd,@minus
    abstract baseRegion

    include("compressLog.jl")
    include("Point.jl")

    include("WayPoint.jl")
    include("Objective.jl")

    #isdefined(:RegionRadian) || include("load/types/RegionRadian.jl")
    #isdefined(:isVisible) || include("visibility/isVisible.jl")
    #isdefined(:closestPoint) || include("forces/obstacleForce/closestPoint.jl")

    include("Obstacle.jl")
    #isdefined(:ObstacleCache) || include("types/ObstacleCache.jl")
    include("Pedestrian.jl")
    include("PedestrianRegion.jl")

    #isdefined(:Region) || include("load/types/Region.jl")
    include("Crowd.jl")
    include("Scene.jl")
    ##functions at the module
    include("isVisible.jl")

    include("Trajectory/src/Trajectory.jl")
    include("Load/src/Load.jl")
    include("Forces/src/Forces.jl")

    include("doEvacuation.jl")
    include("move.jl")
    include("movePedestrian.jl")
    include("saveLog.jl")

    include("plotScene.jl")

    x = Point(0.0,1.0)
    y = Point(0.0,1.0)

end
