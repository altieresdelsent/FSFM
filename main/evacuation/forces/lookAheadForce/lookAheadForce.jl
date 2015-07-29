using types
function lookAheadForce( pedestrian, pedestrians, currentDesiredForce )
#lookAheadForce Counts the pedestrians that are in front of you and turn
#left of right in the side with less pedestrians.
#   Detailed explanation goes here

    lookforwardcount = 0.0
    force = [0.0,0.0]
    ped = pedestrian.position
    for otherF in pedestrians
        if(!otherF.active)
            continue
        end

        other = otherF.position
        velocityOther = otherF.velocity

        diffee = other - ped
        distSquared = dot(diffee,diffee)
        #don't compute this force for the agent himself
        if(distSquared == 0.0)
            continue
        end



        at2v = atan2(-currentDesiredForce[1], -currentDesiredForce[2])
        at2d = atan2(-diffee[1], -diffee[2])
        at2v2 = atan2(-velocityOther[1], -velocityOther[2])
        s = at2d - at2v
        if (s > pi)
            s = s + 2.0*pi
        end

        if (s < -pi)
            s = s + 2.0*pi
        end

        vv = at2v - at2v2
        if (vv > pi)
            vv = vv - 2.0*pi
        end

        if (vv < -pi)
            vv = vv + 2.0*pi
        end

        if (abs(vv) > 2.5) # opposite direction
            if ((s < 0.0) && (s > -0.3))# position before me, in my direction
                lookforwardcount= lookforwardcount - 1.0
            end
            if ((s > 0.0) && (s < 0.3))
                lookforwardcount = lookforwardcount + 1.0
            end
        end
    end

    if (lookforwardcount < 0.0)
        force[1] = 0.5 *  currentDesiredForce[2]
        force[2] = 0.5 * -currentDesiredForce[1]
    end
    if (lookforwardcount > 0.0)
        force[1] = 0.5 * -currentDesiredForce[2]
        force[1] = 0.5 *  currentDesiredForce[1]
    end

    return force


end

