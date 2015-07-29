using JuliaFuzzy.Engine
using Debug
#push!(Distance.terms,Gaussian{float}(:VERYNEAR,0, 0.1));
#push!(Distance.terms,Gaussian{float}(:NEAR, 0.6, 0.2));
#push!(Distance.terms,Gaussian{float}(:MEDIUM, 1.2, 0.4));
#push!(Distance.terms,Gaussian{float}(:FAR, 2.4, 0.8));
#push!(Distance.terms,Gaussian{float}(:VERYFAR, 5, 1.6));

const slopeDistanceNearObstacle = -75.0
const inflectionDistanceNearObstacle = 0.1

const slopeDistanceFarObstacle = 25.0
const inflectionDistanceFarObstacle = 0.3

#const meanVeryNear = 0.0
#const standardDeviationVeryNear = 0.01

#const meanNear = 0.3
#const standardDeviationNear = 0.1

#const meanMedium = 1.0
#const standardDeviationMedium = 0.33

#const meanFar = 3.0
#const standardDeviationFar = 1.0

#const meanVeryFar = 10.0
#const standardDeviationVeryFar = 3.33

#const startPointVeryLow = -5.0
#const endPointVeryLow = 5.0
#const rangeVeryLow = (endPointVeryLow - startPointVeryLow)
#const areaPointVeryLow = rangeVeryLow / 2.0
#const midPointVeryLow = startPointVeryLow + areaPointVeryLow
#const tanVeryLow = areaPointVeryLow

const startPointLowObstacle = -3.0
const endPointLowObstacle = 3.0
const rangeLowObstacle = (endPointLowObstacle - startPointLowObstacle)
const areaPointLowObstacle = rangeLowObstacle / 2.0
const midPointLowObstacle = startPointLowObstacle + areaPointLowObstacle
const tanLowObstacle = areaPointLowObstacle

#const startPointMedium = 0.05
#const endPointMedium = 0.3
#const rangeMedium = (endPointMedium - startPointMedium)
#const areaPointMedium = rangeMedium / 2.0
#const midPointMedium = startPointMedium + areaPointMedium
#const tanMedium = areaPointMedium

const startPointHighObstacle = 2.99
const endPointHighObstacle = 3.01
const rangeHighObstacle = (endPointHighObstacle - startPointHighObstacle)
const areaPointHighObstacle = rangeHighObstacle / 2.0
const midPointHighObstacle = startPointHighObstacle + areaPointHighObstacle
const tanHighObstacle = areaPointHighObstacle

#const startPointVeryHigh = 0.5
#const endPointVeryHigh = 10.0
#const rangeVeryHigh = (endPointVeryHigh - startPointVeryHigh)
#const areaPointVeryHigh = rangeVeryHigh / 2.0
#const midPointVeryHigh = startPointVeryHigh + areaPointVeryHigh
#const tanVeryHigh = areaPointVeryHigh

const solutionLinearObstacle = solveFast(LinearFunc(endPointLowObstacle,0.0,midPointLowObstacle,1.0),LinearFunc(startPointHighObstacle,0.0,midPointHighObstacle,1.0))
const encounterPointObstacleX = solutionLinearObstacle.x
const encounterPointObstacleY = solutionLinearObstacle.y
const innerAreaObstacle = (encounterPointObstacleY * (endPointLowObstacle - startPointHighObstacle)) / 2.0
const innerCenterObstacle = (startPointHighObstacle + endPointLowObstacle + encounterPointObstacleX) / 3.0

