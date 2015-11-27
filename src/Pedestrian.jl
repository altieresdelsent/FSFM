type Pedestrian#{t <: baseRegion}
    id::Int64
    maxVelocity::Float64
    position::Point
    velocity::Point
    active::Bool
    wayPoint::WayPoint
    newPosition::Point
    newVelocity::Point
    socialForce::Point
    desiredForce::Point
    obstacleForce::Point
    socialGranular::Point
    obstacleGranular::Point
    #region::t
    function Pedestrian(id,maxVelocity,positon, velocity,active)
        ttt = new(id,maxVelocity,positon, velocity,active)
        return ttt
    end
end
