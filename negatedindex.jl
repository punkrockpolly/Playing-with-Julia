typealias RangeIndices Union(Int, Range1{Int}, Range{Int})#, Array{Int})

# Define new type to handle negated index of !idx
type NegatedIndex{T<:RangeIndices}
    idx::T
    step::Int
end

# Works unless A has multiple dimentions, because splice only works for Array{Int64,1} 
function getindex(A::Array, r::NegatedIndex)
    n = length(A)
    if !(1 <= minimum(r.idx) && maximum(r.idx) <= n)
        throw(BoundsError())
    end
    b = deepcopy(A)
    c = 0
    for k=1:n
        if k in r
            splice!(b, k-c)
            c += 1
        end
    end
    return b
end

function getindex(r::NegatedIndex, x)
    r.idx[x]
end

import Base.first
function first(r::NegatedIndex)
    first(r.idx)
end

import Base.length
function length(r::NegatedIndex)
    return length(r.idx)
end

function in(x, r::NegatedIndex)
    n = r.step == 0 ? 1 : iround((x-first(r))/r.step)+1
    n >= 1 && n <= length(r) && r[n] == x
end

# Define operator ! to return a NegatedIndex type
(!)(r::Int) = NegatedIndex(r,1)
(!)(r::Range{Int}) = NegatedIndex(r,r.step)
(!)(r::Range1{Int}) = NegatedIndex(r,1)
# (!)(r::Array{Int}) = NegatedIndex(r,1)
