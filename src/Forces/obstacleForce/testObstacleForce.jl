#cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang")
#isdefined(:types) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/load/types.jl")
#isdefined(:loadAll) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/load/loadAll.jl")
#cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/socialForce")
#isdefined(:socialForce) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/obstacleForce/obstacleForce.jl")
#isdefined(:getInteractionVector) || 
#include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/obstacleForce/getInteractionVector.jl")
#isdefined(:socialFuzzy) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/obstacleForce/obstacleFuzzy.jl")
#cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang")


#using Debug
function testObstacleForce(sizexy,scalexy)
	mat = zeros(sizexy, sizexy)
	scene = loadAll()

	half = (sizexy-1) / 2
	tic()
	for i = 1:sizexy
	    newI = (i - 1 - half) / scalexy
	    for j = 1:sizexy        
	        newJ = (j - 1 - half) / scalexy
		        if sqrt(newI*newI + newJ*newJ) > 0.2

		        	minDiff = [0.0, 0.0] - [newI, newJ]
				    minDistance = sqrt(dot(minDiff,minDiff))
				    agentRadius = 0.2
				    obstacleForceSigma = 0.1

				    distance = minDistance - agentRadius
				    forceAmount = obstacleFuzzy(distance)
		            mat[i,j] = forceAmount
		        end
	    end
	end
	toc()
#@bp
#(m,n) = size(vetor)
#resultado = vec(zeros(m,1))
#for i in 1:m
#	distance = vetor[i, 1]
#	angle = vetor[i, 2]
#	velocity = vetor[i, 3]
#	resultado[i] = socialFuzzy(distance, angle ,velocity,scene)
	#break
#end	
	writecsv("fuzzyObstacle.csv", mat)
	return mat
	#return resultado
end