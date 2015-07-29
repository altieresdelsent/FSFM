function checkObjective(position, objectives)
    for obj in objectives
        diffe = @minus(position,obj.position)
        distance = @dot(diffe,diffe)
        if distance < (obj.radius*obj.radius)
            return true
        end
    end
    return false
end
