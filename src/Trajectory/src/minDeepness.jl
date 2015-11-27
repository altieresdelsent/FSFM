#return if there is only one in minDeepness
using ..WayPoint
function minDeepness(ways::Vector{WayPoint}, waysPossibles::Vector{Bool})
    min = realmax(Float64)
    lengthWays = length(ways)
    for i in 1:lengthWays
        way = ways[i]
        if waysPossibles[i] && way.deepness < min
            min = way.deepness
        end
    end

    counter =  0

    for i in 1:lengthWays
        if  waysPossibles[i] && ways[i].deepness != min
            waysPossibles[i] = false
        elseif waysPossibles[i]
            counter = counter + 1
        end
    end
    return counter
end
