using PackageCompiler

create_sysimage(:DriverGadi,
  sysimage_path=joinpath(@__DIR__,"..","DriverGadi.so"),
  precompile_execution_file=joinpath(@__DIR__,"warmup.jl"))

