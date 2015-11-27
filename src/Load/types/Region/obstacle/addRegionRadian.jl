#using Debug
function addRegionRadian(regionRadians::Array{RegionRadian,1},region::RegionRadian)
    for regionRadian in regionRadians
        if !isInsideRegionRadian(regionRadian,angle)
            return true
        end
    end
end
