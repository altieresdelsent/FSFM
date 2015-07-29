using types
include("getSlopeAndBias.jl")
function isVisibleOld(eyes, obstacles, point)
    (n,) = size(obstacles);
    diffe = eyes - point;
    x1 = eyes[1];
    y1 = eyes[2];

    x2 = point[1];
    y2 = point[2];

    diffX = diffe[1];
    diffY = diffe[2];

    isXFixed = (diffX == 0);
    isYFixed = (diffY == 0);

    xs = [x1 x2];
    ys = [y1 y2];

    xVision = maximum(xs);
    xObject = minimum(xs);

    yVision = maximum(ys);
    yObject = minimum(ys);

    slope = 0;
    bias = 0;

    sloveInv = 0;
    biasInv = 0;

    calcSlope = true;
    calcSlopeInv = true;

    for i = 1:n

        x1Obstacle = obstacles[i].start[1];
        y1Obstacle = obstacles[i].start[2];

        x2Obstacle = obstacles[i].ender[1];
        y2Obstacle = obstacles[i].ender[2];

        isXObsFixed = obstacles[i].funcCache.isXFixed;
        isYObsFixed = obstacles[i].funcCache.isYFixed;

        xStart = obstacles[i].funcCache.xMax;
        xEnd = obstacles[i].funcCache.xMin;

        yStart = obstacles[i].funcCache.yMax;
        yEnd = obstacles[i].funcCache.yMin;

        if(isXObsFixed)&&(isYObsFixed)
            continue;
        elseif(isXFixed)&&(isYFixed)
            continue;
        elseif(isXFixed)&&(isYObsFixed)
            xEncounter = x1;
            yEncounter = y1Obstacle;
        elseif(isYFixed)&&(isXObsFixed)
            xEncounter = x1Obstacle;
            yEncounter = y1;
        elseif(isXFixed)&&(isXObsFixed)
            if(xEnd == xVision)&&((yVision < yStart)||(yObject > yEnd))
                return false;
            else
                continue;
            end;
        elseif(isYFixed)&&(isYObsFixed)
            if(yEnd == yVision)&&((xVision < xStart)||(xObject > xEnd))
                return false;
            else
                continue;
            end;
        elseif(isXFixed)
            #(slope,bias) = getSlopeAndBias(diffXObs,diffYObs,x1Obstacle,y1Obstacle);
            xEncounter = x1;
            yEncounter = x1*obstacles[i].funcCache.slope + obstacles[i].bias;
        elseif(isYFixed)
            #(slope,bias) = getSlopeAndBias(diffYObs,diffXObs,y1Obstacle,x1Obstacle);
            xEncounter = y1*obstacles[i].funcCache.slopeInv + obstacles[i].biasInv;
            yEncounter = y1;
        elseif(isXObsFixed)
            if(calcSlope)
                (slope,bias) = getSlopeAndBias(diffX,diffY,x1,y1);
                calcSlope = false;
            end;
            xEncounter = x1Obstacle;
            yEncounter = x1Obstacle*slope + bias;
        elseif(isYObsFixed)
            if(calcSlopeInv)
                (slopeInv,biasInv) = getSlopeAndBias(diffY,diffX,y1,x1);
                calcSlopeInv = false;
            end;
            xEncounter = y1Obstacle*slopeInv + biasInv;
            yEncounter = y1Obstacle;
        else
            slopeObs = obstacles[i].funcCache.slope;
            biasObs = obstacles[i].funcCache.bias;
            if(calcSlope)
                (slope,bias) = getSlopeAndBias(diffX,diffY,x1,y1);
                calcSlope = false;
            end;

            if(slopeObs == slope)&&(biasObs == bias)&&((xObject <= xStart)&&(xObject >= xEnd)||(xVision <= xStart)&&(xVision >= xEnd))
                return false;
            elseif(slopeObs == slope)
                continue;
            else
                xEncounter = (biasObs - bias)/(slope-slopeObs);
                yEncounter = xEncounter*slope + bias;
            end;
        end;

        if(xEncounter <= xStart)&&(xEncounter >= xEnd)&&(yEncounter <= yStart)&&(yEncounter >= yEnd)&&(xEncounter <= xVision)&&(xEncounter >= xObject)&&(yEncounter <= yVision)&&(yEncounter >= yObject)
            return false;
        end;
    end;
    return true;
end
