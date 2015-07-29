#include("JuliaFuzzy/JuliaFuzzy.jl")

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
using JuliaFuzzy.buildFunction


function buildFuzzyGranular()

    engineSkeleton = EngineSkeleton{Float64}()
    engineSkeleton.name = :granularFuzzyForce
    engineSkeleton.inputVariables = InputVariable{Float64}[]
    engineSkeleton.outputVariables = OutputVariable{Float64}[]
    engineSkeleton.ruleBlocks = RuleBlock[]
    engineSkeleton.conjunction = Minimum()
    engineSkeleton.disjunction = Maximum()
    engineSkeleton.activation = AlgebraicProduct()
    engineSkeleton.accumulation = AlgebraicSum()
    engineSkeleton.defuzzifier = FastCentroid{Float64}()


    Velocity = InputVariable{Float64}()
    Velocity.value = 0.000
    Velocity.name = :Velocity
    Velocity.maxValue = 3.0
    Velocity.minValue = 0.0
    Velocity.terms = Term[]

    push!(Velocity.terms,Triangle{Float64}(:SLOW, 0, 1.5));
    push!(Velocity.terms,Triangle{Float64}(:MEDIUM, 0.75, 2.25));
    push!(Velocity.terms,Triangle{Float64}(:FAST, 1.5, 3.0));

    push!(engineSkeleton.inputVariables,Velocity)

    Distance = InputVariable{Float64}()
    Distance.value = 0.000
    Distance.name = :Distance
    Distance.maxValue = 0.0
    Distance.minValue = -0.6
    Distance.terms = Term[]

    push!(Distance.terms,Triangle{Float64}(:NEAR, -0.6, -0.3));
    push!(Distance.terms,Triangle{Float64}(:MEDIUM, -0.45, -0.15));
    push!(Distance.terms,Triangle{Float64}(:FAR, -0.3, 0.0));

    push!(engineSkeleton.inputVariables,Distance)

    Force = OutputVariable{Float64}()
    Force.name = :Force
    Force.maxValue = 4000.0
    Force.minValue = 0.0
    Force.terms = Term[]

    push!(Force.terms,Triangle{Float64}(:LOW, 0.0, 2000.0));
    push!(Force.terms,Triangle{Float64}(:MEDIUM, 1000.0, 3000.0));
    push!(Force.terms,Triangle{Float64}(:HIGH, 2000.0, 4000.0));

    push!(engineSkeleton.outputVariables,Force)


    ForceT = OutputVariable{Float64}()
    ForceT.name = :ForceT
    ForceT.maxValue = 4000.0
    ForceT.minValue = 0.0
    ForceT.terms = Term[]

    push!(ForceT.terms,Triangle{Float64}(:LOW, 0.0, 2000.0));
    push!(ForceT.terms,Triangle{Float64}(:MEDIUM, 1000.0, 3000.0));
    push!(ForceT.terms,Triangle{Float64}(:HIGH, 2000.0, 4000.0));

    push!(engineSkeleton.outputVariables,ForceT)

    GranularController = RuleBlock(:GranularController)
    push!(engineSkeleton.ruleBlocks,GranularController)

    rule1 = parseRule(engineSkeleton,"if Distance is NEAR then Force is HIGH")
    push!(GranularController.rules,rule1)

    rule2 = parseRule(engineSkeleton,"if Distance is MEDIUM then Force is MEDIUM")
    push!(GranularController.rules,rule2)

    rule3 = parseRule(engineSkeleton,"if Distance is FAR then Force is LOW")
    push!(GranularController.rules,rule3)

    TangentialController = RuleBlock(:TangentialController)
    push!(engineSkeleton.ruleBlocks,TangentialController)

    rule1 = parseRule(engineSkeleton,"if Distance is NEAR and Velocity is FAST then ForceT is HIGH")
    push!(TangentialController.rules,rule1)

    rule2 = parseRule(engineSkeleton,"if Distance is NEAR and Velocity is MEDIUM then ForceT is HIGH")
    push!(TangentialController.rules,rule2)

    rule3 = parseRule(engineSkeleton,"if Distance is NEAR and Velocity is SLOW then ForceT is MEDIUM")
    push!(TangentialController.rules,rule3)

    rule4 = parseRule(engineSkeleton,"if Distance is MEDIUM and Velocity is FAST then ForceT is HIGH")
    push!(TangentialController.rules,rule4)

    rule5 = parseRule(engineSkeleton,"if Distance is MEDIUM and Velocity is MEDIUM then  ForceT is MEDIUM")
    push!(TangentialController.rules,rule5)

    rule6 = parseRule(engineSkeleton,"if Distance is MEDIUM and Velocity is SLOW then ForceT is LOW")
    push!(TangentialController.rules,rule6)

    rule7 = parseRule(engineSkeleton,"if Distance is FAR and Velocity is FAST then ForceT is MEDIUM")
    push!(TangentialController.rules,rule7)

    rule8 = parseRule(engineSkeleton,"if Distance is FAR and Velocity is MEDIUM then ForceT is LOW")
    push!(TangentialController.rules,rule8)

    rule9 = parseRule(engineSkeleton,"if Distance is FAR and Velocity is SLOW then ForceT is LOW")
    push!(TangentialController.rules,rule9)

    configure(engineSkeleton)
    functionGranular = buildFunction(engineSkeleton)
    return eval(functionGranular)


end
