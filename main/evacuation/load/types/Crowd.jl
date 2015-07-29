type Crowd
    pedestrians::Vector{Pedestrian}
    function Crowd()
        new()
    end
    function Crowd(pedestrians::Vector)
        new(pedestrians)
    end
end
