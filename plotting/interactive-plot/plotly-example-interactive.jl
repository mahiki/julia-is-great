#=  ================================================================================================
    Example interactive plot on static HTML file
    PlotlyJS

    author:     https://discourse.julialang.org/t/pluto-plots-with-plotlybase-plotlyjs-with-working-static-html-export/61730/2
=   ===============================================================================================#

using PlotlyJS

begin
    n = 200
    r = LinRange(1e-4,10,n)
    k = LinRange(0,2π,n)
    g = r * cos.(k)'
    f = r * sin.(k)'
    z = (g.^2 .* f.^2) ./ (g.^4 + f.^4)
    #p5 = Plot(surface(x=g,y=f,z=z),Layout(width=700,height=500))
    p5 = Plot(surface(x=g,y=f,z=z))
end
