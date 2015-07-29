include("JuliaFuzzy/JuliaFuzzy.jl")
include("buildRulesFuzzy.jl")
function testObstacleFuzzy()
   engine = buildRulesFuzzy()
   for i in 1:1000
      d = i / 100
      engine.inputVariables.Distance.value = d
      JuliaFuzzy.process(engine)
      finalValue = JuliaFuzzy.Variables.defuzzify(engine.outputVariables.Force)
      print("Distance=$d   -----   ")
      print("Force=$finalValue\n")
   end
end
