#using Debug
function treatAngle(angle)
    twopi = 2*pi
    if(angle < 0.0)
        return angle + twopi
    elseif(angle > twopi)
        return angle - twopi
    else
        return angle
    end
end
