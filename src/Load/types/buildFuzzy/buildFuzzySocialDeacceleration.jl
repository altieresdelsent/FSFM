using JuliaFuzzy.EngineSkeleton
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
using JuliaFuzzy.Terms
using JuliaFuzzy.Terms.Constant
using JuliaFuzzy.Terms.Triangle
using JuliaFuzzy.Terms.Gaussian
using JuliaFuzzy.Terms.Sigmoid
using JuliaFuzzy.Terms.Term

using JuliaFuzzy.parseRule
using JuliaFuzzy.configure
using JuliaFuzzy.buildFunction
using JuliaFuzzy.firstConfiguration

function buildFuzzySocialDeacceleration()
    #include("JuliaFuzzy\JuliaFuzzy.jl")

    FuzzyDeaccelerationSocial = EngineSkeleton{Float64}()
    FuzzyDeaccelerationSocial.name = "socialDeacceleration"
    FuzzyDeaccelerationSocial.inputVariables = InputVariable{Float64}[]
    FuzzyDeaccelerationSocial.outputVariables = OutputVariable{Float64}[]
    FuzzyDeaccelerationSocial.ruleBlocks = RuleBlock[]
    FuzzyDeaccelerationSocial.conjunction = AlgebraicProduct()
    FuzzyDeaccelerationSocial.disjunction = AlgebraicSum()
    FuzzyDeaccelerationSocial.activation = Minimum()
    FuzzyDeaccelerationSocial.accumulation = Maximum()
    FuzzyDeaccelerationSocial.defuzzifier = FastCentroid{Float64}()
    #print("FuzzyDeaccelerationSocial\n")
    Force = InputVariable{Float64}()
    Force.value = 0.000
    Force.name = :Force
    Force.maxValue = 0.0
    Force.minValue = 10.0
    Force.terms = Term[]
    #print("FuzzyDeaccelerationSocial\n")
    push!(Force.terms,Gaussian{Float64}(:ZERO, 0.0, 0.13333,Terms.GaussianType_Left))
    push!(Force.terms,Gaussian{Float64}(:WEAK, 0.3, 0.13333))
    push!(Force.terms,Gaussian{Float64}(:STRONG, 0.6, 0.13333,Terms.GaussianType_Right))

    push!(FuzzyDeaccelerationSocial.inputVariables,Force)
    #print("FuzzyDeaccelerationSocial\n")
    Deacceleration = OutputVariable{Float64}()
    Deacceleration.name = :Deacceleration
    Deacceleration.maxValue = 0.0
    Deacceleration.minValue = 1.0
    Deacceleration.terms = Term[]

    push!(Deacceleration.terms,Triangle{Float64}(:ZERO, -0.5, 0.5))
    push!(Deacceleration.terms,Triangle{Float64}(:WEAK, 0.0, 1.0))
    push!(Deacceleration.terms,Triangle{Float64}(:STRONG, 0.5, 1.5))
    #print("FuzzyDeaccelerationSocial\n")
    push!(FuzzyDeaccelerationSocial.outputVariables,Deacceleration)

    DeaccelerationRuleBlock = RuleBlock(:DeaccelerationRuleBlock)
    push!(FuzzyDeaccelerationSocial.ruleBlocks,DeaccelerationRuleBlock)

    rule1 = parseRule(FuzzyDeaccelerationSocial,"if Force is ZERO then Deacceleration is STRONG")
    push!(DeaccelerationRuleBlock.rules,rule1)

    rule2 = parseRule(FuzzyDeaccelerationSocial,"if Force is WEAK then Deacceleration is WEAK")
    push!(DeaccelerationRuleBlock.rules,rule2)

    rule3 = parseRule(FuzzyDeaccelerationSocial,"if Force is STRONG then Deacceleration is ZERO")
    push!(DeaccelerationRuleBlock.rules,rule3)
    #print("FuzzyDeaccelerationSocial\n")
    configure(FuzzyDeaccelerationSocial)
    #print("FuzzyDeaccelerationSocial\n")
    deaccelerationExpr = buildFunction(FuzzyDeaccelerationSocial)
    #print("FuzzyDeaccelerationSocial\n")
    return eval(deaccelerationExpr)
end
