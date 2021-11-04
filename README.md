# DriverGadi.jl


## Dependencies

See the `Manifest.toml` and `modules.sh`. The latter one assumes that I have installed julia 1.6.3 in a certain location of my home folder (Gadi-provided julia 1.6.1 failed to compile SpecialFunctions).

## Setup

```
$ source modules.sh
$ julia --project=.
(DriverGadi) pkg> instantiate
(DriverGadi) pkg> precompile
$ qsub compilejob.sh
```
After 10 minutes approx you will have a sys image called `DriverGadi.so`

## Analysis

### Generate jobs

```
$ cd analysis
$ julia --project=.
(analysis) pkg> instantiate
(analysis) pkg> precompile
julia> include("preparejobs.jl")
```

### Launch jobs

Now you can use `qsub` to launch the jobs files generated within the `analysys/data` folder.

### Postproces results

Still from the `analysis` folder:

```
$ julia --project=.
julia> include("postprojobs.jl")

[ Info: Scanning folder /home/552/fv3851/DriverGadi/analysis/data for result files.
[ Info: Added 43 entries.
8×9 DataFrame
 Row │ np     nparts  nc     rnorm        ngdofs    wct        ngcells   ir     path                              
     │ Int64  Int64   Int64  Float64      Int64     Float64    Int64     Int64  String                            
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     3      27    300  1.09205e-14  26730899  60.0855    27000000      1  /home/552/fv3851/DriverGadi/anal…
   2 │     4      64    300  1.09797e-14  26730899   8.23327   27000000      1  /home/552/fv3851/DriverGadi/anal…
   3 │     6     216    300  1.11691e-14  26730899   2.51944   27000000      1  /home/552/fv3851/DriverGadi/anal…
   4 │     7     343    300  1.13177e-14  26730899   1.90724   27000000      1  /home/552/fv3851/DriverGadi/anal…
   5 │     8     512    300  1.14182e-14  26730899   1.21634   27000000      1  /home/552/fv3851/DriverGadi/anal…
   6 │    11    1331    300  1.15883e-14  26730899   0.765556  27000000      1  /home/552/fv3851/DriverGadi/anal…
   7 │    13    2197    300  1.17594e-14  26730899   0.438914  27000000      1  /home/552/fv3851/DriverGadi/anal…
   8 │    16    4096    300  1.19602e-14  26730899   0.233472  27000000      1  /home/552/fv3851/DriverGadi/anal…
```



