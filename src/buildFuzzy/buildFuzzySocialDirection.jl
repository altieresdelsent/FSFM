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

function buildFuzzySocialDirection()
    #include("JuliaFuzzy\JuliaFuzzy.jl")

    desiredFuzzyDirectionSocial = EngineSkeleton{Float64}()
    desiredFuzzyDirectionSocial.name = "DirectionSocial"
    desiredFuzzyDirectionSocial.inputVariables = InputVariable{Float64}[]
    desiredFuzzyDirectionSocial.outputVariables = OutputVariable{Float64}[]
    desiredFuzzyDirectionSocial.ruleBlocks = RuleBlock[]
    desiredFuzzyDirectionSocial.conjunction = AlgebraicProduct()
    desiredFuzzyDirectionSocial.disjunction = AlgebraicSum()
    desiredFuzzyDirectionSocial.activation = Minimum()
    desiredFuzzyDirectionSocial.accumulation = Maximum()
    desiredFuzzyDirectionSocial.defuzzifier = FastCentroid{Float64}()

    RelativeVelocity = InputVariable{Float64}()
    RelativeVelocity.value = 0.000
    RelativeVelocity.name = :RelativeVelocity
    RelativeVelocity.maxValue = pi
    RelativeVelocity.minValue = -pi
    RelativeVelocity.terms = Term[]

    push!(RelativeVelocity.terms,Gaussian{Float64}(:ZERO, 0.0, 0.4,Terms.GaussianType_Left))
    push!(RelativeVelocity.terms,Gaussian{Float64}(:WEAK, 1.0, 0.4))
    push!(RelativeVelocity.terms,Gaussian{Float64}(:STRONG, 2.0, 0.4,Terms.GaussianType_Right))

    push!(desiredFuzzyDirectionSocial.inputVariables,RelativeVelocity)

    TurnPercentil = OutputVariable{Float64}()
    TurnPercentil.name = :TurnPercentil
    TurnPercentil.maxValue = pi
    TurnPercentil.minValue = -pi
    TurnPercentil.terms = Term[]

    push!(TurnPercentil.terms,Triangle{Float64}(:ZERO, -0.5, 0.5))
    push!(TurnPercentil.terms,Triangle{Float64}(:WEAK, 0.0, 1.0))
    push!(TurnPercentil.terms,Triangle{Float64}(:STRONG, 0.5, 1.5))

    push!(desiredFuzzyDirectionSocial.outputVariables,TurnPercentil)

    DesiredRuleBlock = RuleBlock(:DesiredRuleBlock)
    push!(desiredFuzzyDirectionSocial.ruleBlocks,DesiredRuleBlock)

    rule1 = parseRule(desiredFuzzyDirectionSocial,"if RelativeVelocity is ZERO then TurnPercentil is ZERO")
    push!(DesiredRuleBlock.rules,rule1)

    rule2 = parseRule(desiredFuzzyDirectionSocial,"if RelativeVelocity is WEAK then TurnPercentil is WEAK")
    push!(DesiredRuleBlock.rules,rule2)

    rule3 = parseRule(desiredFuzzyDirectionSocial,"if RelativeVelocity is STRONG then TurnPercentil is STRONG")
    push!(DesiredRuleBlock.rules,rule3)

    configure(desiredFuzzyDirectionSocial)

    DirectionSocialExpr = buildFunction(desiredFuzzyDirectionSocial)

    return eval(DirectionSocialExpr)
end
