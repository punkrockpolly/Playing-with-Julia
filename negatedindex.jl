typealias RangeIndices Union(Int, Range1{Int})


type NegatedIndex{T<:RangeIndices}
    idx::T
    # step::Int
    # len::Int

    # function NegatedIndex(idx)
    #     len = length(idx::T)
    #     new(idx, 1, len)
    # end
end

function getindex(A::Array, idx::NegatedIndex)
    n = length(A)
    if !(1 <= min(idx) && max(idx) <= n)
        throw(BoundsError())
    end
    b = deepcopy(A)
    c = 0
    for k=1:n
        if k in idx  #for i in fullindex(idx, size(A,n))
            splice!(b, k-c)
            c += 1
        end
    end
    return b
end

step(r::NegatedIndex) = r.step

function in(x, r::NegatedIndex)
    n = step(r) == 0 ? 1 : iround((x-first(r))/step(r))+1
    n >= 1 && n <= r.len && r[n] == x
end

function minimum(idx::NegatedIndex)
    len = length(idx::T)
    m = idx[1]
    for x=1:len
        if idx[x] < m
            m = idx[x]
    return m
    end
end

function maximum(idx::NegatedIndex)
    len = length(idx::T)
    m = idx[1]
    for x=1:len
        if idx[x] < m
            m = idx[x]
    return m
    end
end

## Bounds checking ##
function checkbounds(idx::NegatedIndex, A::Array)
    I = to_index(idx)
    if I < 1 || I > sz
        throw(BoundsError())
    end
end

(!)(x::Int) = NegatedIndex(x)
# (!)(x::Range{Int}) = NegatedIndex(x)
(!)(x::Range1{Int}) = NegatedIndex(x)
# (!)(x::Array{Int}) = NegatedIndex(x)
