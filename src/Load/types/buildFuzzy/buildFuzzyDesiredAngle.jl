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

function buildFuzzyDesiredAngle()
    #include("JuliaFuzzy\JuliaFuzzy.jl")


    desiredFuzzyFunctionAngle = EngineSkeleton{Float64}()
    desiredFuzzyFunctionAngle.name = "desiredFuzzyAngleAngle"
    desiredFuzzyFunctionAngle.inputVariables = InputVariable{Float64}[]
    desiredFuzzyFunctionAngle.outputVariables = OutputVariable{Float64}[]
    desiredFuzzyFunctionAngle.ruleBlocks = RuleBlock[]
    desiredFuzzyFunctionAngle.conjunction = AlgebraicProduct()
    desiredFuzzyFunctionAngle.disjunction = AlgebraicSum()
    desiredFuzzyFunctionAngle.activation = Minimum()
    desiredFuzzyFunctionAngle.accumulation = Maximum()
    desiredFuzzyFunctionAngle.defuzzifier = FastCentroid{Float64}()

    DirectionAngle = InputVariable{Float64}()
    DirectionAngle.value = 0.000
    DirectionAngle.name = :DirectionAngle
    DirectionAngle.maxValue = pi
    DirectionAngle.minValue = -pi
    DirectionAngle.terms = Term[]

    push!(DirectionAngle.terms,Gaussian{Float64}(:BACKLEFT, -pi, pi*0.2))
    push!(DirectionAngle.terms,Gaussian{Float64}(:FRONTLEFT, -pi*0.5, pi*0.2))
    push!(DirectionAngle.terms,Gaussian{Float64}(:BACKRIGHT, pi, pi*0.2))
    push!(DirectionAngle.terms,Gaussian{Float64}(:FRONT, 0.0, pi*0.2))
    push!(DirectionAngle.terms,Gaussian{Float64}(:FRONTRIGHT, pi*0.5, pi*0.2))
    push!(DirectionAngle.terms,Gaussian{Float64}(:BACKRIGHT, pi, pi*0.2))



    push!(desiredFuzzyFunctionAngle.inputVariables,DirectionAngle)

    AngleTurn = OutputVariable{Float64}()
    AngleTurn.name = :AngleTurn
    AngleTurn.maxValue = pi
    AngleTurn.minValue = -pi
    AngleTurn.terms = Term[]

    push!(AngleTurn.terms,Triangle{Float64}(:STRONGLEFT, -1.5*pi, -0.5*pi))
    push!(AngleTurn.terms,Triangle{Float64}(:WEAKLEFT, -pi*1.0, 0.0))
    push!(AngleTurn.terms,Triangle{Float64}(:CENTER, -pi*0.5, pi*0.5))
    push!(AngleTurn.terms,Triangle{Float64}(:WEAKRIGHT, 0.0, pi*1.0))
    push!(AngleTurn.terms,Triangle{Float64}(:STRONGRIGHT, 0.5*pi, 1.5*pi))

    push!(desiredFuzzyFunctionAngle.outputVariables,AngleTurn)

    DesiredRuleBlock = RuleBlock(:DesiredRuleBlock)
    push!(desiredFuzzyFunctionAngle.ruleBlocks,DesiredRuleBlock)

    rule1 = parseRule(desiredFuzzyFunctionAngle,"if DirectionAngle is BACKLEFT then AngleTurn is STRONGRIGHT")
    push!(DesiredRuleBlock.rules,rule1)

    rule2 = parseRule(desiredFuzzyFunctionAngle,"if DirectionAngle is FRONTLEFT then AngleTurn is WEAKRIGHT")
    push!(DesiredRuleBlock.rules,rule2)

    rule3 = parseRule(desiredFuzzyFunctionAngle,"if DirectionAngle is FRONT then AngleTurn is CENTER")
    push!(DesiredRuleBlock.rules,rule3)

    rule4 = parseRule(desiredFuzzyFunctionAngle,"if DirectionAngle is FRONTRIGHT then AngleTurn is WEAKLEFT")
    push!(DesiredRuleBlock.rules,rule4)

    rule5 = parseRule(desiredFuzzyFunctionAngle,"if DirectionAngle is BACKRIGHT then AngleTurn is STRONGLEFT")
    push!(DesiredRuleBlock.rules,rule5)

    configure(desiredFuzzyFunctionAngle)

    return eval(buildFunction(desiredFuzzyFunctionAngle))
end
