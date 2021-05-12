#==============================================================================
    "more flexible than other languages for object oriented programming"

    tested:     PASS
    author:     discourse.julialang.org/u/synxroform
 =============================================================================#

mutable struct MyStruct
    id::Int64
    name::String
end

function display(this::MyStruct)
    println("=> id:", this.id, " name:", this.name)
end

function merge(this::MyStruct, other::MyStruct)
    this.id += other.id
    this.name *= other.name
    return this
end

function Base.getproperty(this::MyStruct, name::Symbol)
    try
        f = eval(name)
        return (args...) -> f(this, args...)
    catch UndefVarError
        return Base.getfield(this, name)
    end 
end

m1 = MyStruct(123, "hello_")
m2 = MyStruct(456, "world")

m1.merge(m2)
m1.display()


#=  RESULTS
MyStruct(123, "hello_")
MyStruct(456, "world")
MyStruct(579, "hello_world")
=> id:579 name:hello_world
=#
