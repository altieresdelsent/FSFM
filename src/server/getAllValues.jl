using FSFM.movePedestrian!
using Zlib


function getAllValues(pedestrian,scene,crowd,framesCompressed,pedCount)
    contador = 1
    #print("começa $(id)")

    function pointToVec(point)
        return [point.x,point.y]
    end

    frames = decompress(framesCompressed)
	frameBuffer = IOBuffer()
	write(frameBuffer,frames)
	seekstart(frameBuffer)
	log = Array(Float32,4,pedCount)

	read!(frameBuffer,log)

	for j in 1:pedCount
		crowd.pedestrians[j].position = Point(Float64(log[1,j,1]),Float64(log[2,j,1]));
		crowd.pedestrians[j].velocity = Point(Float64(log[3,j,1]),Float64(log[4,j,1]));
	end

	(social,socialGranular,obstacle,obstacleGranular,desired) = movePedestrian!(pedestrian,crowd,scene, true)

    buffer = IOBuffer();

    write(buffer,[pointToVec(social),pointToVec(socialGranular),pointToVec(obstacle),pointToVec(obstacleGranular),pointToVec(desired)])

	print("$(contador = contador + 1) \n")
    log16 = Array(Float16,4,pedCount)
	for i in 2:100
		read!(frameBuffer,log16)
		for j in 1:pedCount
			crowd.pedestrians[j].position = Point(crowd.pedestrians[j].position.x + Float64(log16[1,j,1]),crowd.pedestrians[j].position.y + Float64(log16[2,j,1]));
			crowd.pedestrians[j].velocity = Point(crowd.pedestrians[j].velocity.x + Float64(log16[3,j,1]),crowd.pedestrians[j].velocity.y + Float64(log16[4,j,1]));
		end
        #compress
		(social,socialGranular,obstacle,obstacleGranular,desired) = movePedestrian!(pedestrian,crowd,scene,true)
		write(buffer,[pointToVec(social),pointToVec(socialGranular),pointToVec(obstacle),pointToVec(obstacleGranular),pointToVec(desired)])
	end

	seekstart(buffer)
    #print("acabou \n")
	return readbytes(buffer)
end
