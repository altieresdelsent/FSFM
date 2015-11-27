using JuliaFuzzy.Engine
using ..Load.zeroVector
using ..@plus
using ..Point

function aggregatedSocialForce!(pedestrian,crowd, scene)
    #print("\n aggregatedSocialForce")
    pedestrian.socialForce = zeroVector
    pedestrian.socialGranular = zeroVector

    direction = scene.engineSocialDirection
    deacceleration = scene.engineSocialDeacceleration
    counter = 0
    #@bp
    for other in crowd.pedestrians
    	if other.active && other.id != pedestrian.id && isPedestrianNear(pedestrian.position,other.position)
        	pedestrian.socialForce = @plus(pedestrian.socialForce,socialForce(pedestrian, other,direction, deacceleration))
       		pedestrian.socialGranular = @plus(pedestrian.socialGranular,granularForce(pedestrian.position,other.position,pedestrian.velocity,other.velocity))
            counter = counter + 1
        end
    end
    #print("\n saiu aggregatedSocialForce")
    return counter
end
