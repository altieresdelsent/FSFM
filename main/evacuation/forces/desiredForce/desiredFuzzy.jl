const slopeDirectionWrong = 1.0
const inflectionDirectionWrong = 2.5

const slopeDirectionRight = 1.0
const inflectionDirectionRight = -2.5

const meanAngleBig = pi
const standardDeviationAngleBig = pi*0.35

const meanAngleLittle = 0.0
const standardDeviationAngleLittle = pi*0.20


function desiredFuzzy(pedestrian)
	ped = pedestrian.position
    way = pedestrian.wayPoint.position
    vMax = pedestrian.maxVelocity
    velocity = pedestrian.velocity
    relaxationTime = 0.01


    diffee = way - ped

    lengthVec = sqrt(dot(diffee,diffee))
    if lengthVec > 0.0 
        force = ((diffee / lengthVec)*vMax) - velocity
        lengthVelocity = sqrt(dot(force,force))
        angleDirection = atan2(diffe[1],diffe[2])
        angleActual = atan2(velocity[1],velocity[2])
        
        thetaAngle = angle - angle2
        if thetaAngle > pi
	        thetaAngle = thetaAngle - 2*pi
	    elseif thetaAngle < -pi
	        thetaAngle = thetaAngle + 2*pi
    	end

    	activationWrong = 1.0 / (1.0 + exp(-slopeDirectionWrong * (lengthVelocity - inflectionDirectionWrong)))
    	activationRight = 1.0 / (1.0 + exp(-slopeDirectionRight * (lengthVelocity - inflectionDirectionRight)))

    	activationBig = exp((-(angle - meanAngleBig) * (angle - meanAngleBig)) / (2.0 * standardDeviationAngleBig * standardDeviationAngleBig))
    	activationLittle = exp((-(angle - meanAngleLittle) * (angle - meanAngleLittle)) / (2.0 * standardDeviationAngleLittle * standardDeviationAngleLittle))

    	if activationForceLow < 1e-5 && activationForceHigh < 1e-5
			force = 0.0
		elseif activationForceLow < 1e-5
			force = midPointHigh
		elseif activationForceHigh < 1e-5
			force = midPointLow
		else
			areaLow = areaTrapezoid(tanLow,rangeLow,activationForceLow)
			areaHigh = areaTrapezoid(tanHigh,rangeHigh,activationForceHigh)
			areaIntersection = 0.0
			areaMidTerm = 0.0
			if activationForceLow > encounterPointY && activationForceHigh > encounterPointY
				areaIntersection = innerArea
				areaMidTerm = innerArea*innerCenter
			else
				(areaIntersection,areaMidTerm) = getInnerTrapezoid(activationForceLow,activationForceHigh)
			end
			force = (areaLow*midPointLow + areaHigh*midPointHigh - areaMidTerm) / (areaLow + areaHigh - areaIntersection) 
		end

        return force / (relaxationTime*75)
    else
        return [0.0, 0.0]
    end
end