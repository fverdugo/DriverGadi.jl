using DrWatson
using DataFrames
using BSON

raw = collect_results(datadir())

cols = eachcol(raw)

vals = map(values(cols)) do col
  map(col) do v
    if isa(v,NamedTuple)
      v.max
    elseif isa(v,Tuple)
      first(v)
    else
      v
    end
  end
end

dfmax = DataFrame(vals,keys(cols))
sort!(dfmax,[:np,:ir])

rows = eachrow(copy(dfmax))
dict = Dict{Tuple{Int,Int}}{Any}()
for row in rows
  key = (row.nc,row.np)
  if haskey(dict,key)
    prevrow = dict[key]
    for (k,v) in pairs(row)
      if v < prevrow[k]
        prevrow[k] = v
      end
    end
  else
    dict[key] = row
  end
end

df = DataFrame(collect(values(dict)))
sort!(df,order(:np,rev=false))


