immutable Point
    x::Float64
    y::Float64
end

macro minus(arg1, arg2)
    :(Point($arg1.x - $arg2.x, $arg1.y - $arg2.y))
end

macro plus(arg1, arg2)
    :(Point($arg1.x + $arg2.x, $arg1.y + $arg2.y))
end

macro multiply(arg1, arg2)
    :(Point($arg1.x * $arg2.x, $arg1.y * $arg2.y))
end

macro multiplyFloat(arg1, arg2)
    :(Point($arg1.x * $arg2, $arg1.y * $arg2))
end

macro dot(arg1, arg2)
    :($arg1.x * $arg2.x + $arg1.y * $arg2.y)
end

macro length(arg1)
    :(sqrt($arg1.x * $arg1.x + $arg1.y * $arg1.y))
end

macro divideFloat(arg1, arg2)
    :(Point($arg1.x / $arg2, $arg1.y / $arg2))
end

#function teste(x)
#    return @length(Point(1.0,1.0))
#end
#teste(Point(1,2))
