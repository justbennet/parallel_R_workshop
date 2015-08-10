library(ggplot2)
library(parallel)

#########################################
###  Function to calculate power for a t test
###
###  Create a function to simulate two normal populations n times,
###  run a t test, and return the estimated power for that combination
###  of parameters.
###  Arguments:  sample size, number of repetitions, mean of first population
###              mean of second population, and common standard deviation
###  Return:     estimated power for the generated sample and criteria
###

t.power.sim = function(n, n.reps=1000, mean.1=0.0, mean.2=2.5, sd.common=1.0) {
  p.vals = rep(0,n.reps)

  for (i in 1:n.reps) {
    group.1 = rnorm(n=n, mean=mean.1, sd=sd.common)
    group.2 = rnorm(n=n, mean=mean.2, sd=sd.common)
    p.vals[i] = t.test(group.1, group.2)$p.value
  }
  power = sum(p.vals < .05)/n.reps
  return(power)
}

###  Cluster setup
#  NOTE:  You must run the initial R with
#  mpirun -np 1 ...
#  so that mpi.universe.size() is defined
cl <- makeCluster(mpi.universe.size()-1, "MPI")

#  Make sure we really have workers...
clusterCall(cl, function() paste("I am ", Sys.info()["nodename"], " rank ",
    mpi.comm.rank(), " of ", mpi.comm.size()))

#  Create a vector of sample sizes for which we want to estimate the power
sample.sizes <- seq.int(20, 100, 5)

#  Send the sample sizes to the nodes so they can be used
#  clusterExport(cl, list("sample.sizes"))

#  Use lapply the t.power.sim function for each value in sample.sizes
power.list <- parLapply(cl, sample.sizes, t.power.sim,
                     n.reps=1000, mean.1=0.0, mean.2=2.5, sd.common=5.0)

###  Cluster shutdown
###  Make sure to end the script with mpi.quit() to properly close
###  the MPI connections.
stopCluster(cl)

#  Join power.list and sample.sizes into a data frame
power.dat <- data.frame(n=sample.sizes, power=unlist(power.list))

#  Print the values in a table
writeLines(c(
"\n\n",
"Table of values from the power calculation using parLapply",
"==========================================================",
capture.output(print(power.dat)),
"==========================================================\n\n"),
"test.out", sep="\n")

#  It is quite common to plot the power against the sample size
#  Power >= .80 is usually considered 'good'
pdf("power.pdf", height=4, width=4)
power.graph = ggplot(power.dat, aes(x=n, y=power)) + geom_point()
power.graph = power.graph + scale_x_continuous("Sample size", limits=c(20,100))
power.graph = power.graph + scale_y_continuous("Power", limits=c(0,1))
power.graph = power.graph + geom_hline(yintercept=0.8, linetype="solid")
power.graph
dev.off()

#  Close the MPI connections
mpi.quit()

