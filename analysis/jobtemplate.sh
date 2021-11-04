#!/bin/bash
#PBS -q {{q}} 
#PBS -l walltime={{walltime}}
#PBS -l ncpus={{ncpus}}
#PBS -l mem={{mem}}
#PBS -N {{{name}}}
#PBS -l wd
#PBS -o {{{o}}}
#PBS -e {{{e}}} 

source {{{modules}}}

$HOME/.julia/bin/mpiexecjl --project={{{projectdir}}} -n {{n}}\
    julia -J {{{sysimage}}} -O3 --check-bounds=no -e\
      'using DriverGadi; DriverGadi.main(mode=:mpi,nc={{nc}},np={{np}},nr={{nr}},title="{{{title}}}")'

