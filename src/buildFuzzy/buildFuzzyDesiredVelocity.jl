using JuliaFuzzy.EngineSkeleton
using JuliaFuzzy.Norms.TNorm
using JuliaFuzzy.Norms.Norm
using JuliaFuzzy.Norms.SNorm
using JuliaFuzzy.Norms.TNorms.Minimum
using JuliaFuzzy.Norms.SNorms.Maximum
using JuliaFuzzy.Norms.TNorms.AlgebraicProduct
using JuliaFuzzy.Norms.SNorms.AlgebraicSum
using JuliaFuzzy.Defuzzifiers.FastCentroid
using JuliaFuzzy.Rules.Rule
using JuliaFuzzy.Rules.RuleBlock
using JuliaFuzzy.Variables.InputVariable
using JuliaFuzzy.Variables.OutputVariable
using JuliaFuzzy.Terms
using JuliaFuzzy.Terms.Constant
using JuliaFuzzy.Terms.Triangle
using JuliaFuzzy.Terms.Gaussian
using JuliaFuzzy.Terms.Term

using JuliaFuzzy.parseRule
using JuliaFuzzy.configure
using JuliaFuzzy.buildFunction

function buildFuzzyDesiredVelocity()
    #include("JuliaFuzzy\JuliaFuzzy.jl")

    desiredFuzzyFunctionVelocity = EngineSkeleton{Float64}()
    desiredFuzzyFunctionVelocity.name = "desiredFuzzyVelocity"
    desiredFuzzyFunctionVelocity.inputVariables = InputVariable{Float64}[]
    desiredFuzzyFunctionVelocity.outputVariables = OutputVariable{Float64}[]
    desiredFuzzyFunctionVelocity.ruleBlocks = RuleBlock[]
    desiredFuzzyFunctionVelocity.conjunction = AlgebraicProduct()
    desiredFuzzyFunctionVelocity.disjunction = AlgebraicSum()
    desiredFuzzyFunctionVelocity.activation = Minimum()
    desiredFuzzyFunctionVelocity.accumulation = Maximum()
    desiredFuzzyFunctionVelocity.defuzzifier = FastCentroid{Float64}()

    VelocityDifference = InputVariable{Float64}()
    VelocityDifference.value = 0.000
    VelocityDifference.name = :VelocityDifference
    VelocityDifference.maxValue = 10.0
    VelocityDifference.minValue = -10.0
    VelocityDifference.terms = Term[]

    push!(VelocityDifference.terms,Gaussian{Float64}(:VERYSLOW, -2.0, 0.4,Terms.GaussianType_Left))
    push!(VelocityDifference.terms,Gaussian{Float64}(:SLOW, -1.0, 0.4))
    push!(VelocityDifference.terms,Gaussian{Float64}(:FINE, 0.0, 0.4))
    push!(VelocityDifference.terms,Gaussian{Float64}(:FAST, 1.0, 0.4))
    push!(VelocityDifference.terms,Gaussian{Float64}(:VERYFAST, 2.0, 0.4,Terms.GaussianType_Right))

    #plotVariable(VelocityDifference)

    push!(desiredFuzzyFunctionVelocity.inputVariables,VelocityDifference)

    Force = OutputVariable{Float64}()
    Force.name = :Force
    Force.maxValue = 4.0
    Force.minValue = -4.0
    Force.terms = Term[]

    push!(Force.terms,Triangle{Float64}(:STRONGNEGATIVE, -3.0, -1.0))
    push!(Force.terms,Triangle{Float64}(:NEGATIVE, -2.0, 0.0))
    push!(Force.terms,Triangle{Float64}(:ZERO, -1.0, 1.0))
    push!(Force.terms,Triangle{Float64}(:POSITIVE, 0.0, 2.0))
    push!(Force.terms,Triangle{Float64}(:STRONGPOSITIVE, 1.0, 3.0))

    push!(desiredFuzzyFunctionVelocity.outputVariables,Force)

    DesiredRuleBlock = RuleBlock(:DesiredRuleBlock)
    push!(desiredFuzzyFunctionVelocity.ruleBlocks,DesiredRuleBlock)

    rule1 = parseRule(desiredFuzzyFunctionVelocity,"if VelocityDifference is VERYSLOW then Force is STRONGPOSITIVE")
    push!(DesiredRuleBlock.rules,rule1)

    rule2 = parseRule(desiredFuzzyFunctionVelocity,"if VelocityDifference is SLOW then Force is POSITIVE")
    push!(DesiredRuleBlock.rules,rule2)

    rule3 = parseRule(desiredFuzzyFunctionVelocity,"if VelocityDifference is FINE then Force is ZERO")
    push!(DesiredRuleBlock.rules,rule3)

    rule4 = parseRule(desiredFuzzyFunctionVelocity,"if VelocityDifference is FAST then Force is NEGATIVE")
    push!(DesiredRuleBlock.rules,rule4)

    rule5 = parseRule(desiredFuzzyFunctionVelocity,"if VelocityDifference is VERYFAST then Force is STRONGNEGATIVE")
    push!(DesiredRuleBlock.rules,rule5)

    configure(desiredFuzzyFunctionVelocity)

    return eval(buildFunction(desiredFuzzyFunctionVelocity))
end
