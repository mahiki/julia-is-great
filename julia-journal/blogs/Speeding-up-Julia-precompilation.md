# Speeding up Julia precompilation
An easy Tutorial on using PackageCompiler.jl to create a precompiled Custom Julia version

So perhaps you decided to try Julia, and you are finding it quite amazing. You like how easy it is to do linear algebra, to vectorize functions, to do meta-programming… But there is one thing that is bothering your. The precompilation time!

Every time you start a new Jupyter Notebook (or restarts your kernel), the time it takes to precompile “simple” packages, such as Plots.jl, is quite “large”, or at least, quite annoying. Well, recently I was introduced by a friend to a package called PackageCompiler.jl. This package allows you to create source files that already have your chosen packages precompiled, and you can then start Julia with this packages already ready to use.

Here is a brief tutorial on how to use PackageCompiler to create a version of Julia with Plots.jl and Flux.jl (a package for Machine Learning) already precompiled, thus, saving you quite sometime in your future Data Science project.

Note that you can easily use this same method that will presented to create source files with any package you want. Just beware that these source files can become quite large.

## Installing PackageCompiler and create a source file

First of all, create an specific folder to store your Julia source files. For example, “/home/username/JuliaImages”. Then, run your Jupyter Notebook with Julia, or, start a REPL, then, install PackageCompiler by running:

```julia
using Pkg
Pkg.add(“PackageCompiler”)
Now, in the same file, you can run the following commands to create your source file.

using PackageCompiler, IJulia, Flux, Plotscreate_sysimage([:Flux,:Plots],sysimage_path=”/home/username/JuliaImages/sys_flux_plots.so”)
This will create the file “sys_flux_plots.so” in the chosen directory. If you don’t specify a directory, this command will create the source file in the same folder that you ran your REPL.
```

With these simple commands, you can already run a Julia in your terminal with the precompiled packages. Hop in your terminal and run:

```julia
julia --sysimage "sys_flux_plots.so"
Adding new kernel to Jupyter Lab
```

Now, the only thing left to do to create a kernel and add it to your Jupyter Lab (or Jupyter Notebook, it works the same way).

Go back to your Julia session running in your notebook (or the REPL) that you used to create the source file. Then, run the following command:

```julia
IJulia.installkernel(“Julia Flux Plots”, “--sysimage=/home/username/JuliaImages/sys_flux_plots.so”)
All set! Now the new kernel with the name “Julia Flux Plots” should be available as an option.
```

Putting everything together…

If things got confused with the mix of code and text, here are the complete commands you need to run in your Julia session to get everything working.

```julia
using Pkg
Pkg.add(“PackageCompiler”)
using PackageCompiler, IJulia, Flux, Plotscreate_sysimage([:Flux,:Plots],sysimage_path=”/home/username/JuliaImages/sys_flux_plots.so”)IJulia.installkernel(“Julia Flux Plots”, “--sysimage=/home/username/JuliaImages/sys_flux_plots.so”)
```

With this, I hope you can enjoy Julia a bit more.