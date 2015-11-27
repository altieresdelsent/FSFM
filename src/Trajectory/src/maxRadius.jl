using ..WayPoint

function maxRadius(ways::Vector{WayPoint}, waysPossibles::Vector{Bool})
    max = realmin(Float64)

    lengthWays = length(ways)

    for i in 1:lengthWays
        way = ways[i]
        if waysPossibles[i] && way.radius > max
            max = way.radius
        end
    end

    max = max * 0.99;
    counter = 0

    for i in 1:lengthWays
        if waysPossibles[i] && ways[i].radius < max
            waysPossibles[i] = false
        elseif waysPossibles[i]
            counter = counter + 1
        end
    end
    return counter
end
