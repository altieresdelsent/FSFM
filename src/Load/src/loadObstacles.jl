using ..Point
using ..Obstacle
using LibExpat

function loadObstacles(obstaclesMatLab)
    (m,n) = size(obstaclesMatLab)
    obstacles = obstaclesMatLab
    retorno = Array(Obstacle,n)
    for i = 1:n
        retorno[i] = Obstacle(Point(obstacles[1,i],obstacles[2,i]),Point(obstacles[3,i],obstacles[4,i]));
    end
    return retorno #adjustObstaclesCrossingOneAnother(retorno)
end

function loadObstacles(obstaclesXML::Array{ETree,1})
    n = length(obstaclesXML)
    retorno = Array(Obstacle,n)
    counter = 0
    for obstacleXML in obstaclesXML
        counter = counter + 1
    	start = Point(parse(Float64,obstacleXML.attr["x1"]),parse(Float64,obstacleXML.attr["y1"]))
    	ender = Point(parse(Float64,obstacleXML.attr["x2"]),parse(Float64,obstacleXML.attr["y2"]))
        retorno[counter] = Obstacle(start,ender)
    end
    return retorno #adjustObstaclesCrossingOneAnother(retorno)
end
