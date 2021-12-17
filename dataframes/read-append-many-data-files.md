# Partitioned file read to dataframes use-case
This is another example of why I should package up my partitioned reader.

* CSV has added the `source` feature which may help
* the community can provide efficiency feedback
* test on nested partition 100s of files

## MANY FILES TO READ
>I have about 120 csv files to read, transform (group by aggregates), and append the data to one large dataframe

### Solution: mapreduce
A: Peter Deffebach
You can do `mapreduce(f, vcat, files)` where `f` does all of your reading and data cleaning etc.
If you have all the data frames in a vector, you can do `reduce(vcat, dfs)`

@bkamins: `reduce` of pre-processed data frames will be more efficient than `mapreduce`

```jl
# f accepts a file name and returns a data frame

function f(filename)
   df = CSV.read(filename, DataFrame)
    @chain df begin 
        @transform ...
        @select ...
     end
end

big_df = mapreduce(f, vcat, [collection of filenames])
```

### Alternate 2
Vasu Chaudhary:
this is what i am using (not sure if its most efficient), ofcourse map your transformation fn after step 2

```jl
list_files = glob("*.csv", "data/covariates")
covariates = CSV.read.(list_files, DataFrame) ## read all of them
covariates = vcat(covariates...) ## concat into one 
```

### Plot twist: @affans needs partition columns
Affan:
>@Nick well unfortunately, for each file I need to append a column to differentiate that file's content for  later processing... the context is that I have state-level data stored in separate CSV files, and I'd like to just convert this to one large csv (with some processing), but still having a column for state for state-level analysis/grouping later on

Nick Robinson:
might be worth checking out the source= keyword, to check if it's sufficient for your need
https://csv.juliadata.org/latest/reading.html#source
e.g. is it's just a  simple function of the filename

```jl
list_of_files = ["ak.csv", "al.csv", ...]
df = CSV.read(list_of_files, DataFrame; source = :state => first.(splitext.(list_of_files)))
```
