using JuliaFuzzy.EngineSkeleton
using JuliaFuzzy.Norms.TNorm
using JuliaFuzzy.Norms.Norm
using JuliaFuzzy.Norms.SNorm
using JuliaFuzzy.Norms.TNorms.Minimum
using JuliaFuzzy.Norms.SNorms.Maximum
using JuliaFuzzy.Norms.TNorms.AlgebraicProduct
using JuliaFuzzy.Norms.SNorms.AlgebraicSum
using JuliaFuzzy.Defuzzifiers.Centroid
using JuliaFuzzy.Rules.Rule
using JuliaFuzzy.Rules.RuleBlock
using JuliaFuzzy.Variables.InputVariable
using JuliaFuzzy.Variables.OutputVariable
using JuliaFuzzy.Terms.Constant
using JuliaFuzzy.Terms.Triangle
using JuliaFuzzy.Terms.Gaussian
using JuliaFuzzy.Terms.Term

using JuliaFuzzy.parseRule
using JuliaFuzzy.configure
import JuliaFuzzy.buildFunction

function buildFuzzyObstacle()
    #include("JuliaFuzzy\JuliaFuzzy.jl")
    #print(current_module())

    engineSkeleton = EngineSkeleton{Float64}()
    engineSkeleton.name = :obstacleFuzzyForce
    engineSkeleton.inputVariables = InputVariable{Float64}[]
    engineSkeleton.outputVariables = OutputVariable{Float64}[]
    engineSkeleton.ruleBlocks = RuleBlock[]
    engineSkeleton.conjunction = Minimum()
    engineSkeleton.disjunction = Maximum()
    engineSkeleton.activation = AlgebraicProduct()
    engineSkeleton.accumulation = AlgebraicSum()
    engineSkeleton.defuzzifier = FastCentroid{Float64}()

    Distance = InputVariable{Float64}()
    Distance.value = 0.000
    Distance.name = :Distance
    Distance.maxValue = 10.0
    Distance.minValue = -0.1
    Distance.terms = Term[]


    push!(Distance.terms,Gaussian{Float64}(:NEAR, -75.0, 0.1));
    push!(Distance.terms,Gaussian{Float64}(:FAR, 25.0, 0.3));

    push!(engineSkeleton.inputVariables,Distance)

    Force = OutputVariable{Float64}()
    Force.name = :Force
    Force.maxValue = 10.0
    Force.minValue = -0.01
    Force.terms = Term[]

    push!(Force.terms,Triangle{Float64}(:LOW, -3.0, 3.0));
    push!(Force.terms,Triangle{Float64}(:HIGH, 2.99, 3.01));

    push!(engineSkeleton.outputVariables,Force)

    PowerController = RuleBlock(:PowerController)
    push!(engineSkeleton.ruleBlocks,PowerController)

    rule1 = parseRule(engineSkeleton,"if Distance is NEAR then Force is HIGH")
    push!(PowerController.rules,rule1)

    rule2 = parseRule(engineSkeleton,"if Distance is FAR then Force is LOW")
    push!(PowerController.rules,rule2)

    configure(engineSkeleton)
    functionT = buildFunction(engineSkeleton)
    return eval(functionT)
end
