# May be better to duck-type this and accept all {T}
#typealias RangeIndices Union(Integer, Range1{Integer}, Range{Integer})#, Array{Integer})

# Define new type for negated index of !idx

type NegatedIndex{T}
    idx::T
end

## Bounds checking ##
import Base.checkbounds
function checkbounds{T<:Integer}(sz::Integer, r::NegatedIndex{T})
    if r.idx < 1 || r.idx > sz
        throw(BoundsError())
    end
end

function checkbounds(sz::Integer, r::NegatedIndex)
    if !isempty(r.idx) && (minimum(r.idx) < 1 || maximum(r.idx) > sz)
        throw(BoundsError())
    end
end

# Works unless A has multiple dimentions 
function getindex{T<:Integer}(A::Array, r::NegatedIndex{T})
    n = length(A)
    checkbounds(n, r)
    b = deepcopy(A)
    splice!(b, r.idx)
    return b
end

# Works unless A has multiple dimentions
# Copies A, then splices out negated indices
function getindex(A::Array, r::NegatedIndex)
    n = length(A)
    checkbounds(n, r)
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

# Works unless A has multiple dimentions
# Copies A, only for non-negated indices
function getindex(A::Array, r::NegatedIndex)
    n = length(A)
    m = length(r)
    checkbounds(n, r)
    b = similar(A, n-m)
    c = 1
    for k=1:n
        if !(k in r)
            b[c] = A[k]
            c += 1
        end
    end
    return b
end


function getindex(r::NegatedIndex, x)
    r.idx[x]
end

# state = start(iterable)
# while !done(iterable, state)
#     element, state = next(iterable, state)
#     .. your code ..
# end

import Base.first
function first(r::NegatedIndex)
    first(r.idx)
end

import Base.length
function length(r::NegatedIndex)
    return length(r.idx)
end

import Base.in
function in{T<:Integer}(x, r::NegatedIndex{Range{T}})
    n = r.idx.step == 0 ? 1 : iround((x-first(r))/r.idx.step)+1
    n >= 1 && n <= length(r) && r[n] == x
end

function in(x, r::NegatedIndex)
    x >= first(r) && last(r) >= x
end

#function in(x, r::NegatedIndex{Range})

# Define operator ! to return a NegatedIndex type
(!)(r) = NegatedIndex(r)
# (!)(r::Range{Integer}) = NegatedIndex(r,r.step)
# (!)(r::Range1{Integer}) = NegatedIndex(r,1)
# (!)(r::Array{Integer}) = NegatedIndex(r,1)
(!)() = error("zero-argument ! is ambiguous")
