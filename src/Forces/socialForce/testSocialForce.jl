cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang")
#isdefined(:types) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/load/types.jl")
#isdefined(:loadAll) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/load/loadAll.jl")
#cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/socialForce")
#isdefined(:socialForce) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/socialForce/socialForce.jl")
#isdefined(:getInteractionVector) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/socialForce/getInteractionVector.jl")
#isdefined(:socialFuzzy) || 
include("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang/evacuation/forces/socialForce/socialFuzzy.jl")
#cd("C:/Users/altieres/Box Sync/Mestrado/Dissertacao/materialJuliaLang")


#using Debug
function testSocialForce(sizexy,scalexy)
	mat = zeros(sizexy, sizexy)
	scene = loadAll()

	half = (sizexy-1) / 2
	way = WayPoint([0.0, 0.0],  0.0,  0.0,  0.0)
	#@bp
	current = Pedestrian{Region}(1.0, [0.0,  0.0], [0.0, 1.0], 1.5, true, way)
	another = Pedestrian{Region}(2.0, [0.0,  0.0], [0.0,  0.0], 1.6, true, way)
	final = (scalexy - 1)/scalexy
	tic()
	for i = 1:sizexy
	    newI = (i - 1 - half) / scalexy
	    for j = 1:sizexy        
	        newJ = (j - 1 - half) / scalexy
	        #erro[162,99]
	        #if i == 162 && j == 99
		        if sqrt(newI*newI + newJ*newJ) > 0.4
		        	another.position[1] = newJ
		        	another.position[2] = newI
		            mat[i,j] = socialForce(current, another, scene)
		        end
		    #end
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
	writecsv("fuzzySocial.csv", mat)
	return mat
	#return resultado
end