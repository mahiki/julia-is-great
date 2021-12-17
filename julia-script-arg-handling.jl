#!/usr/bin/env bash
#=
exec julia --color=yes --startup-file=no "${BASH_SOURCE[0]}" "$@"
=#

@show ARGS  # put any Julia code here
println("arg1:")
println(ARGS[1])

#=
$> sh /Users/merlinr/repo/julia-repos/julia-examples/julia-script-arg-handling.jl hello world
ARGS = ["hello", "world"]
=#
