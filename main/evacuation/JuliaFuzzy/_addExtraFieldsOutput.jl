function _addExtraFieldsOutput!(terms)
    push!(terms,Expr(:(::),:name,Symbol))
    push!(terms,Expr(:(::),:defuzzifier,Defuzzifier))
    push!(terms,Expr(:(::),:maxValue,:T))
    push!(terms,Expr(:(::),:minValue,:T))
    push!(terms,Expr(:(::),:termsActivation,:(Dict{Symbol,T})))
    #push!(terms,Expr(:(::),:termsName,:(Array{Symbol,1})))
    push!(terms,Expr(:(::),:fuzzyOutput,Accumulated))
    push!(terms,Expr(:(::),:lastValidOutput,:T))
    push!(terms,Expr(:(::),:_lockOutputRange,Bool))
    push!(terms,Expr(:(::),:_lockValidOutput,Bool))
    push!(terms,Expr(:(::),:_defaultValue,:T))
end
