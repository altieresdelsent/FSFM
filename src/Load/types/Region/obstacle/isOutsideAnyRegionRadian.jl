#using Debug
function isOutsideAnyRegionRadian(regionRadians::Array{RegionRadian,1},angle::Float64)
    for regionRadian in regionRadians
        if !isInsideRegionRadian(regionRadian,angle)
            return true
        end
    end
    return false
end
