module DriverGadi

using Gridap
using GridapDistributed
using PartitionedArrays
using LinearAlgebra
using FileIO

function main(;
  mode::Symbol,
  nc::Tuple,
  np::Tuple,
  nr::Integer,
  title::AbstractString,
  k::Integer=1,
  verbose::Bool=true)

  mode in (:seq,:mpi) || throw(ArgumentError("mode should be :mpi or :seq"))
  length(np) == length(nc) || throw(ArgumentError("np and np must be of same length"))
  backend = mode == :mpi ? mpi : sequential
  prun(backend,np) do parts
    for ir in 1:nr
      str_r = lpad(ir,ceil(Int,log10(nr)),'0')
      title_r = "$(title)_ir$(str_r)"
      _main(parts,nc,title_r,ir,k,verbose)
    end
  end
end

u_2d(x) = x[1]+x[2]
u_3d(x) = x[1]+x[2]+x[3]

function _main(parts,nc,title,ir,k,verbose)

  t = PTimer(parts,verbose=verbose)
  tic!(t)

  domain_2d = (0,1,0,1)
  domain_3d = (0,1,0,1,0,1)
  np = size(parts)

  domain = length(nc) == 3 ? domain_3d : domain_2d
  u = length(nc) == 3 ? u_3d : u_2d

  model = CartesianDiscreteModel(parts,domain,nc)
  Ω = Interior(model)
  dΩ  = Measure(Ω,2*k)
  reffe = ReferenceFE(lagrangian,Float64,k)
  V = TestFESpace(model,reffe,dirichlet_tags="boundary")
  U = TrialFESpace(u,V)
  uh = interpolate(u,U)
  a(u,v) = ∫(∇(u)⋅∇(v))dΩ
  l(v) = 0
  op = AffineFEOperator(a,l,U,V)
  A = get_matrix(op)
  b = get_vector(op)
  x_fe = get_free_dof_values(uh)
  x = similar(b,eltype(b),axes(A,2))
  x .= x_fe
  r = similar(b)
  mul!(r,A,x)
  r .= r .- b
  rnorm = norm(r)
  toc!(t,"wct")

  display(t)

  ngdofs = length(V.gids)
  ngcells = length(model.gids)
  nparts = length(parts)
  map_main(t.data) do data
    out = Dict{String,Any}()
    merge!(out,data)
    out["rnorm"] = rnorm
    out["nparts"] = nparts
    out["ngdofs"] = ngdofs
    out["ngcells"] = ngcells
    out["nc"] = nc
    out["np"] = np
    out["ir"] = ir
    save("$title.bson",out)
  end

  nothing

end

end # module
