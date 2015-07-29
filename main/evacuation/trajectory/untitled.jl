function closestPedestrian(pedestrianPosition,wayPoints,waysPossibles)
    min = realmax(Float64)
    lengthWays = length(ways)
    for i in 1:lengthWays
        way = ways[i]
        min = pedestrianPosition - way.position
        if waysPossibles[i] && way.distance < min
            min = way.distance
        end
    end
    counter =  0

    for i in 1:lengthWays
        if waysPossibles[i] && ways[i].distance != min
            waysPossibles[i] = false
        elseif waysPossibles[i]
            counter = counter + 1
        end
    end
    return counter
end
