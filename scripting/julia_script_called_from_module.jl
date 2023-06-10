#=  ================================================================================================
    julia script called from module
    and returning a result

    usage:      julia --project=julia --startup-file=no julia_script_called_from_module.jl
    author:     mahiki@users.noreply.github.com
=   ===============================================================================================#

using DataFrames, Dates, CSV

df = DataFrame(flag = [0, 1, 0, 1, 0, 1]
    , boo = [false, true, false, true, false, true]
    , amt = [19.00, 11.00, 35.50, 32.50, 5.99, 5.99]
    , qty = [1, 4, 1, 3, 21, 109]
    , ship = [.50, .50, 1.50, .55, 0.0, 1.99]
    , item = ["B001", "B001", "B020", "B020", "BX00", "BX00"]
    , day = Date.(["2021-01-01", "2021-01-01", "2112-12-12", "2020-10-20", "2021-05-04", "1984-07-04"])
    )

CSV.write(stdout, df)