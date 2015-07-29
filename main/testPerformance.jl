using types
include("fastNorm.jl")
function testPerformance( )
number = 10^6;
way = WayPoint([0.0, 0.0], 0.0, 0.0, 0.0)
ped = Pedestrian([166.413, -108.206],[ -0.366757,  -1.07195], 1.0,way);
other = Pedestrian([164.444,  -108.468],[-0.363381,  -1.10484], 1.0,way);
test = 7*rand(number,2)
test2 = rand(number,2)
test3 = 7*rand(number,2)
test4 = rand(number,2)
peds = Array(Pedestrian,number)
others = Array(Pedestrian,number)
for i = 1:number
    peds[i] = Pedestrian([test[i,1], test[i,2]],[test2[i,1], test2[i,2]], 1.0,way);
    others[i] = Pedestrian([test3[i,1], test3[i,2]],[test4[i,1], test4[i,2]], 1.0,way);
end


A = time_ns();
tic()
for i = 1:number
    ped = peds[i]
    other = others[i]
    result = [0.0, 0.0]
    gamma::Float64 = 0.35
    n::Float64 = 2.0
    n_prime::Float64 = 3.0
    lambdaImportance::Float64 = 2.0

    diffe = other.position - ped.position

    diffeDirectionLength::Float64 = sqrt(dot(diffe,diffe));#;

    diffeDirection = diffe / diffeDirectionLength;

    velDiff = ped.velocity -other.velocity;

    interactionVector = lambdaImportance * velDiff + diffeDirection;

    #diffeDirectionLength = diffeDirectionLength - 0.4;
    #if(diffeDirectionLength <= 0)
    #    diffeDirectionLength = 0.000001;
    #end

    interactionLength::Float64 = sqrt(dot(interactionVector,interactionVector));
    #return interactionVector, interactionVector
    interactionDirection = interactionVector / interactionLength;

    angleInteraction::Float64 = atan2(interactionDirection[2],interactionDirection[1]);

    angleDirection::Float64 = atan2(diffeDirection[2],diffeDirection[1]);

    thetaAngle::Float64 = angleDirection - angleInteraction;

    if(thetaAngle > pi)
        thetaAngle =thetaAngle - 2*pi;
    elseif(thetaAngle <= -pi)
        thetaAngle = thetaAngle + 2*pi;
    end;
    thetaSign::Float64 = 0.0;
    if (abs(thetaAngle) > 0.0000001)
        thetaSign = (thetaAngle/abs(thetaAngle));
    end;


    B::Float64 = gamma * interactionLength;
    parameter::Float64 = (B*thetaAngle)^2;

    forceVelocityAmount::Float64 = -exp(-diffeDirectionLength/B - (n_prime^2*parameter));

    forceAngleAmount::Float64 = -thetaSign * exp(-diffeDirectionLength/B - (n^2*parameter));

    forceVelocity = forceVelocityAmount * interactionDirection;

    interactionDirectionLeft = [0.0, 0.0];

    interactionDirectionLeft[1] = -interactionDirection[2];

    interactionDirectionLeft[2] = interactionDirection[1];
    forceAngle = forceAngleAmount * interactionDirectionLeft;

    result = forceVelocity + forceAngle;
end;
return toc()
return (time_ns() - A)/(10^9);


end

