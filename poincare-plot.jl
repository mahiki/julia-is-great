#==============================================================================
    Poincare plot example
        event based simulation of chaotic spiking neural network
        of quadratic integrate-and-fire neurons

    tested:     PASS (and it is fucking sweet)
    author:     discourse.julialang.org/u/RainerEngelken
 =============================================================================#

using   PyPlot
using   StaticArrays

function poincare()
    n,ϕ,𝚽=SMatrix{3,3}(0 .<[0 0 0;1 0 1;0 1 0]),randn(3),[]     # define adjacency matrix, initialize network
    for s=1:8^7                                                 # number of spikes in calculation
        m,j=findmax(ϕ)                                          # find next spiking neuron j
        ϕ.+=π/2-m                                               # evolve phases till next spike time
        ϕ[n[:,j]],ϕ[j]=atan.(tan.(ϕ[n[:,j]]).-1),-π/2           # update postsynaptic neurons, reset spiking neuron
        j==1 && append!(𝚽,ϕ[2:3])                               # save neuron 2 & 3 whenever neuron 1 spikes
    end
    plot(𝚽[1:2:end],𝚽[2:2:end],".k",ms=.1);axis("off")
end
