using ..@minus
using ..@dot
using ..Point
using ..WayPoint

function preComputeWayPoints(wayPoints, objectives, obstacles)
  wayPointsProcessed = Array(WayPoint,0)
  wayPointsNotProcessed = wayPoints

  filter = vec(map(Bool,ones(1,length(wayPointsNotProcessed))))
  counter = 0
  for wayPoint in wayPoints
    counter = counter + 1
    addWay = false

    for objective = objectives

      if isVisible(wayPoint.position,obstacles,objective.position)
        addWay = true

        diffee =  @minus(wayPoint.position, objective.position)
        distanceSquared = @dot(diffee,diffee)
        filter[counter] = false
        distance = wayPoint.distance
        if wayPoint.distance > distanceSquared
            distance = distanceSquared
        end
        wayPoint = WayPoint(wayPoint.position,wayPoint.radius,1,distance)

        invisible = false
      end
    end

    if addWay
      push!(wayPointsProcessed,wayPoint)
    end
  end
  wayPointsNotProcessed = wayPointsNotProcessed[filter]
  deepnees = 1
  hasAnyLeft = true
  hasNew = true

  while hasAnyLeft && hasNew && deepnees < 99999
    counterLeft = 0
    hasNew = false
    deepnees = deepnees + 1
    lengthLeft = length(wayPointsNotProcessed)
    filter = vec(map(Bool,ones(1,length(wayPointsNotProcessed))))
    counter = 0
    hasAnyLeft = false

    for wayPoint in wayPointsNotProcessed
      hasAnyLeft = true
      counter = counter + 1
      addWay = false

      for objective in wayPointsProcessed
        obj = objective.position

        if isVisible(wayPoint.position,obstacles,obj)
          addWay = true
          hasNew = true
          diffee = @minus(wayPoint.position,obj)
          distanceSquared = @dot(diffee,diffee)+objective.distance
          filter[counter] = false
          distance = wayPoint.distance

          if wayPoint.distance > distanceSquared
            distance = distanceSquared
          end
          wayPoint = WayPoint(wayPoint.position,wayPoint.radius,deepnees,distance)

        end
      end

      if addWay
        push!(wayPointsProcessed,wayPoint)
      end
    end

    wayPointsNotProcessed = wayPointsNotProcessed[filter]
  end
  wayPoints = wayPointsProcessed
end
