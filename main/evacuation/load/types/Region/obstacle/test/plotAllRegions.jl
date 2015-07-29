function plotAllRegions(scene::Scene)
	(m,n) = size(scene.regions)
	for x in 1:m 
		for y in 1:n
			print("plotObstaclesRegion(scene.regions[$x,$y], scene)\n")
		end
	end
end