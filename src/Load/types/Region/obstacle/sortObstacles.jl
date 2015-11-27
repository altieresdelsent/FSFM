#using Debug
function sortObstacles!(obstacles::Vector{ObstacleCache})
    sort!(obstacles,by=transformObstacleCache)
end
