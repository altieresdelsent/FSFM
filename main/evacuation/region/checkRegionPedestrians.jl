
isdefined(:addPedestrianRegion!) || include("addPedestrianRegion.jl")
isdefined(:deletePedestrianRegion!) || include("deletePedestrianRegion.jl")
isdefined(:isInRegion) || include("isInRegion.jl")

#include("getRegionPedestrian.jl")
isdefined(:getFront) || include("getFront.jl")
isdefined(:getFrontLeft) || include("getFrontLeft.jl")
isdefined(:getFrontRight) || include("getFrontRight.jl")
isdefined(:getLeft) || include("getLeft.jl")
isdefined(:getRight) || include("getRight.jl")
isdefined(:getBack) || include("getBack.jl")
isdefined(:getBackLeft) || include("getBackLeft.jl")
isdefined(:getBackRight) || include("getBackRight.jl")

isdefined(:checkRegionPedestrian) || include("checkRegionPedestrian.jl")
isdefined(:checkFront) || include("checkFront.jl")
isdefined(:checkFrontLeft) || include("checkFrontLeft.jl")
isdefined(:checkFrontRight) || include("checkFrontRight.jl")
isdefined(:checkLeft) || include("checkLeft.jl")
isdefined(:checkRight) || include("checkRight.jl")
isdefined(:checkBack) || include("checkBack.jl")
isdefined(:checkBackLeft) || include("checkBackLeft.jl")
isdefined(:checkBackRight) || include("checkBackRight.jl")
function checkRegionPedestrians(scene)
	(m,n) = size(scene.regions)
	for x in 1:m
		for y in 1:n
			checkRegionPedestrians(scene,x,y,m,n)
		end
	end
end
function checkRegionPedestrians(scene,x,y,lengthX,lengthY)
	region = scene.regions[x,y]
	indexPedestrian = 1
	lengthPedestrians = length(region.pedestrians)
	while indexPedestrian <= lengthPedestrians
		if checkRegionPedestrians(scene,x,y,lengthX,lengthY,indexPedestrian)
			indexPedestrian = indexPedestrian + 1
		else
			lengthPedestrians = lengthPedestrians - 1
		end
	end
end
function checkRegionPedestrians(scene,x,y,lengthX,lengthY,indexPedestrian)
	pedestrian  = scene.regions[x,y].pedestrians[indexPedestrian]
	if !isInRegion(pedestrian.position[1],pedestrian.position[2],scene.regions[x,y])
		deletePedestrianRegion!(scene.regions[x,y],pedestrian,indexPedestrian)
		if checkFront(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkFrontLeft(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkFrontRight(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkLeft(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkRight(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkBack(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkBackLeft(pedestrian,scene.regions,x,y,lengthX,lengthY)
		elseif checkBackRight(pedestrian,scene.regions,x,y,lengthX,lengthY)
		else 
			error("Could not find place to put pedestrian $pedestrian")
		end

		return false
	else
		return true
	end
end




