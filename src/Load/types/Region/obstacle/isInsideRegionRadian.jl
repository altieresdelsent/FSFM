#using Debug
function isInsideRegionRadian(regionRadian::RegionRadian,angle::Float64)
    return regionRadian.start >= angle && regionRadian.ender <= angle
end
function isInsideRegionRadian(regionRadian::RegionRadian,test::RegionRadian)
    return regionRadian.start >= test.start && regionRadian.ender <= test.ender
end
