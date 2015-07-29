function getSlopeAndBias(diffx,diffy,x,y)
    slope = diffy/diffx;
    bias = y-(slope*x);
    return (slope,bias)
end
