#using Debug
immutable RegionRadian
    start::Float64
    ender::Float64
    inversed::Bool
    function RegionRadian(angleA,angleB)
        if (angleA-angleB) > pi
            return new(max(angleA,angleB),min(angleA,angleB),true)
        else
            return new(min(angleA,angleB),max(angleA,angleB),false)
        end
    end
end
