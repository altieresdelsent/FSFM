@everywhere const procsCountT = 1
#processes = addprocs(procsCountT)

@everywhere const population = 1000000
@everywhere const testsCount = 30000
@everywhere const newBornsCount = 100000
@everywhere const mutationCount = 2000

@everywhere const procsCount = 1
@everywhere immutable cromossome
    mean::Float64
    twoSdSquared::Float64
    cromossome(mean,sd) = new(mean,sd*sd*2)
    cromossome(mean,sd,meanMutation,sdMutation) = new(mean+meanMutation,abs(sd+sdMutation))
end

@everywhere immutable DNA
    differenceVelocityFast::cromossome
    differenceVelocityFine::cromossome
    differenceVelocitySlow::cromossome
    angleFront::cromossome
    angleBack::cromossome
    angleCenter::cromossome
end
@everywhere function evaluateMicrobe(VelocityDifference,DirectionAngle,microbe) # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 425:
    quotient::Float64 = VelocityDifference - microbe.differenceVelocityFast.mean
    VelocityDifference_TOOFAST::Float64 = if quotient >= 0.0
        1.0
    else
        exp(-(quotient * quotient) / microbe.differenceVelocityFast.twoSdSquared)
    end

    quotient = VelocityDifference - microbe.differenceVelocityFine.mean
    VelocityDifference_FINE::Float64 = exp(-(quotient * quotient) / microbe.differenceVelocityFine.twoSdSquared)

    quotient = VelocityDifference +- microbe.differenceVelocitySlow.mean
    VelocityDifference_TOOSLOW::Float64 = if quotient <= 0.0
        1.0
    else
        exp(-(quotient * quotient) / microbe.differenceVelocitySlow.twoSdSquared)
    end

    quotient = DirectionAngle - microbe.angleFront.mean
    DirectionAngle_FRONTRIGHT::Float64 = exp(-(quotient * quotient) / microbe.angleFront.twoSdSquared)

    quotient = DirectionAngle + microbe.angleFront.mean
    DirectionAngle_FRONTLEFT::Float64 = exp(-(quotient * quotient) / microbe.angleFront.twoSdSquared)

    quotient = DirectionAngle - microbe.angleBack.mean
    DirectionAngle_BACKRIGHT::Float64 = exp(-(quotient * quotient) / microbe.angleBack.twoSdSquared)

    quotient = DirectionAngle + microbe.angleBack.mean
    DirectionAngle_BACKLEFT::Float64 = exp(-(quotient * quotient) / microbe.angleBack.twoSdSquared)

    quotient = DirectionAngle + microbe.angleCenter.mean
    DirectionAngle_FRONT::Float64 = exp(-(quotient * quotient) / microbe.angleCenter.twoSdSquared)


    rule_1 = VelocityDifference_TOOFAST
    rule_1 = rule_1 * DirectionAngle_BACKRIGHT
    rule_2 = VelocityDifference_FINE
    rule_2 = rule_2 * DirectionAngle_BACKRIGHT
    rule_3 = VelocityDifference_TOOSLOW
    rule_3 = rule_3 * DirectionAngle_BACKRIGHT
    rule_4 = VelocityDifference_TOOFAST
    rule_4 = rule_4 * DirectionAngle_BACKLEFT
    rule_5 = VelocityDifference_FINE
    rule_5 = rule_5 * DirectionAngle_BACKLEFT
    rule_6 = VelocityDifference_TOOSLOW
    rule_6 = rule_6 * DirectionAngle_BACKLEFT
    rule_7 = VelocityDifference_TOOFAST
    rule_7 = rule_7 * DirectionAngle_FRONTRIGHT
    rule_8 = VelocityDifference_FINE
    rule_8 = rule_8 * DirectionAngle_FRONTRIGHT
    rule_9 = VelocityDifference_TOOSLOW
    rule_9 = rule_9 * DirectionAngle_FRONTRIGHT
    rule_10 = VelocityDifference_TOOFAST
    rule_10 = rule_10 * DirectionAngle_FRONTLEFT
    rule_11 = VelocityDifference_FINE
    rule_11 = rule_11 * DirectionAngle_FRONTLEFT
    rule_12 = VelocityDifference_TOOSLOW
    rule_12 = rule_12 * DirectionAngle_FRONTLEFT
    rule_13 = VelocityDifference_TOOFAST
    rule_13 = rule_13 * DirectionAngle_FRONT
    rule_14 = VelocityDifference_FINE
    rule_14 = rule_14 * DirectionAngle_FRONT
    rule_15 = VelocityDifference_TOOSLOW
    rule_15 = rule_15 * DirectionAngle_FRONT
    Force_ZERO = rule_8
    Force_ZERO = max(Force_ZERO,rule_11)
    Force_ZERO = max(Force_ZERO,rule_14)
    Force_NORMAL = rule_3
    Force_NORMAL = max(Force_NORMAL,rule_6)
    Force_NORMAL = max(Force_NORMAL,rule_7)
    Force_NORMAL = max(Force_NORMAL,rule_9)
    Force_NORMAL = max(Force_NORMAL,rule_10)
    Force_NORMAL = max(Force_NORMAL,rule_12)
    Force_NORMAL = max(Force_NORMAL,rule_13)
    Force_NORMAL = max(Force_NORMAL,rule_15)
    Force_STRONG = rule_1
    Force_STRONG = max(Force_STRONG,rule_2)
    Force_STRONG = max(Force_STRONG,rule_4)
    Force_STRONG = max(Force_STRONG,rule_5)
    sumArea_Force = 0.0
    sumAreaCenter_Force = 0.0
    Force_ZERO_area = (4.0 - 2.0Force_ZERO) * Force_ZERO
    sumArea_Force = sumArea_Force + Force_ZERO_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_ZERO_area * 0.0
    Force_NORMAL_area = (4.0 - 2.0Force_NORMAL) * Force_NORMAL
    sumArea_Force = sumArea_Force + Force_NORMAL_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_NORMAL_area * 2.0
    if Force_ZERO > 0.5 && Force_NORMAL > 0.5 # line 346:
        sumArea_Force = sumArea_Force - 0.5 # line 347:
        sumAreaCenter_Force = sumAreaCenter_Force + -1.0
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(Force_ZERO,Force_NORMAL) # line 393:
        baseTriangleLast = 2.0activationMin # line 394:
        baseTriangleCurrent = 2.0activationMin # line 396:
        centerOfMassLast = 2.0 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = 0.0 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((2.0 - 0.0) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = 0.0 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_Force = ((sumArea_Force - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_Force = ((sumAreaCenter_Force - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    Force_STRONG_area = (4.0 - 2.0Force_STRONG) * Force_STRONG
    sumArea_Force = sumArea_Force + Force_STRONG_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_STRONG_area * 4.0
    if Force_NORMAL > 0.5 && Force_STRONG > 0.5 # line 346:
        sumArea_Force = sumArea_Force - 0.5 # line 347:
        sumAreaCenter_Force = sumAreaCenter_Force + -3.0
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(Force_NORMAL,Force_STRONG) # line 393:
        baseTriangleLast = 2.0activationMin # line 394:
        baseTriangleCurrent = 2.0activationMin # line 396:
        centerOfMassLast = 4.0 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = 2.0 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((4.0 - 2.0) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = 2.0 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_Force = ((sumArea_Force - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_Force = ((sumAreaCenter_Force - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    Force = sumAreaCenter_Force / sumArea_Force
    return Force
end

@everywhere function evaluateMicrobeBKP(VelocityDifference::Float64,DirectionAngle::Float64,microbe::DNA) # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 425:
    quotient::Float64 = VelocityDifference - microbe.differenceVelocityFast.mean
    VelocityDifference_TOOFAST::Float64 = if quotient >= 0.0
        1.0
    else
        exp(-(quotient * quotient) / microbe.differenceVelocityFast.twoSdSquared)
    end

    quotient = VelocityDifference - microbe.differenceVelocityFine.mean
    VelocityDifference_FINE::Float64 = exp(-(quotient * quotient) / microbe.differenceVelocityFine.twoSdSquared)

    quotient = VelocityDifference +- microbe.differenceVelocitySlow.mean
    VelocityDifference_TOOSLOW::Float64 = if quotient <= 0.0
        1.0
    else
        exp(-(quotient * quotient) / microbe.differenceVelocitySlow.twoSdSquared)
    end

    quotient = DirectionAngle - microbe.angleFront.mean
    DirectionAngle_FRONTRIGHT::Float64 = exp(-(quotient * quotient) / microbe.angleFront.twoSdSquared)

    quotient = DirectionAngle + microbe.angleFront.mean
    DirectionAngle_FRONTLEFT::Float64 = exp(-(quotient * quotient) / microbe.angleFront.twoSdSquared)

    quotient = DirectionAngle - microbe.angleBack.mean
    DirectionAngle_BACKRIGHT::Float64 = exp(-(quotient * quotient) / microbe.angleBack.twoSdSquared)

    quotient = DirectionAngle + microbe.angleBack.mean
    DirectionAngle_BACKLEFT::Float64 = exp(-(quotient * quotient) / microbe.angleBack.twoSdSquared)

    quotient = DirectionAngle + microbe.angleCenter.mean
    DirectionAngle_FRONT::Float64 = exp(-(quotient * quotient) / microbe.angleCenter.twoSdSquared)


    rule_1::Float64 = DirectionAngle_BACKLEFT
    rule_1 = (rule_1 + DirectionAngle_BACKRIGHT) - rule_1 * DirectionAngle_BACKRIGHT
    rule_2::Float64 = VelocityDifference_FINE
    rule_2 = rule_2 * DirectionAngle_FRONT
    rule_3::Float64 = VelocityDifference_TOOSLOW
    rule_3 = rule_3 * DirectionAngle_FRONTRIGHT
    rule_4::Float64 = VelocityDifference_TOOSLOW
    rule_4 = rule_4 * DirectionAngle_FRONTLEFT
    rule_5::Float64 = VelocityDifference_TOOFAST
    rule_5 = rule_5 * DirectionAngle_FRONTRIGHT
    rule_6::Float64 = VelocityDifference_TOOFAST
    rule_6 = rule_6 * DirectionAngle_FRONTLEFT
    rule_7::Float64 = DirectionAngle_FRONTRIGHT
    rule_8::Float64 = DirectionAngle_FRONTLEFT

    Force_NEGATIVE::Float64 = rule_5
    Force_NEGATIVE = max(Force_NEGATIVE,rule_6)
    Force_ZERO::Float64 = rule_2
    Force_POSITIVE::Float64 = rule_1
    Force_POSITIVE = max(Force_POSITIVE,rule_3)
    Force_POSITIVE = max(Force_POSITIVE,rule_4)
    AngleTurn_LEFT::Float64 = rule_7
    AngleTurn_CENTER::Float64 = rule_1
    AngleTurn_CENTER = max(AngleTurn_CENTER,rule_2)
    AngleTurn_RIGHT::Float64 = rule_8

    sumArea_Force = 0.0
    sumAreaCenter_Force = 0.0
    Force_NEGATIVE_area = (8.0 - 4.0Force_NEGATIVE) * Force_NEGATIVE
    sumArea_Force = sumArea_Force + Force_NEGATIVE_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_NEGATIVE_area * -4.0
    Force_ZERO_area = (8.0 - 4.0Force_ZERO) * Force_ZERO
    sumArea_Force = sumArea_Force + Force_ZERO_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_ZERO_area * 0.0
    if Force_NEGATIVE > 0.5 && Force_ZERO > 0.5 # line 346:
        sumArea_Force = sumArea_Force - 1.0 # line 347:
        sumAreaCenter_Force = sumAreaCenter_Force + 2.0
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(Force_NEGATIVE,Force_ZERO) # line 393:
        baseTriangleLast = 4.0activationMin # line 394:
        baseTriangleCurrent = 4.0activationMin # line 396:
        centerOfMassLast = 0.0 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = -4.0 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((0.0 - -4.0) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = -4.0 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_Force = ((sumArea_Force - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_Force = ((sumAreaCenter_Force - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    Force_POSITIVE_area = (8.0 - 4.0Force_POSITIVE) * Force_POSITIVE
    sumArea_Force = sumArea_Force + Force_POSITIVE_area
    sumAreaCenter_Force = sumAreaCenter_Force + Force_POSITIVE_area * 4.0
    if Force_ZERO > 0.5 && Force_POSITIVE > 0.5 # line 346:
        sumArea_Force = sumArea_Force - 1.0 # line 347:
        sumAreaCenter_Force = sumAreaCenter_Force + -2.0
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(Force_ZERO,Force_POSITIVE) # line 393:
        baseTriangleLast = 4.0activationMin # line 394:
        baseTriangleCurrent = 4.0activationMin # line 396:
        centerOfMassLast = 4.0 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = 0.0 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((4.0 - 0.0) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = 0.0 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_Force = ((sumArea_Force - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_Force = ((sumAreaCenter_Force - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    Force = sumAreaCenter_Force / sumArea_Force

    sumArea_AngleTurn::Float64 = 0.0
    sumAreaCenter_AngleTurn::Float64 = 0.0
    AngleTurn_LEFT_area::Float64 = (6.283185307179586 - 3.141592653589793AngleTurn_LEFT) * AngleTurn_LEFT
    sumArea_AngleTurn = sumArea_AngleTurn + AngleTurn_LEFT_area
    sumAreaCenter_AngleTurn = sumAreaCenter_AngleTurn + AngleTurn_LEFT_area * -3.141592653589793
    AngleTurn_CENTER_area::Float64 = (6.283185307179586 - 3.141592653589793AngleTurn_CENTER) * AngleTurn_CENTER
    sumArea_AngleTurn = sumArea_AngleTurn + AngleTurn_CENTER_area
    sumAreaCenter_AngleTurn = sumAreaCenter_AngleTurn + AngleTurn_CENTER_area * 0.0
    if AngleTurn_LEFT > 0.5 && AngleTurn_CENTER > 0.5 # line 346:
        sumArea_AngleTurn = sumArea_AngleTurn - 0.7853981633974483 # line 347:
        sumAreaCenter_AngleTurn = sumAreaCenter_AngleTurn + 1.5707963267948966
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(AngleTurn_LEFT,AngleTurn_CENTER) # line 393:
        baseTriangleLast = 3.141592653589793activationMin # line 394:
        baseTriangleCurrent = 3.141592653589793activationMin # line 396:
        centerOfMassLast = 0.0 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = -3.141592653589793 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((0.0 - -3.141592653589793) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = -3.141592653589793 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_AngleTurn = ((sumArea_AngleTurn - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_AngleTurn = ((sumAreaCenter_AngleTurn - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    AngleTurn_RIGHT_area::Float64 = (6.283185307179586 - 3.141592653589793AngleTurn_RIGHT) * AngleTurn_RIGHT
    sumArea_AngleTurn = sumArea_AngleTurn + AngleTurn_RIGHT_area
    sumAreaCenter_AngleTurn = sumAreaCenter_AngleTurn + AngleTurn_RIGHT_area * 3.141592653589793
    if AngleTurn_CENTER > 0.5 && AngleTurn_RIGHT > 0.5 # line 346:
        sumArea_AngleTurn = sumArea_AngleTurn - 0.7853981633974483 # line 347:
        sumAreaCenter_AngleTurn = sumAreaCenter_AngleTurn + -1.5707963267948966
    else  # line 349: # /home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/evacuation/JuliaFuzzy/buildFunction.jl, line 390:
        activationMin = min(AngleTurn_CENTER,AngleTurn_RIGHT) # line 393:
        baseTriangleLast = 3.141592653589793activationMin # line 394:
        baseTriangleCurrent = 3.141592653589793activationMin # line 396:
        centerOfMassLast = 3.141592653589793 - baseTriangleLast * 0.666666666666666 # line 397:
        centerOfMassCurrent = 0.0 + baseTriangleCurrent * 0.666666666666666 # line 399:
        areaTriangleLast = baseTriangleLast * activationMin * 0.5 # line 400:
        areaTriangleCurrent = baseTriangleCurrent * activationMin * 0.5 # line 402:
        innerSquareBase = ((3.141592653589793 - 0.0) - baseTriangleLast) - baseTriangleCurrent # line 403:
        innerSquareArea = innerSquareBase * activationMin # line 404:
        centerOfMassSquare = 0.0 + baseTriangleCurrent + innerSquareBase * 0.5 # line 418:
        sumArea_AngleTurn = ((sumArea_AngleTurn - innerSquareArea) - areaTriangleLast) - areaTriangleCurrent # line 419:
        sumAreaCenter_AngleTurn = ((sumAreaCenter_AngleTurn - innerSquareArea * centerOfMassSquare) - areaTriangleLast * centerOfMassLast) - areaTriangleCurrent * centerOfMassCurrent
    end
    AngleTurn = sumAreaCenter_AngleTurn / sumArea_AngleTurn
    return (Force,AngleTurn)
end

@everywhere function desiredOriginal(ped,way,velocity, vMax)
    relaxationTime = 0.01
    diffee = way - ped

    lengthVec = sqrt(dot(diffee,diffee))
    if lengthVec > 0.0
        force = ((diffee / lengthVec)*vMax) -velocity
        final = force / (relaxationTime*75)
    else
        final = [0.0, 0.0]
    end
    angleForceFinal = atan2(final[1],final[2])
    angleDirection = atan2(diffee[1],diffee[2])
    differenceAngle = angleForceFinal - angleDirection
    if differenceAngle > pi
        differenceAngle = differenceAngle - 2*pi
    elseif differenceAngle < -pi
        differenceAngle = differenceAngle + 2*pi
    end

    forceFinal = sqrt(dot(final,final)) / vMax
    (forceFinal,differenceAngle)
end

@everywhere function generateTestSubject()
    vMax = randn()*0.2+1.2
    subject = Array(Float64,2,3,testsCount)
    subject[:,1:2,:] = rand(2,2,testsCount)
    subject[:,3,:] = rand(2,1,testsCount)*vMax*2-vMax
    (subject,vMax)
end
@everywhere function calculateRightAnswer(subject,vMax)
end
@everywhere function calculateRightAnswer(subject,vMax)
    rightAnswer = Array(Float64,2,testsCount)
    for i in 1:testsCount
        way = subject[:,1,i]
        ped = subject[:,2,i]
        vel = subject[:,3,i]
        x = desiredOriginal(way,ped,vel,vMax)
        rightAnswer[1,i] = x[1]
        rightAnswer[2,i] = x[2]
    end
    rightAnswer
end

@everywhere function calculateAnglesAndVelocity(subject,vMax)
    inputs = Array(Float64,2,testsCount)
    for i in 1:testsCount
        way = subject[:,1,i]
        ped = subject[:,2,i]
        vel = subject[:,3,i]

        vecDirection = way - ped

        differenceVelocity = sqrt(dot(vel,vel)) \ vMax - 1
        angleDirection = atan2(vecDirection[1],vecDirection[2])
        angleVelocity = (sum(vel) > 0) ? atan2(vel[1],vel[2]) : angleDirection
        differenceAngle = angleDirection - angleVelocity
        if differenceAngle > pi
            differenceAngle = differenceAngle - 2*pi
        elseif differenceAngle < -pi
            differenceAngle = differenceAngle + 2*pi
        end
        x = (differenceVelocity,differenceAngle)
        inputs[1,i] = x[1]
        inputs[2,i] = x[2]
    end
    inputs
end

@everywhere function evaluateIndividual(inputs, outputs,microbe)
    meanSquare = 0.0000000001
    #print(outputs)
    scores = Array(Float64,testsCount)
    maxScore = realmin(0.0)
    for i in 1:testsCount
        answer = evaluateMicrobe(inputs[1,i],inputs[2,i],microbe)
        difference1 = answer-outputs[1,i]
        #difference2 = answer[2]-outputs[2,i]
        score = difference1*difference1 #+ difference2*difference2
        scores[i] = score
        meanSquare = meanSquare + score
        if score > maxScore
            maxScore = score
        end
    end
    if isnan(meanSquare) || isinf(meanSquare)
        #info("meansquare not right")
        #print("\n")
        #print(meanSquare)
        #print("\n")
        meanSquare = 1e10
    #else
        #print(maxScore)
        #print("\n")

    end
    meanSquare = meanSquare * std(scores)
    #scores
    #maxScore
    meanSquare / testsCount
end

@everywhere function generateInitialPopulation(lengthPopulation)
    sdFunc = () -> rand()*2
    generation = [DNA(cromossome(randn()+1,sdFunc()),
    cromossome(randn(),sdFunc()),
    cromossome(randn()-1.0,sdFunc()),
    cromossome(randn()+pi*0.25,rand()*pi),
    cromossome(randn()+pi,rand()*pi),
    cromossome(randn()+0.0, rand()*pi)) for x in 1:lengthPopulation];

end

@everywhere function generateInitialPopulationAssync()
    remotesRef = [@spawnat(processes[i],generateInitialPopulation(population)) for i in 1:procsCount]
    gen = Array(DNA,population*procsCount)

    for i in 0:(procsCount-1)
        gen[i*population+1:(i+1)*population] = fetch(remotesRef[i+1])
    end
    return gen
end

#@everywhere
#using Debug

#@debug
@everywhere function getIndexRamdomByScore(searchRanks,sumScore)
    TheChosenOne = rand()*sumScore
    #print()

    lastScore = 0.0
    i = int64(floor(population / 2))
    i = i == 0? 1:i
    half = i
    hasNotFound = true
    while hasNotFound
        if TheChosenOne >= searchRanks[i][1] && TheChosenOne <= searchRanks[i][2]
            #@bp
            return i
        else
            #@bp
            half = half > 1? int64(floor(half / 2)):1
            if TheChosenOne < searchRanks[i][1]
                i = i - half
            else
                i = i + half
            end
        end

    end
end

@everywhere function reproduce(a,b)
    DNA(rand() > 0.5 ? a.differenceVelocityFast: b.differenceVelocityFast,
    rand() > 0.5 ? a.differenceVelocityFine: b.differenceVelocityFine,
    rand() > 0.5 ? a.differenceVelocitySlow: b.differenceVelocitySlow,
    rand() > 0.5 ? a.angleFront: b.angleFront,
    rand() > 0.5 ? a.angleBack: b.angleBack,
    rand() > 0.5 ? a.angleCenter: b.angleCenter)
end

@everywhere function mutate(a)
    mutationFunc = () -> rand()*0.1-0.05;
    DNA(cromossome(a.differenceVelocityFast.mean, a.differenceVelocityFast.twoSdSquared,mutationFunc(),mutationFunc()),
    cromossome(a.differenceVelocityFine.mean, a.differenceVelocityFine.twoSdSquared,mutationFunc(),mutationFunc()),
    cromossome(a.differenceVelocitySlow.mean, a.differenceVelocitySlow.twoSdSquared,mutationFunc(),mutationFunc()),
    cromossome(a.angleFront.mean, a.angleFront.twoSdSquared,mutationFunc(),mutationFunc()),
    cromossome(a.angleBack.mean, a.angleBack.twoSdSquared,mutationFunc(),mutationFunc()),
    cromossome(a.angleCenter.mean, a.angleCenter.twoSdSquared,mutationFunc(),mutationFunc()))
end
@everywhere function generateSon(searchRanks,sumScore,generation)
    i1 = getIndexRamdomByScore(searchRanks,sumScore)
    i2 = getIndexRamdomByScore(searchRanks,sumScore)
    #print(i1)
    #print("\n")
    reproduce(generation[i1], generation[i2])
end

@everywhere function generateSons(searchRanks,sumScore,count,generation)
    return [generateSon(searchRanks,sumScore,generation) for x in 1:count]
end

@everywhere function generateSonsAssync(searchRanks,sumScore,count,generation)
    remotesRef = [@spawnat(processes[i],generateSons(searchRanks,sumScore,newBornsCount,generation)) for i in 1:procsCount]
    newGeneration = Array(DNA,population*procsCount)
    for i in 0:(procsCount-1)
        newGeneration[i*population+1:(i+1)*population] = fetch(remotesRef[i+1])
    end
end

@everywhere function evaluateBlock(inputs,outputs,generation)
    return map((microbe) -> evaluateIndividual(inputs,outputs,microbe),generation)
end

@everywhere function evaluateBlockAssync(inputs,outputs,generation)
    remotesRef = [@spawnat(processes[i+1],evaluateBlock(inputs,outputs,generation[i*population+1:(i+1)*population])) for i in 0:(procsCount-1)]
    score = Array(Float64,population*procsCount)
    for i in 0:(procsCount-1)
        score[i*population+1:(i+1)*population] = fetch(remotesRef[i+1])
    end
    return score
end

@everywhere function runGeneration(generation)
    outputs = Array(Float64,2,testsCount)
    inputs =  Array(Float64,2,testsCount)
    while true
        (subject,vMax) = generateTestSubject()

        outputs = calculateRightAnswer(subject,vMax)
        inputs = calculateAnglesAndVelocity(subject,vMax)
        if all(!isinf(outputs)) && all(!isinf(inputs)) && all(!isnan(outputs)) && all(!isnan(inputs))
            break
        end
        info("needed recalculate subject input and outputs.")
    end

    for i in 1:mutationCount
        mutation = rand(1:population)
        generation[mutation] = mutate(generation[mutation])
    end
    score = evaluateBlock(inputs,outputs,generation)
    #score = evaluateBlockAssync(inputs,outputs,generation)


    score = map((x) -> (isinf(x) || isnan(x)) ? 1e10:x,score)
    invertedScore =  1.0 ./ score
    sumScore = sum(invertedScore)
    searchRanks = Array((Float64,Float64),population*procsCount)

    sumation = 0.0
    for i in 1:(population*procsCount)
        nextSumation = sumation + invertedScore[i]
        searchRanks[i] = (sumation,nextSumation)
        sumation = nextSumation
    end
    #print(length(searchRanks))
    #print("\n")
    #print(length(generation))
    #print("\n")

    #newGeneration = generateSons(searchRanks,sumScore,newBornsCount,generation)
    #newGeneration = generateSonsAssync(searchRanks,sumScore,newBornsCount,generation)
    #survivorsCount = ((population-newBornsCount)*procsCount)
    #if survivorsCount > 0
    #    permArray = sortperm(score, alg=QuickSort)
    #    survivors = generation[permArray[1:survivorsCount]]
    #    generation = [newGeneration, survivors]
    #else
    #    generation = newGeneration
    #end


    #newBorns = pmap(generateSon,1:newBornsCount)
    #survivors = pmap((x) -> generation[getIndexRamdomByScore()],1:(population - newBornsCount))
    #for i in 1:newBornsCount

    #end
    #survivors = Array(DNA,population - newBornsCount)
    #for i in 1:(population - newBornsCount)
    #    survivors[i] =
    #end

    (generation,minimum(score))
end
@everywhere function runGenerations(count,generation)

    for i in 1:count
        (generation,mini) = runGeneration(generation)
        print("best score = $mini \n")
    end
    generation
end

#gen = generateInitialPopulation(population*procsCount)
#gen = generateInitialPopulationAssync();


#print(length(gen))3
#print("\n")
#tic()
#gen = runGenerations(580,gen)
#toc()

#dados = [[x.differenceVelocityFast.mean,sqrt(x.differenceVelocityFast.twoSdSquared/2),x.differenceVelocityFine.mean,sqrt(x.differenceVelocityFine.twoSdSquared/2),x.differenceVelocitySlow.mean,sqrt(x.differenceVelocitySlow.twoSdSquared/2),x.angleFront.mean,sqrt(x.angleFront.twoSdSquared/2),x.angleBack.mean,sqrt(x.angleBack.twoSdSquared/2),x.angleCenter.mean,sqrt(x.angleCenter.twoSdSquared/2)] for x in gen]
#writecsv("bkpGeneration2.csv",dados)
"blabla"
