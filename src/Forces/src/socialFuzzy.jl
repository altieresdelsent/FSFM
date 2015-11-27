using JuliaFuzzy
#using JuliaFuzzy.process
#using JuliaFuzzy.Variables.defuzzify

using LinearFunc.LinearFunc2D
using LinearFunc.solveFast

const slopeDistanceFar = 1.0
const inflectionDistanceFar = 2.5

const meanAngleBig = pi
const standardDeviationAngleBig = pi*0.35

const slopeVelocitySlow = -6.0
const inflectionVelocitySlow = 1.7

const slopeDistanceNear = -1.8
const inflectionDistanceNear = 2.5

const meanAngleLittle = 0.0
const standardDeviationAngleLittle = pi*0.20

const slopeVelocityFast = 1.0
const inflectionVelocityFast = 2.4

const startPointLow = -0.8
const endPointLow = 0.8
const rangeLow = (endPointLow - startPointLow)
const areaPointLow = rangeLow / 2.0
const midPointLow = startPointLow + areaPointLow
const tanLow = areaPointLow

const startPointHigh = 0.6
const endPointHigh = 1.0
const rangeHigh = (endPointHigh - startPointHigh)
const areaPointHigh = rangeHigh / 2.0
const midPointHigh = startPointHigh + areaPointHigh
const tanHigh = areaPointHigh

const solutionLinear = solveFast(LinearFunc2D(endPointLow,0.0,midPointLow,1.0),LinearFunc2D(startPointHigh,0.0,midPointHigh,1.0))
const encounterPointX = solutionLinear.x
const encounterPointY = solutionLinear.y
const innerArea = (encounterPointY * (endPointLow - startPointHigh)) / 2.0
const innerCenter = (startPointHigh + endPointLow + encounterPointX) / 3.0


function socialFuzzy(distance,angle,relativeVelocity)
	#engine = scene.engineSocial
	#engine.inputVariables.Distance.value = distance
	#engine.inputVariables.Angle.value = angle
	#engine.inputVariables.VelocityRelative.value = relativeVelocity

	#print("\nVai processar engine \n")
	#process(engine)
	#print("\nEngine Processado \n")
	#print("\nvai Defuzzificar \n")
	#retorno = defuzzify(engine.outputVariables.Force)
	#print("\ndefuzzificou \n")
	#return retorno
	activationForceLow = max(1.0 / (1.0 + exp(-slopeDistanceFar * (distance - inflectionDistanceFar))),exp((-(angle - meanAngleBig) * (angle - meanAngleBig)) / (2.0 * standardDeviationAngleBig * standardDeviationAngleBig)))
	activationForceLow = max(1.0 / (1.0 + exp(-slopeVelocitySlow * (relativeVelocity - inflectionVelocitySlow))),activationForceLow)

	activationForceHigh = (1.0 / (1.0 + exp(-slopeDistanceNear * (distance - inflectionDistanceNear)))) * (1.0 / (1.0 + exp(-slopeVelocityFast * (relativeVelocity - inflectionVelocityFast))))
	activationForceHigh = activationForceHigh * exp((-(angle - meanAngleLittle) * (angle - meanAngleLittle)) / (2.0 * standardDeviationAngleLittle * standardDeviationAngleLittle))

	if activationForceLow < 1e-5 && activationForceHigh < 1e-5
		return 0.0
	elseif activationForceLow < 1e-5
		return midPointHigh
	elseif activationForceHigh < 1e-5
		return midPointLow
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
		return (areaLow*midPointLow + areaHigh*midPointHigh - areaMidTerm) / (areaLow + areaHigh - areaIntersection)
	end
end

function getInnerTrapezoid(activationLow, activationHigh)
    ############################
    ############****############
    ###########******###########
    ##########********##########
    #*******&&&&*******#########
    #############################
    #second case is when the  triangle that occupy both triangules is sliced forming a trapezoid so I have to calculate
    #his area and centroid.
        activationMin = min(activationLow,activationHigh)
        #activationMinSquared = activationMin * activationMin * 0.5

        baseTriangleLast = tanLow * activationMin
        baseTriangleCurrent = tanHigh * activationMin

        centerOfMassLast = endPointLow - baseTriangleLast*0.666666666666666
        centerOfMassCurrent = startPointHigh + baseTriangleCurrent*0.666666666666666

        areaTriangleLast = baseTriangleLast * activationMin *0.5
        areaTriangleCurrent = baseTriangleCurrent * activationMin *0.5

        innerSquareBase = endPointLow - startPointHigh - baseTriangleLast - baseTriangleCurrent
        innerSquareArea = innerSquareBase * activationMin
        centerOfMassSquare = startPointHigh+baseTriangleCurrent + innerSquareBase*0.5

        #sumAreaTrapezoid = innerSquareArea
        #sumAreaTrapezoid = sumAreaTrapezoid + areaTriangleLast
        #sumAreaTrapezoid = sumAreaTrapezoid + areaTriangleCurrent

        #sumAreaMultipliedByMidTermTrapezoid = innerSquareArea*centerOfMassSquare
        #sumAreaMultipliedByMidTermTrapezoid = sumAreaMultipliedByMidTermTrapezoid + areaTriangleLast*centerOfMassLast
        #sumAreaMultipliedByMidTermTrapezoid = sumAreaMultipliedByMidTermTrapezoid + areaTriangleCurrent*centerOfMassCurrent
        #centerOfMassTrapezoid = sumAreaMultipliedByMidTermTrapezoid / sumArea

        sumArea = innerSquareArea + areaTriangleLast + areaTriangleCurrent
        sumAreaMultipliedByMidTerm = innerSquareArea*centerOfMassSquare + areaTriangleLast*centerOfMassLast + areaTriangleCurrent*centerOfMassCurrent
        return (sumArea,sumAreaMultipliedByMidTerm)
end
function areaTrapezoid(tan,range,activation)
	baseTriangle = tan * activation
    baseInnerSquare = range - baseTriangle
    area = baseInnerSquare * activation
    return area
end