function obstacleFuzzy(distance)
    if distance <= 0.0
        return 10.0
    elseif distance >= 6.0
        return 0.0
    else
        #@bp (distance == 0.16283605113053468)
        #print("distace=$distance ------  ")
        #activationForceVeryLow = exp((-(distance - meanVeryFar) * (distance - meanVeryFar)) / (2.0 * standardDeviationVeryFar * standardDeviationVeryFar))
        #activationForceLow = exp((-(distance - meanFar) * (distance - meanFar)) / (2.0 * standardDeviationFar * standardDeviationFar))
        #activationForceMedium = exp((-(distance - meanMedium) * (distance - meanMedium)) / (2.0 * standardDeviationMedium * standardDeviationMedium))
        #activationForceHigh = exp((-(distance - meanNear) * (distance - meanNear)) / (2.0 * standardDeviationNear * standardDeviationNear))
        #activationForceVeryHigh = exp((-(distance - meanVeryNear) * (distance - meanVeryNear)) / (2.0 * standardDeviationVeryNear * standardDeviationVeryNear))
        activationForceLowObstacle = 1.0 / (1.0 + exp(-slopeDistanceFarObstacle * (distance - inflectionDistanceFarObstacle)))
        activationForceHighObstacle = 1.0 / (1.0 + exp(-slopeDistanceNearObstacle * (distance - inflectionDistanceNearObstacle)))
        sumAreaLow = areaTrapezoid(tanLowObstacle,rangeLowObstacle,activationForceLowObstacle)
        sumAreaHigh = areaTrapezoid(tanHighObstacle,rangeHighObstacle,activationForceHighObstacle)
        interArea1 = 0.0
        areaCenter1 = 0.0
        if min(activationForceLowObstacle,activationForceHighObstacle) >= encounterPointObstacleY
            interArea1 = innerAreaObstacle
            areaCenter1 = innerCenterObstacle*innerAreaObstacle
        else
            (interArea1,areaCenter1) = getInnerTrapezoidObstacle(activationForceLowObstacle,activationForceHighObstacle, tanLowObstacle, tanHighObstacle, endPointLowObstacle, startPointHighObstacle)
        end
        #sumAreaVeryLow = areaTrapezoid(tanVeryLow,rangeVeryLow,activationForceVeryLow)

        #sumAreaLow = areaTrapezoid(tanLow,rangeLow,activationForceLow)

        #(interArea1,areaCenter1) = getInnerTrapezoidObstacle(activationForceVeryLow,activationForceLow, tanVeryLow, tanLow, endPointVeryLow, startPointLow)

        #sumAreaMedium = areaTrapezoid(tanMedium,rangeMedium,activationForceMedium)
        
        #(interArea2,areaCenter2) = getInnerTrapezoidObstacle(activationForceLow,activationForceMedium, tanLow, tanMedium, endPointLow, startPointMedium)

        #sumAreaHigh = areaTrapezoid(tanHigh,rangeHigh,activationForceHigh)
        
        #(interArea3,areaCenter3) = getInnerTrapezoidObstacle(activationForceMedium,activationForceHigh, tanMedium, tanHigh, endPointMedium, startPointHigh)

        #sumAreaVeryHigh = areaTrapezoid(tanVeryHigh,rangeVeryHigh,activationForceVeryHigh)
        
        #(interArea4,areaCenter4) = getInnerTrapezoidObstacle(activationForceHigh,activationForceVeryHigh, tanHigh, tanVeryHigh, endPointHigh, startPointVeryHigh)

        #sumArea = sumAreaVeryLow + sumAreaLow + sumAreaMedium + sumAreaHigh + sumAreaVeryHigh
        #sumArea = sumArea - (interArea1 + interArea2 + interArea3 + interArea4)

        #sumAreaCenter = sumAreaVeryLow*midPointVeryLow + sumAreaLow*midPointLow + sumAreaMedium*midPointMedium + sumAreaHigh*midPointHigh + sumAreaVeryHigh*midPointVeryHigh
        #sumAreaCenter = sumAreaCenter - (areaCenter1 + areaCenter2 + areaCenter3 + areaCenter4)

        sumArea = sumAreaLow + sumAreaHigh
        sumArea = sumArea - interArea1

        sumAreaCenter = sumAreaLow*midPointLowObstacle + sumAreaHigh*midPointHighObstacle
        sumAreaCenter = sumAreaCenter - areaCenter1

        #engine.inputVariables.Distance.value = distance
        #JuliaFuzzy.process(engine)
        #force = JuliaFuzzy.Variables.defuzzify(engine.outputVariables.Force)
        #print("force=$force ------  ")
        #print("\n")
        force = sumAreaCenter / sumArea
        #@bp force < -0.1
        return force
    end
end

function getInnerTrapezoidObstacle(activationLast, activationCurrent, tanLast, tanCurrent, endPointLast, startPointCurrent)
    ############################
    ############****############
    ###########******###########
    ##########********##########
    #*******&&&&*******#########
    #############################
    #second case is when the  triangle that occupy both triangules is sliced forming a trapezoid so I have to calculate
    #his area and centroid.
        activationMin = min(activationLast,activationCurrent)
        #activationMinSquared = activationMin * activationMin * 0.5

        baseTriangleLast = tanLast * activationMin
        baseTriangleCurrent = tanCurrent * activationMin
        
        centerOfMassLast = endPointLast - baseTriangleLast*0.666666666666666
        centerOfMassCurrent = startPointCurrent + baseTriangleCurrent*0.666666666666666

        areaTriangleLast = baseTriangleLast * activationMin *0.5
        areaTriangleCurrent = baseTriangleCurrent * activationMin *0.5

        innerSquareBase = endPointLast - startPointCurrent - baseTriangleLast - baseTriangleCurrent
        innerSquareArea = innerSquareBase * activationMin
        centerOfMassSquare = startPointCurrent+baseTriangleCurrent + innerSquareBase*0.5

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
