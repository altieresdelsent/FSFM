function getInteractionVector(velocityRelative,repulsive)
	engine = scene.engineSocialDirection
	engine.inputVariables.Velocity.value = velocityRelative[1]
	engine.inputVariables.Repulsive.value = repulsive[1]
	
	JuliaFuzzy.process(engine)
    x = JuliaFuzzy.Variables.defuzzify(engine.outputVariables.Direction)

    scene.engineSocialDirection.inputVariables.Velocity.value = velocityRelative[2]
	scene.engineSocialDirection.inputVariables.Repulsive.value = repulsive[2]
	
	JuliaFuzzy.process(engine)
    y = JuliaFuzzy.Variables.defuzzify(engine.outputVariables.Direction)
    #print(lambdaImportance * velDiff + diffeDirection)
    #print("\n")
    #print([x,y])
    #throw("teesteeee")
    return [x,y]
end