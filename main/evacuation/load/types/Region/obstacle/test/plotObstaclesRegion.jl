using Gadfly
isdefined(:hasObstacleCache) || include("../hasObstacleCache.jl")
function plotObstaclesRegion(region::Region, scene::Scene)
	xsRegion = [region.xStart,region.xStart,region.xEnd,region.xEnd]
	ysRegion =  [region.yStart,region.yEnd,region.yEnd,region.yStart]

	xsRegion2 = [region.xEnd,region.xStart]
	ysRegion2 =  [region.yStart,region.yStart]
	plotLayers = layer(x=xsRegion,y=ysRegion,Geom.line,Theme(default_color=color("red")))
	plotLayers2 = layer(x=xsRegion2,y=ysRegion2,Geom.line,Theme(default_color=color("red")))[1]
	push!(plotLayers,plotLayers2)
	for obstacle in scene.obstacles
		if hasObstacleCache(region.obstacles,obstacle)
			layerObstacle = layer(x=[obstacle.start[1],obstacle.ender[1]],y=[obstacle.start[2],obstacle.ender[2]],Geom.line,Theme(default_color=color("green")))
			push!(plotLayers, layerObstacle[1])
		else
			layerObstacle = layer(x=[obstacle.start[1],obstacle.ender[1]],y=[obstacle.start[2],obstacle.ender[2]],Geom.line,Theme(default_color=color("purple")))
			push!(plotLayers, layerObstacle[1])
		end
	end
	plot(plotLayers)
end