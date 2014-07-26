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
  
  for (i in 1:n.reps){
    group.1 = rnorm(n=n, mean=mean.1, sd=sd.common)
    group.2 = rnorm(n=n, mean=mean.2, sd=sd.common)
    p.vals[i] = t.test(group.x1, group.x2)$p.value
  }
  power = sum(p.vals < .05)/n.reps
  return(power)
}

###  Illustrate function usage for a single sample size

power.estimate <- t.power.sim(n=30,  n.reps=500,
                              mean.1=0.0,  mean.2=2.5,
                              sd.common=5.0)

writeLines(c(
"\n\n",
"   Estimated power for the t test\n",
"   ==============================", "\n",
"    Mean 1             =", sprintf("%8.4f", mean.1), "\n",
"    Mean 2             =", sprintf("%8.4f", mean.2), "\n",
"    Standard deviation =", sprintf("%8.4f", sd.common), "\n",
"    Sample size        =", sprintf("%8.0f", n), "\n",
"    Number of samples  =", sprintf("%8.0f", n.reps), "\n",
"   ==============================\n",
"   Estimated power     =", sprintf("%8.4f", power.estimate),
"\n"), "test.out", sep='')
