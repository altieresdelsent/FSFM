using JuliaFuzzy.EngineSkeleton
using JuliaFuzzy.Norms.TNorm
using JuliaFuzzy.Norms.Norm
using JuliaFuzzy.Norms.SNorm
using JuliaFuzzy.Norms.TNorms.Minimum
using JuliaFuzzy.Norms.SNorms.Maximum
using JuliaFuzzy.Norms.TNorms.AlgebraicProduct
using JuliaFuzzy.Norms.TNorms.DrasticProduct
using JuliaFuzzy.Norms.SNorms.AlgebraicSum
using JuliaFuzzy.Defuzzifiers.Centroid
using JuliaFuzzy.Defuzzifiers.FastCentroid
using JuliaFuzzy.Rules.Rule
using JuliaFuzzy.Rules.RuleBlock
using JuliaFuzzy.Variables.InputVariable
using JuliaFuzzy.Variables.OutputVariable
using JuliaFuzzy.Terms.Constant
using JuliaFuzzy.Terms.Triangle
using JuliaFuzzy.Terms.Gaussian
using JuliaFuzzy.Terms.Sigmoid
using JuliaFuzzy.Terms.Term

using JuliaFuzzy.parseRule
using JuliaFuzzy.configure
using JuliaFuzzy.buildFunction
using JuliaFuzzy.firstConfiguration

function buildFuzzySocial()
    #include("JuliaFuzzy\JuliaFuzzy.jl")

    engineSkeleton = EngineSkeleton{Float64}()
    engineSkeleton.name = :socialFuzzyForce
    engineSkeleton.inputVariables = InputVariable{Float64}[]
    engineSkeleton.outputVariables = OutputVariable{Float64}[]
    engineSkeleton.ruleBlocks = RuleBlock[]
    engineSkeleton.conjunction = AlgebraicProduct()
    engineSkeleton.disjunction = Maximum()
    engineSkeleton.activation = Minimum()
    engineSkeleton.accumulation = Maximum()
    engineSkeleton.defuzzifier = FastCentroid{Float64}()

    Distance = InputVariable{Float64}()
    Distance.value = 0.000
    Distance.name = :Distance
    #Distance.maxValue = 4.0 + (1.5*5)
    #Distance.minValue = 0.0 - (0.2*5)
    Distance.terms = Term[]

    push!(Distance.terms,Sigmoid{Float64}(:NEAR,-1.8, 2.5))
    push!(Distance.terms,Sigmoid{Float64}(:FAR, 1.0,2.5))

    push!(engineSkeleton.inputVariables,Distance)

    Angle = InputVariable{Float64}()
    Angle.value = 0.000
    Angle.name = :Angle
    #Angle.maxValue = pi + (pi*0.3*5)
    #Angle.minValue = pi - (pi*0.1*5)
    Angle.terms = Term[]

    push!(Angle.terms,Gaussian{Float64}(:LITTLE, 0.0,pi*0.20))
    push!(Angle.terms,Gaussian{Float64}(:BIG, pi,pi*0.35))

    push!(engineSkeleton.inputVariables,Angle)

    VelocityRelative = InputVariable{Float64}()
    VelocityRelative.value = 0.000
    VelocityRelative.name = :VelocityRelative
    #VelocityRelative.maxValue = 0.5 + (1.0*6)
    #VelocityRelative.minValue = 0.1 - (0.2*5)
    VelocityRelative.terms = Term[]

    push!(VelocityRelative.terms,Sigmoid{Float64}(:FAST,1.0,2.4))
    push!(VelocityRelative.terms,Sigmoid{Float64}(:SLOW,-6.0,1.7))

    push!(engineSkeleton.inputVariables,VelocityRelative)

    Force = OutputVariable{Float64}()
    Force.name = :Force
    reducer = 1.0
    shifter = 0.0
    Force.maxValue = 1.0*reducer+shifter
    Force.minValue = -0.8*reducer+shifter
    Force.terms = Term[]

    push!(Force.terms,Triangle{Float64}(:LOW,-0.8*reducer+shifter, 0.8*reducer+shifter))
    push!(Force.terms,Triangle{Float64}(:HIGH, 0.6*reducer+shifter, 1.0*reducer+shifter))

    push!(engineSkeleton.outputVariables,Force)

    PowerController = RuleBlock(:PowerController)
    push!(engineSkeleton.ruleBlocks,PowerController)

    rule1 = parseRule(engineSkeleton,"if Angle is BIG then Force is LOW")
    push!(PowerController.rules,rule1)

    rule2 = parseRule(engineSkeleton,"if Distance is FAR then Force is LOW")
    push!(PowerController.rules,rule2)

    rule3 = parseRule(engineSkeleton,"if VelocityRelative is SLOW then Force is LOW")
    push!(PowerController.rules,rule3)
    #
    rule4 = parseRule(engineSkeleton,"if Angle is LITTLE and VelocityRelative is FAST and Distance is NEAR then Force is HIGH")
    push!(PowerController.rules,rule4)

    configure(engineSkeleton)

    functionTeste = buildFunction(engineSkeleton)
    return eval(functionTeste)
end
