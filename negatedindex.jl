module NI


# Define new type for negated index of !idx
immutable NegatedIndex{T}
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


# Copies A{T,1}, only for non-negated indices
function getindex{T}(A::Array{T,1}, r::NegatedIndex)
    n = length(A)
    m = length(r.idx)
    checkbounds(n,r)
    b = similar(A,n-m)
    c = 1
    for k = 1:n
        if k in r
            b[c] = A[k]
            c += 1
        end
    end
    return b
end

# Copies A{T,N}, only for non-negated indices
# NEED TO FIX THIS TO OUTPUT MULTI-DIM RESULTS!!
function getindex{T}(A::Array{T,N}, r::NegatedIndex)
    row,col = arraysize(A)
    n = length(A)
    m = length(r.idx)
    checkbounds(n,r)
    b = similar(A,n-m)
    c = 1
    for k = 1:n
        if k in r
            b[c] = A[k]
            c += 1
        end
    end
    return b
end

# Alternative to above, utilizing splice! to remove the negated indices
# function getindex(A::Array, r::NegatedIndex)
#     n = length(A)
#     checkbounds(n, r)
#     b = copy(A)
#     c = 0
#     for k=1:n
#         if k in r
#             splice!(b, k-c)
#             c += 1
#         end
#     end
#     return b
# end


Base.in(x,r::NegatedIndex) = !in(x,r.idx)


# Define operator ! to return a NegatedIndex type
(!)(r) = NegatedIndex(r)
(!)() = error("zero-argument ! is ambiguous")

end # module
NegatedIndex = NI.NegatedIndex
