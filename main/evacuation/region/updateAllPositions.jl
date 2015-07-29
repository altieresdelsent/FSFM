isdefined(:updatePosition) || include("updatePosition.jl")
isdefined(:getPedestriansNear) || include("../getPedestriansNear.jl")
function updateAllPositions(scene::Scene)
	(xLength, yLength) = size(scene.regions)
	for x in 1:xLength
		for y in 1:yLength
			updatePosition(scene.regions[x,y])
			scene.regions[x,y].pedestriansNear = getPedestriansNear(scene,x,y,xLength,yLength)
			#print(length(scene.regions[x,y].pedestriansNear))
			#print("\n")
		end
	end
end