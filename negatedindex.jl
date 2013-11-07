typealias RangeIndex Union(Int, Range{Int}, Range1{Int}, Array{Int})


type NegatedIndex{T,N,A,I<:(RangeIndex...,)}
	parent::A
    idx::I
end

# type SubArray{T,N,A<:AbstractArray,I<:(RangeIndex...,)} <: AbstractArray{T,N}
#     parent::A
#     indexes::I
#     dims::Dims
#     strides::Array{Int,1}  # for accessing parent with linear indexes
#     first_index::Int

# Type union of all valid types for the negated index input
#AllowedTypes = Union(Integer, Range{Integer}, Range1{Integer}, Vector{Int64}, Array{Int64}, Matrix{Int64})

function negated_index(A::Array, i::RangeIndex)
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

function getnegatedindex()

end
