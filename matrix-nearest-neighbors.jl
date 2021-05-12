#==============================================================================
    function to return all neighbors in arbitrary dimensions, from an index
        getneighbors is 2D version
        getnbs is N dimensional version

    tested:     YES
    author:     discourse.julialang.org/u/Crown421
 =============================================================================#

using   BenchmarkTools

function getneighbours(M, cartIdx, radius = 1)
    return [M[i,j] for i in cartIdx[1]-radius:cartIdx[1]+radius, j in cartIdx[2]-radius:cartIdx[2]+radius 
           if !((i == cartIdx[1]) & (j == cartIdx[2]))&& (1<= i <= size(M, 1)) && (1<= j <= size(M, 2))]
end

function getnbs(M, startIdx::CartesianIndex; radius = 1)
    idx = CartesianIndices(ntuple(i->(-radius:radius), ndims(M))) .+ startIdx
    idx = idx[:]
    deleteat!(idx, ceil(Int, length(idx)/2))
    filter!(id -> checkbounds(Bool, M, id) , idx)
    return M[idx]
end


M = LinearIndices((300,300))

# M = Int.(t)   # t not defined. not sure intention here, but works without it

testIdx = CartesianIndex((30,30))

nabes = getneighbours(M, testIdx)

display(@benchmark getneighbours(M, testIdx))
display(@benchmark getnbs(M, testIdx))
