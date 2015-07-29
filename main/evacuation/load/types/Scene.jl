using JuliaFuzzy.Engine
immutable Scene
    pedestriansRegions::Vector{PedestrianRegion}
    obstacles::Vector{Obstacle}
    wayPoints::Vector{WayPoint}
    objectives::Vector{Objective}
    engineObstacle::Function
    engineGranular::Function
    engineSocial::Function
    engineSocialDirection::Function
    engineSocialDeacceleration::Function
    engineDesiredAngle::Function
    engineDesiredVelocity::Function

    tic();
    for x in 1:60000
        a = tuple(vec(rand(1,3000)));
    end
    toc();
    #regions::Matrix{Region}
    function Scene()
        new()
    end
    function Scene(pedestriansRegions::Vector{PedestrianRegion},obstacles::Vector{Obstacle},wayPoints::Vector{WayPoint},objectives::Vector{Objective})


        engineObstacle = buildFuzzyObstacle()
        engineGranular = buildFuzzyGranular()
        engineSocial = buildFuzzySocial()
        engineSocialDirection = buildFuzzySocialDirection()
        engineSocialDeacceleration = buildFuzzySocialDeacceleration()
        engineDesiredAngle = buildFuzzyDesiredAngle()
        engineDesiredVelocity = buildFuzzyDesiredVelocity()

        #if(typeof(pedestriansRegions) == Array{Point,1})
        #    pedestriansRegions = tuple(pedestriansRegions...)
        #end

        #if(typeof(obstacles) == Array{Point,1})
        #    obstacles = tuple(obstacles...)
        #end

        #if(typeof(wayPoints) == Array{Point,1})
        #    wayPoints = tuple(wayPoints...)
        #end

        #if(typeof(objectives) == Array{Point,1})
        #    objectives = tuple(objectives...)
        #end

        #if(typeof(pedestrians) == Array{Point,1})
        #    pedestrians = tuple(pedestrians...)
        #end

        #here.regions = getRegionCoordinate(here)
        return new(pedestriansRegions,obstacles,wayPoints,objectives,engineObstacle,engineGranular,engineSocial,engineSocialDirection, engineSocialDeacceleration,engineDesiredAngle,engineDesiredVelocity)
    end
end

isdefined(:getRegionCoordinate) || include("Region/getRegionCoordinate.jl")
isdefined(:buildFuzzyObstacle) || include("buildFuzzy/buildFuzzyObstacle.jl")
isdefined(:buildFuzzyGranular) || include("buildFuzzy/buildFuzzyGranular.jl")
isdefined(:buildFuzzySocial) || include("buildFuzzy/buildFuzzySocial.jl")
isdefined(:buildFuzzySocialDirection) || include("buildFuzzy/buildFuzzySocialDirection.jl")
isdefined(:buildFuzzySocialDeacceleration) || include("buildFuzzy/buildFuzzySocialDeacceleration.jl")
isdefined(:buildFuzzyDesiredAngle) || include("buildFuzzy/buildFuzzyDesiredAngle.jl")
isdefined(:buildFuzzyDesiredVelocity) || include("buildFuzzy/buildFuzzyDesiredVelocity.jl")
