using types
using LibExpat
#using Debug
function loadObjectives(objectivesMatLab)
    (m,n) = size(objectivesMatLab)
    objectives = objectivesMatLab
    retorno = Array(Objective,n)
    for i = 1:n
        retorno[i] = Objective(Point(objectives[1,i], objectives[2,i]),objectives[3,i]);
    end
    return retorno
end

function loadObjectives(objectivesXML::Array{ETree,1})
    retorno = Array(Objective,length(objectivesXML))
    i = 0
    for objectiveXML in objectivesXML
    	i = i + 1
    	center = Point(parsefloat(objectiveXML.attr["x"]), parsefloat(objectiveXML.attr["y"]))

        retorno[i] = Objective(center,parsefloat(objectiveXML.attr["r"]))
    end
    return retorno
end

