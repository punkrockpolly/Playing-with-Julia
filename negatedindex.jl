typealias RangeIndices Union(Int, Range{Int}, Range1{Int}, Array{Int})


type NegatedIndex{T<:RangeIndices}
    idx::T
end


function getindex(A::Array, idx::NegatedIndex)
	n = length(A)
	if !(1 <= minimum(idx) && maximum(idx) <= n)
        throw(BoundsError())
    end
    b = deepcopy(A)
    c = 0
    for k=1:n
        if k in idx
            splice!(b, k-c)
        	c += 1
        end
    end
    return b
end

getindex(A::Array, idx::NegatedIndex) = getindex(A,idx)

!(x::Int) = NegatedIndex(x)
!(x::Range{Int}) = NegatedIndex(x)
!(x::Range1{Int}) = NegatedIndex(x)
!(x::Array{Int}) = NegatedIndex(x)