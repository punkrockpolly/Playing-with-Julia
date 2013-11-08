typealias RangeIndices Union(Int, Range{Int}, Range1{Int}, Array{Int})


type NegatedIndex{T<:RangeIndices} <: RangeIndices
    idx::T
end


function getindex(A::Array, i::NegatedIndex)
	i = RangeIndices(i)
	n = length(A)
	if !(1 <= minimum(i) && maximum(i) <= n)
        throw(BoundsError())
    end
    b = deepcopy(A)
    c = 0
    for k=1:n
        if k in i
            splice!(b, k-c)
        	c += 1
        end
    end
    return b
end

copy(idx::RangeIndices) = idx

getindex(A::Array, i::NegatedIndex) = getindex(A,i)

!(A::Array,x::RangeIndices) = getindex(A, NegatedIndex(x))