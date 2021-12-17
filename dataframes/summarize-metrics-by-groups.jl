# EXAMPLE: aggregate by groups, general example from T Kwong
using DataFrames
using CSV

function download_titantic()
    url = "https://www.openml.org/data/get_csv/16826755/phpMYEkMl"
    return DataFrame(CSV.File(download(url); missingstring = "?"))
end

function summarize(df:AbstractDataFrame)
    return combine(groupby(df, [:pclass, :sex]),
        :age => mean ∘ skipmissing => :mean_age,
        :survived => sum => :survived
    )
end



# EXAMPLE: multiple aggregations, grouping by a column

# George Datseris on slack #data
mdf

# 505×5 DataFrame
#  Row │ step   infected  recovered  susceptible  ensemble 
#      │ Int64  Int64     Int64      Int64        Int64    
# ─────┼───────────────────────────────────────────────────
#    1 │     0         1          0           99         1
#    2 │     1         1          0           99         1
#    3 │     2         2          0           98         1
#    4 │     3         2          0           98         1
#    5 │     4         3          0           97         1
#    6 │     5         3          0           97         1
#    7 │     6         4          0           96         1
#    8 │     7         6          0           94         1
#    9 │     8         6          0           94         1
#   ⋮  │   ⋮       ⋮          ⋮           ⋮          ⋮
#  497 │    92         0        100            0         5
#  498 │    93         0        100            0         5
#  499 │    94         0        100            0         5
#  500 │    95         0        100            0         5
#  501 │    96         0        100            0         5
#  502 │    97         0        100            0         5
#  503 │    98         0        100            0         5
#  504 │    99         0        100            0         5
#  505 │   100         0        100            0         5


# naive solution
gdf = groupby(mdf, :ensemble)
    I = sum(df[!, :infected] for df in gdf) ./ 5
    R = sum(df[!, :recovered] for df in gdf) ./ 5
    S = sum(df[!, :susceptible] for df in gdf) ./ 5

# compute mean of metrics for each experimental group
#   Jack Shannon U021XA87N56 solution 
combine(groupby(df, :step), [:infected, :susceptible, :recovered] .=> mean .=> [:I, :S, :R])


# followup - great dataframe resources
https://bkamins.github.io/julialang/2020/12/24/minilanguage.html

# I also like Tom Kwong's DataFrames cheat sheet! There's a section on "Summarize Data" and "Group Datasets".
https://ahsmart.com/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v1.x_rev1.pdf

https://ahsmart.com/pub/data-wrangling-with-data-frames-jl-cheat-sheet/index.html