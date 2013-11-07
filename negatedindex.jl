# typealias 


type NegatedIndex{T}
    idx::T
end

# type SubArray{T,N,A<:AbstractArray,I<:(RangeIndex...,)} <: AbstractArray{T,N}
#     parent::A
#     indexes::I
#     dims::Dims
#     strides::Array{Int,1}  # for accessing parent with linear indexes
#     first_index::Int


function negated_index(a::Vector, i::Integer)
	n = length(a)
	if !(1 <= i <= n)
        throw(BoundsError())
    end
    b = deepcopy(a)
    for k=1:n
        if k in i
            splice!(b, k)
        end
    end
    return b
end

function negated_index{T<:Integer}(a::Vector, r::Range1{T})
	n = length(a)
	if !(1 <= minimum(r) && maximum(r) <= n)
        throw(BoundsError())
    end
    b = deepcopy(a)
    c = 0
    for k=1:n
        if k in r
            splice!(b, k-c)
        	c += 1
        end
    end
    return b
end

function negated_index{T<:Integer}(a::Vector, v::Vector{T})
	n = length(a)
	if !(1 <= minimum(v) && maximum(v) <= n)
        throw(BoundsError())
    end
    b = deepcopy(a)
    c = 0
    for k=1:n
        if k in v
            splice!(b, k-c)
        	c += 1
        end
    end
    return b
end
