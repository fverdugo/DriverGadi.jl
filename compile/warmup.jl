using DriverGadi
DriverGadi.main(mode=:mpi,np=(1,1),nc=(4,4),nr=1,title="warmup_2d")
DriverGadi.main(mode=:mpi,np=(1,1,1),nc=(4,4,4),nr=1,title="warmup_3d")
