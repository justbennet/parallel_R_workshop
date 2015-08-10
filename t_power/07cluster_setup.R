library(Rmpi)
library(parallel)

#  NOTE:  You must run the initial R with
#  mpirun -np 1 ...
#  so that mpi.universe.size() is defined
#  Create an MPI cluster object that has P-1 processors

cl <- makeCluster(mpi.universe.size()-1, "MPI")

#  Just get the names of the nodes for testing purposes

#  Using the system() function, just to test
clusterCall(cl, function() system("hostname",intern=T))

#  Using R function most simple
clusterCall(cl, function() Sys.info()[c("nodename", "machine")])

#  Using R function and MPI functions
clusterCall(cl, function() paste("I am ", Sys.info()["nodename"], " rank ",
    mpi.comm.rank(), " of ", mpi.comm.size()))

stopCluster(cl)

mpi.quit()

